//
//  AlertController.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/12.
//  Copyright © 2018 微向暖年未央. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlertController: UIViewController, UITableViewDataSource, UITableViewDelegate{
 
    var darkView: UIView! // 声明一个View
    var mbt:UIButton!
    var dissBtn: UIButton!
    var statusH:CGFloat = 0;
    
    var videoParseCell = [MYTableViewCell]()
    
    var videoUrl = Array<String>(repeating:"",count:parseListNameStr.count)
    var parseName = Array<String>(repeating:"",count:parseListNameStr.count)
    
    var videoTitleString:String?
    var videoUrlString:String = ""
    
    var videoListTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom
        
        statusH = UIApplication.shared.statusBarFrame.height
        
        dissBtn = UIButton(frame: CGRect(x: 0, y: statusH, width: 40, height: 40))
        dissBtn.setBackgroundImage(UIImage(named:"dissImg"), for: .normal)
        dissBtn.alpha = 0.6
        dissBtn.addTarget(self, action: #selector(dissSegue), for: .touchUpInside)

        self.view.addSubview(dissBtn)
        
        //创建显示播放列表
        showVideoList()
    }
    
    //退回上个界面
    @objc func dissSegue(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func showVideoList() -> Void {
         createPanel();
    }
    
    func createPanel() -> Void {
        let panel = UIView(frame: CGRect(x: 0, y: (UIScreen.main.bounds.height*3)/5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100))
    
        panel.backgroundColor = UIColor.white
        let videoTitle = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        videoTitle.text = videoTitleString ?? "数据拉取失败"
        videoTitle.textAlignment = .center
        self.view.addSubview(panel)
        panel.addSubview(videoTitle)
        
        videoListTableView = UITableView(frame: CGRect(x: 0, y: 35, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 35))
        //设置不可滑动超过屏幕防止重用
        videoListTableView.isScrollEnabled = false
        
        videoListTableView.separatorStyle = .none
        videoListTableView.dataSource = self
        videoListTableView.delegate = self
        videoListTableView.register(UINib(nibName:"MYTableViewCell", bundle:nil), forCellReuseIdentifier: "myvideoCell")
        panel.addSubview(videoListTableView)
        print("*******************\(String(describing: videoUrlString))******\(String(describing: videoTitleString))")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseListNameStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = videoListTableView.dequeueReusableCell(withIdentifier: "myvideoCell") as! MYTableViewCell
         videoParseCell.append(cell)
//      cell.isUserInteractionEnabled = false//设置cell不可点击
        cell.selectionStyle = UITableViewCellSelectionStyle.none//设置点击没有阴影效果
        cell.videoParseName.text = parseListNameStr[indexPath.row]["name"].stringValue
        //设置所有按钮不可点击
        cell.videoRefresh.isEnabled = false
        cell.videoPlayOne.isEnabled = false
        cell.videoPlayTwo.isEnabled = false
        cell.videoDownLoad.isEnabled = false
        
        cell.videoProgress.progress = 0.1

        pressRefresh(cell:cell, indexPath:indexPath)//刷新
        
       
        if (videoUrlString.contains("qq")) {
            print("qq")
        }else if (videoUrlString.contains("youku")){
            print("youku")
        }else if (videoUrlString.contains("iqiyi")){
            print("iqiyi")
        }else if (videoUrlString.contains("mgtv")){
            print("mgtv")
        }else{
            print("others")
        }
        return cell
    }
    
    //加载与刷新的逻辑实现
    @objc func pressRefresh(cell:MYTableViewCell,indexPath:IndexPath){
        let index = indexPath.row
        parseListProvider.request(.parseVideo(parseListNameStr[index]["url"].stringValue,videoUrlString), progress: { (progress) in
            print("进度：\(progress.progress)")
            cell.videoProgress.progress = Float(progress.progress)
            
        }) { (result) in
            if case let .success(response) = result{
                
                if response.statusCode == 200{
                    print("200")
                    //                                    print(try?response.mapString())
                    self.videoUrl[index] = parseListNameStr[index]["url"].stringValue+"?url="+self.videoUrlString
                    self.parseName[index] = parseListNameStr[index]["parseName"].stringValue
                    print("<><<><><><\(parseListNameStr[index]["url"].stringValue+"?url="+self.videoUrlString)")
                    cell.videoRefresh.isEnabled = true
                    cell.videoPlayOne.isEnabled = true
                    cell.videoProgress.progress = 1.0
                    
                    cell.videoPlayOne.tag = index
                    cell.videoRefresh.tag = index
                    cell.videoPlayTwo.tag = index
                    cell.videoRefresh.addTarget(self, action: #selector(self.pressRefresh1(_:)), for: .touchUpInside)
                    cell.videoPlayOne.addTarget(self, action: #selector(self.pressPlayOne(_:)), for: .touchUpInside)
                }
                cell.videoRefresh.isEnabled = true
            }
            if case let .failure(error) = result{
                print("失败。。。。。。。。。。。\(error)")
            }
            cell.videoRefresh.isEnabled = true
        }
    }
    
    //加载与刷新的逻辑实现
    @objc func pressRefresh1(_ btn:UIButton){
        let index = btn.tag
        let cell = videoParseCell[index]
        print("cell superview is \(cell)")
        cell.videoProgress.progress = 0.0
        parseListProvider.request(.parseVideo(parseListNameStr[index]["url"].stringValue,videoUrlString), progress: { (progress) in
            print("进度：\(progress.progress)")
            cell.videoProgress.progress = Float(progress.progress)
        }) { (result) in
            if case let .success(response) = result{
                if response.statusCode == 200{
                    print("200")
                    //                                    print(try?response.mapString())
                    self.videoUrl[index] = parseListNameStr[index]["url"].stringValue+"?url="+self.videoUrlString
                    self.parseName[index] = parseListNameStr[index]["parseName"].stringValue
                    print("<><<><><><\(parseListNameStr[index]["url"].stringValue+"?url="+self.videoUrlString)")
                    cell.videoRefresh.isEnabled = true
                    cell.videoPlayOne.isEnabled = true

                    cell.videoPlayOne.tag = index
                    cell.videoRefresh.tag = index
                    cell.videoPlayTwo.tag = index
                    cell.videoRefresh.addTarget(self, action: #selector(self.pressRefresh1(_:)), for: .touchUpInside)
                    cell.videoPlayOne.addTarget(self, action: #selector(self.pressPlayOne(_:)), for: .touchUpInside)
                }
                cell.videoRefresh.isEnabled = true
            }
            if case let .failure(error) = result{
                print("失败。。。。。。。。。。。\(error)")
            }
            cell.videoRefresh.isEnabled = true
        }
    }
    
    //播放1的逻辑实现
    @objc func pressPlayOne(_ btn:UIButton) -> Void{
        print("\(self.videoUrl[btn.tag])")
        let vc = ThirdViewController()
        vc.requestUrl = self.videoUrl[btn.tag]
        print("requestUrl.....\(vc.requestUrl)")
        vc.parseName = self.parseName[btn.tag]
        print("vc.parseName.....\(vc.parseName)")

        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}

