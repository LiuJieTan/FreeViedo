//
//  ViewController.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/10.
//  Copyright © 2018年 微向暖年未央. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

//    var noticeListArray: Array<Any>?
    var noticeListArrayName: Array<String> = []
    var noticeListArrayUrl: [String] = []

    var noticeView0: WYRollingNoticeView?

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!

    private let image = ["http://is1.mzstatic.com/image/thumb/Purple128/v4/58/1a/f7/581af7b3-7f11-0a41-2bf1-7c7af18bec02/source/175x175bb.jpg",
                         "http://is1.mzstatic.com/image/thumb/Purple118/v4/68/cf/ae/68cfaee2-0840-04fc-2beb-591183b2bc7f/source/175x175bb.jpg",
                         "http://is4.mzstatic.com/image/thumb/Purple128/v4/52/61/9f/52619f51-c790-2e72-fc9d-b2c1e9b446a5/source/175x175bb.jpg",
                         "http://is4.mzstatic.com/image/thumb/Purple128/v4/9f/aa/c9/9faac94f-6a85-fc99-da66-28c0778ce5b0/source/175x175bb.jpg"]
    private let videoUrl = ["https://v.qq.com/",
                            "http://www.youku.com/",
                            "http://www.iqiyi.com/",
                            "https://www.mgtv.com/"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        networkRequire() //提示
        let itemL = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: nil)
        let itemR=UIBarButtonItem(title: "关于", style: UIBarButtonItemStyle.plain, target: self, action: #selector(itemRBtn))
        itemR.tintColor = UIColor.blue
        self.navigationItem.leftBarButtonItem = itemL
        self.navigationItem.rightBarButtonItem = itemR
//        let nav = UINavigationBar.appearance()
//        nav.tintColor = UIColor.green
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0x43/255, green: 0xCD/255, blue: 0x80/255, alpha: 1.0)
        self.title = "首页"
        
       if let urstr = NSURL(string: image[0]){
            if let data = NSData(contentsOf: urstr as URL){
                image1.image = UIImage(data: data as Data)
        }}
        if let urstr = NSURL(string: image[1]){
            if let data = NSData(contentsOf: urstr as URL){
                image2.image = UIImage(data: data as Data)
            }}
        if let urstr = NSURL(string: image[2]){
            if let data = NSData(contentsOf: urstr as URL){
                image3.image = UIImage(data: data as Data)
            }}
        if let urstr = NSURL(string: image[3]){
            if let data = NSData(contentsOf: urstr as URL){
                image4.image = UIImage(data: data as Data)
            }}

        //开交互
        image1.isUserInteractionEnabled = true
        image1.tag = 1;
        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(sender:)))
        image1.addGestureRecognizer(singleTap1)

        //开交互
        image2.isUserInteractionEnabled = true
        image2.tag = 2;
        let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(sender: )))
        image2.addGestureRecognizer(singleTap2)

        //开交互
        image3.isUserInteractionEnabled = true
       image3.tag = 3;
        let singleTap3 = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(sender: )))
        image3.addGestureRecognizer(singleTap3)

        //开交互
        image4.isUserInteractionEnabled = true
        image4.tag = 4;
        let singleTap4 = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(sender: )))
        image4.addGestureRecognizer(singleTap4)
        
        //申请parseList名称
        parseListNamefun()
        
        let aa = fileSizeOfCache()
        print("缓存大小\(aa)")
        clearCache()
    }
    
    //网络请求
    func networkRequire() -> Void {
        parseListProvider.request(parseList.noticeList) { (result) in
            if case let .success(response) = result{
                if response.statusCode == 200{
                    if let data = try?response.mapJSON(){
                        for item in JSON(data)["source"].arrayValue{
                            self.noticeListArrayName.append(item["name"].stringValue)
                            self.noticeListArrayUrl.append(item["url"].stringValue)
                        }
                        print("\(self.noticeListArrayName)")
                        self.creatRoolingViewWith(arr: self.noticeListArrayName)
                    }
                }
            }
        }
    }
    
    func parseListNamefun() -> Void {
        parseListProvider.request(.parseListName) { (result) in
            if case let .success(response) = result{
                let data = try? response.mapJSON()
                parseListNameStr = JSON(data!)["source"].arrayValue
            }
        }
    }
    
    //关于按钮
    @objc func itemRBtn(){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "about") as! AboutViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func singleTapAction(sender:UITapGestureRecognizer)->Void {     //跳转到secondController 各大视频网站界面 tag = 1
//        print("\(sender.view?.tag)<><><>><><><>")
           let sb = UIStoryboard(name: "Main", bundle:nil)
           let vc = sb.instantiateViewController(withIdentifier: "second") as! SecondViewController
               vc.viewTag = 1;
    if let tag = sender.view?.tag{
        switch tag{
        case 1:
            vc.requestUrl = videoUrl[0]
        case 2:
            vc.requestUrl = videoUrl[1]
        case 3:
            vc.requestUrl = videoUrl[2]
        case 4:
            vc.requestUrl = videoUrl[3]
        default:
            vc.requestUrl = "http://119.28.128.227/notice.html"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func fileSizeOfCache()-> Int {
//
//        // 取出cache文件夹目录 缓存文件都在这个目录下
//        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
//        //缓存目录路径
//        print(cachePath)
//
//        // 取出文件夹下所有文件数组
//        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
//
//        //快速枚举出所有文件名 计算文件大小
//        var size = 0
//        for file in fileArr! {
//
//            // 把文件名拼接到路径中
//            let path = cachePath?.appending("/\(file)")
//            // 取出文件属性
//            let floder = try! FileManager.default.attributesOfItem(atPath: path!)
//            // 用元组取出文件大小属性
//            for (abc, bcd) in floder {
//                // 累加文件大小
//                if abc == FileAttributeKey.size {
//                    size += (bcd as AnyObject).integerValue
//                }
//            }
//        }
//
//        let mm = size / 1024 / 1024
//
//        return mm
//    }
//
//    func clearCache() {
//
//        // 取出cache文件夹目录 缓存文件都在这个目录下
//        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
//
//        // 取出文件夹下所有文件数组
//        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
//
//        // 遍历删除
//        for file in fileArr! {
//
//            let path = cachePath?.appending("/\(file)")
//            if FileManager.default.fileExists(atPath: path!) {
//
//                do {
//                    try FileManager.default.removeItem(atPath: path!)
//                } catch {
//
//                }
//            }
//        }
//    }
}

extension ViewController {
    
    fileprivate func creatRoolingViewWith(arr: Array<Any>) {
        let w = UIScreen.main.bounds.size.width
        let h:CGFloat = 30
        let frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - h, width: w, height: h)

        let noticeView = WYRollingNoticeView.init(frame: frame)
        noticeView.dataSource = self
        noticeView.delegate = self
        self.view.addSubview(noticeView)
        
        noticeView0 = noticeView
        noticeView.register(UINib.init(nibName: "WYCell", bundle: nil), forCellReuseIdentifier: "WYCell")
  
        noticeView.reloadDataAndStartRoll()
    }
}

extension ViewController: WYRollingNoticeViewDelegate, WYRollingNoticeViewDataSource {
    func numberOfRowsFor(roolingView: WYRollingNoticeView) -> Int {
        if roolingView == noticeView0 {
            return self.noticeListArrayName.count
        }else{
            return 5
        }
    }
    
    func rollingNoticeView(roolingView: WYRollingNoticeView, cellAtIndex index: Int) -> WYNoticeViewCell {
        
//        if roolingView == noticeView0 {
            let cell = roolingView.dequeueReusableCell(withIdentifier: "WYCell") as! WYCell
            cell.wyLabel.text = (noticeListArrayName[index] as? String) ?? "数据报错"
            return cell
    }
    
    //跳转到提示界面 tag = 2
    func rollingNoticeView(_ roolingView: WYRollingNoticeView, didClickAt index: Int) {
        print("did click index: \(index)")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "second") as! SecondViewController
        vc.viewTag = 2;
        vc.requestUrl = noticeListArrayUrl[index]

    self.navigationController?.present(vc, animated: true)
}

}
