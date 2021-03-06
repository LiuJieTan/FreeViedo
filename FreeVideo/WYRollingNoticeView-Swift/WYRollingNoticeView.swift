//
//  WYRollingNoticeView.swift
//  RollingNotice-Swift
//
//  Created by qm on 2017/12/13.
//  Copyright © 2017年 qm. All rights reserved.
//

import UIKit

@objc public protocol WYRollingNoticeViewDataSource : NSObjectProtocol {
    func numberOfRowsFor(roolingView: WYRollingNoticeView) -> Int
    func rollingNoticeView(roolingView: WYRollingNoticeView, cellAtIndex index: Int) -> WYNoticeViewCell
}

@objc public protocol WYRollingNoticeViewDelegate: NSObjectProtocol {
    @objc optional func rollingNoticeView(_ roolingView: WYRollingNoticeView, didClickAt index: Int)
}


open class WYRollingNoticeView: UIView {
    weak open var dataSource : WYRollingNoticeViewDataSource?
    weak open var delegate : WYRollingNoticeViewDelegate?
    //等待时间
    open var stayInterval = 3.0
    
    // MARK: private properties
    private lazy var wyTapGesture = {() -> UITapGestureRecognizer in
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(WYRollingNoticeView.handleCellTapAction))
        return tap
    }()
    private lazy var cellClsDict: Dictionary = { () -> [String : Any] in
        var tempDict = Dictionary<String, Any>()
        return tempDict
    }()
    private lazy var reuseCells: Array = { () -> [WYNoticeViewCell] in
        var tempArr = Array<WYNoticeViewCell>()
        return tempArr
    }()
    
    private var timer: Timer?
    private var currentIndex = 0
    private var currentCell: WYNoticeViewCell?
    private var willShowCell: WYNoticeViewCell?
    private var isAnimating = false
    
    // MARK: -
    open func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = cellClass
    }
    
    open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = nib
    }
    
    open func dequeueReusableCell(withIdentifier identifier: String) -> WYNoticeViewCell? {
        for cell in self.reuseCells {
            if cell.reuseIdentifier!.elementsEqual(identifier) {
                return cell
            }
        }
        
        if let cellCls = self.cellClsDict[identifier] {
            if let nib = cellCls as? UINib {
                let arr = nib.instantiate(withOwner: nil, options: nil)
                let cell = arr.first as! WYNoticeViewCell
                cell.setValue(identifier, forKeyPath: "reuseIdentifier")
                return cell
            }
            
            if let noticeCellCls = cellCls as? WYNoticeViewCell.Type {
                let cell = noticeCellCls.self.init(reuseIdentifier: identifier)
                return cell
            }
            
        }
        return nil
    }
    
    open func reloadDataAndStartRoll() {
        stopRoll()
        layoutCurrentCellAndWillShowCell()
        
        let count = self.dataSource?.numberOfRowsFor(roolingView: self)
        
        guard count! >= 2 else {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: stayInterval, target: self, selector: #selector(WYRollingNoticeView.timerHandle), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    // 在合适的地方停止timer。 you must stop it when not use,for example '-viewDidDismiss'
    open func stopRoll() {
        
        if let rollTimer = timer {
            rollTimer.invalidate()
            timer = nil
        }
        
        isAnimating = false
        currentIndex = 0
        currentCell?.removeFromSuperview()
        willShowCell?.removeFromSuperview()
        currentCell = nil
        willShowCell = nil
        self.reuseCells.removeAll()
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.addGestureRecognizer(self.wyTapGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.addGestureRecognizer(self.wyTapGesture)
    }
    
}

// MARK: private funcs
extension WYRollingNoticeView{
    
    @objc fileprivate func timerHandle() {
        if isAnimating {
            return
        }
        layoutCurrentCellAndWillShowCell()
        currentIndex += 1
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        isAnimating = true
        UIView.animate(withDuration: 0.5, animations: {
            self.currentCell?.frame = CGRect.init(x: 0, y: -h, width: w, height: h)
            self.willShowCell?.frame = CGRect.init(x: 0, y: 0, width: w, height: h)
        }) { (flag) in
            if let cell0 = self.currentCell, let cell1 = self.willShowCell {
                self.reuseCells.append(cell0)
                cell0.removeFromSuperview()
                self.currentCell = cell1
            }
            self.isAnimating = false
        }
    }
    
    
    fileprivate func layoutCurrentCellAndWillShowCell() {
        let count = (self.dataSource?.numberOfRowsFor(roolingView: self))!
        
        if (currentIndex > count - 1) {
            currentIndex = 0
        }
        
        var willShowIndex = currentIndex + 1
        if (willShowIndex > count - 1) {
            willShowIndex = 0
        }
        //    print(">>>>%d", currentIndex)
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
//        print("count: \(count),  currentIndex:\(currentIndex)  willShowIndex: \(willShowIndex)")
        
        if currentCell == nil {
            // 第一次没有currentcell
            // currentcell is null at first time
            currentCell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: currentIndex)
            currentCell!.frame  = CGRect.init(x: 0, y: 0, width: w, height: h)
            self.addSubview(currentCell!)
            return
        }
        
        
        willShowCell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: willShowIndex)
        willShowCell?.frame = CGRect.init(x: 0, y: h, width: w, height: h)
        self.addSubview(willShowCell!)
        
        if WYRollingDebugLog {
            print("currentCell  %p", currentCell!)
            print("willShowCell %p", willShowCell!)
        }
        
        let currentCellIdx = self.reuseCells.index(of: currentCell!)
        let willShowCellIdx = self.reuseCells.index(of: willShowCell!)
        
        if let index = currentCellIdx {
            self.reuseCells.remove(at: index)
        }
        
        if let index = willShowCellIdx {
            self.reuseCells.remove(at: index)
        }
        
    }
    
    @objc fileprivate func handleCellTapAction(){
        let count = self.dataSource?.numberOfRowsFor(roolingView: self)
        
        if (currentIndex > count! - 1) {
            currentIndex = 0;
        }
        self.delegate?.rollingNoticeView?(self, didClickAt: currentIndex)
    }
}
