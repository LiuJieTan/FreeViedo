//
//  SecondViewController.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/10.
//  Copyright © 2018年 微向暖年未央. All rights reserved.
//

import UIKit
import WebKit

class ThirdViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    
    let loading = UIView()
    let center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    var progress:UIActivityIndicatorView!
    var progressTitleLabel:UILabel!

    var dissBtn: UIButton!
    var requestUrl:String = ""
    var parseName = ""
    
    var str1 = ""
    var str2 = ""
    
    let progressH:CGFloat = 20;
    var statusH:CGFloat = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        statusH = UIApplication.shared.statusBarFrame.height;
        
        let config = WKWebViewConfiguration()
        config.requiresUserActionForMediaPlayback = false
        print("\(requestUrl)")

        /**
         增加的属性：
         1.webView.estimatedProgress加载进度
         2.backForwardList 表示historyList
         3.WKWebViewConfiguration *configuration; 初始化webview的配置
         */
        progressView = UIProgressView(frame: CGRect(x: 0, y: statusH, width: UIScreen.main.bounds.size.width, height: progressH))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor.orange
        
        dissBtn = UIButton(frame: CGRect(x: 0, y: statusH, width: 40, height: 40))
        dissBtn.setBackgroundImage(UIImage(named:"dissImg2"), for: .normal)
        dissBtn.alpha = 0.6
        dissBtn.addTarget(self, action: #selector(dissSegue), for: .touchUpInside)
        
            /**
             * 设置下面两种方法均可取消webview的与导航栏空白的错误
             */
            //      self.automaticallyAdjustsScrollViewInsets = false;
//            self.edgesForExtendedLayout = []    //设置该方法后不需要再重新设置index为0的控件的位置以及scrollview的位置，
            //（0，0）默认的依然是从导航栏下面开始算起
            webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: UIScreen.main.bounds.height),configuration:config)
            webView.isHidden = true

            webView.scrollView.bounces = false //禁止wkwebview控件上下滑动
            webView.navigationDelegate = self
            webView.uiDelegate = self;
            
            self.view.addSubview(webView)
            self.view.addSubview(dissBtn)
            self.view.addSubview(progressView)

        if let url = URL(string: requestUrl){
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        //添加个菊花加载动画
        addLoadingView()

    }
    
    //添加个菊花加载动画
    func addLoadingView(){
        
        loading.frame.size.width = 110
        loading.frame.size.height = 110
        loading.center = center
        loading.backgroundColor = UIColor.black
        loading.layer.cornerRadius = 10
        loading.layer.masksToBounds = true

        progress = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        progress.frame.size.width = 110
        progress.frame.size.height = 80
        progress.startAnimating()
        
        progressTitleLabel = UILabel(frame: CGRect(x: 0, y: 80, width: 110, height: 30))
        progressTitleLabel.text = "拼命加载中..."
        progressTitleLabel.textColor = UIColor.white
        progressTitleLabel.textAlignment = .center
        progressTitleLabel.font = UIFont(name: "Zapfino", size: 13)
        
        loading.addSubview(progress)
        loading.addSubview(progressTitleLabel)
        self.view.addSubview(loading)
    }
    
    //退回上个界面
    @objc func dissSegue(){
        self.dismiss(animated: true, completion: nil)
    }
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
  
    // 页面加载完成之后调用5
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        
        switch self.parseName {
        case "baiyug":
            print("baiyug")
//            webView.evaluateJavaScript("document.getElementsByTagName('style')[0].innerHTML;") { (any, error) in
//                self.str1 = self.getID(str: any as! String)
//                print("baiyug\(String(describing: self.str1))???didFinish\n")
//                webView.evaluateJavaScript("document.getElementsByTagName('style')[1].innerHTML;") { (any, error) in
//                    self.str2 = self.getID(str: any as! String)
//                    print("\(String(describing: self.str2))???didFinish\n")
//                    webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML;") { (any, error) in
//                        //删除广告
//                        webView.evaluateJavaScript("document.getElementById('\(self.str1)').parentNode.removeChild(document.getElementById('\(self.str1)'))") { (any, error) in
//
//                            webView.evaluateJavaScript("document.getElementById('\(self.str2)').parentNode.removeChild(document.getElementById('\(self.str2)'))") { (any, error) in
//                                self.timeInterval()
//                            }
//
//
//                            webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML;", completionHandler: { (any, error) in
//                                if let aaa = any{
//                                    print("\(aaa)")
//                                }
//                            })
//                        }
//                    }
//                }
//            }
            
        case "1717yun":
            webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: {(any, error) in
                if let aaa = any{
                    print("1717yun\(aaa)")
                }
            })
            
            webView.evaluateJavaScript("document.getElementsByTagName('div')[3].parentNode.removeChild(document.getElementsByTagName('div')[3])", completionHandler: {(any, error) in
                self.timeInterval()
            })
            
        case "qiangqiang":
            webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: {(any, error) in
                if let aaa = any{
                    print("qiangqiang\(aaa)")
                }
            })
            
            webView.evaluateJavaScript("document.getElementsByTagName('div')[3].parentNode.removeChild(document.getElementsByTagName('div')[3])", completionHandler: {(any, error) in
                webView.evaluateJavaScript("document.getElementsByTagName('div')[4].parentNode.removeChild(document.getElementsByTagName('div')[4])", completionHandler: {(any, error) in
                    self.timeInterval()
                })
            })
            
        case "napian":
            webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: {(any, error) in
                if let aaa = any{
                    print("napian\(aaa)")
                }
            })
        webView.evaluateJavaScript("document.getElementById('xnjKT431212_3985').parentNode.removeChild(document.getElementById('xnjKT431212_3985'))", completionHandler: {(any, error) in
                self.timeInterval()
            })
            
        case "shitouyun":
            webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: {(any, error) in
                if let aaa = any{
                    print("shitouyun\(aaa)")
                }
            })
            
            webView.evaluateJavaScript("document.getElementsByTagName('div')[3].parentNode.removeChild(document.getElementsByTagName('div')[3])", completionHandler: {(any, error) in
                self.timeInterval()
            })
            
        default:
            progress.stopAnimating()
            loading.removeFromSuperview()
            webView.isHidden = false
        }
    }
    //延时显示webview，防止广告一闪而过
    @objc func timeInterval(){
        progressTitleLabel.text = "获取数据中..."
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(displayWebView), userInfo: nil, repeats: false)
    }
    
    //显示webview
    @objc func displayWebView(){
        progress.stopAnimating()
        loading.removeFromSuperview()
        webView.isHidden = false
    }
    
    func getID(str:String) -> String{
        let endIndex:String.Index?
        var name:String.SubSequence
        var rangeStr:String = ""
        
        if str.hasPrefix("div.a"){
            print("1")
            //    let startIndex = str1.index(of: "a")
            endIndex = str.index(of: "{")
            name = str[..<endIndex!]
            rangeStr = (name as NSString).substring(from: 5)
        }else if str.hasPrefix("div."){
            print("0")
            endIndex = str.index(of: "{")
            name = str[..<endIndex!]
            rangeStr = (name as NSString).substring(from: 4)
        }
        return rangeStr
    }
    
    //页面加载失败时调用6
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //        self.psView.videoTitle.text = "Sorry, the connection is fail"
        print("8???didFail\n")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("我退出le")
    }
    
    deinit {
        print("con is deinit")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
    }
}



