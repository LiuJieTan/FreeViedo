//
//  SecondViewController.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/10.
//  Copyright © 2018年 微向暖年未央. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    
    var psView: ParseView!
//    var requestUrlString:String?
    
    
    var backBtn: UIButton!
    var dissBtn: UIButton!
    var requestUrl:String = ""
    var viewTag: Int?
    
    var results:[NSTextCheckingResult]!
    var str = ""

    let progressH:CGFloat = 18;
    var statusH:CGFloat = 0;
    var navigationH:CGFloat = 0;
    let ParseViewH:CGFloat = 100;
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusH = UIApplication.shared.statusBarFrame.height;
        navigationH = (self.navigationController?.navigationBar.frame.height) ?? 0 ;
        
        let config = WKWebViewConfiguration()
        //设置播放 不会全屏
        config.allowsInlineMediaPlayback = true
        
        /**
         增加的属性：
         1.webView.estimatedProgress加载进度
         2.backForwardList 表示historyList
         3.WKWebViewConfiguration *configuration; 初始化webview的配置
         */
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: progressH))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor.orange
//                self.navigationController?.navigationBar.addSubview(progressView)
        
        backBtn = UIButton(type: .system)
        backBtn.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 200, width: 80, height: 50)
        backBtn.backgroundColor = UIColor.lightGray
        backBtn.alpha = 1.0
        backBtn.layer.cornerRadius = 8;
        backBtn.setTitle("返回上一级", for: .normal)
        backBtn.addTarget(self, action: #selector(backItemPressed), for: .touchUpInside)
        
        dissBtn = UIButton(frame: CGRect(x: 0, y: statusH, width: 40, height: 40))
        dissBtn.setBackgroundImage(UIImage(named:"dissImg"), for: .normal)
        dissBtn.alpha = 0.6
        dissBtn.addTarget(self, action: #selector(dissSegue), for: .touchUpInside)
        
        psView = Bundle.main.loadNibNamed("ParseView", owner: nil, options: nil)?[0] as? ParseView
//        ParseView = Bundle.main.loadNibNamed("ParseView", owner: nil, options: nil).first as? ParseView
        psView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - statusH - navigationH , width: UIScreen.main.bounds.width, height: ParseViewH)
    
        if viewTag == 1{
//            print("//////////////////////////////\(String(describing: viewTag))")
            /**
             * 设置下面两种方法均可取消webview的与导航栏空白的错误
             */
            //      self.automaticallyAdjustsScrollViewInsets = false;
            self.edgesForExtendedLayout = []    //设置该方法后不需要再重新设置index为0的控件的位置以及scrollview的位置，
            //（0，0）默认的依然是从导航栏下面开始算起
                webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: UIScreen.main.bounds.height - (statusH+navigationH)),configuration:config)
            webView.allowsBackForwardNavigationGestures = true      //允许侧滑返回到上一个界面(注意书写位置)
            
            webView.navigationDelegate = self
            webView.uiDelegate = self;
            
            self.view.addSubview(webView)
            self.view.addSubview(progressView)
            self.view.addSubview(backBtn)

            if psView != nil{
                self.view.addSubview(psView!)
            }
          
        }else{
            webView = WKWebView(frame: CGRect(x: 0, y: statusH, width: self.view.frame.size.width, height: UIScreen.main.bounds.height - (statusH+navigationH)), configuration:config)
//            webView.allowsBackForwardNavigationGestures = true
           
            
            webView.navigationDelegate = self
            webView.uiDelegate = self;
            self.view.addSubview(webView)
            self.view.addSubview(progressView)
            self.view.addSubview(dissBtn)
            progressView.frame = CGRect(x: 0, y: statusH, width: UIScreen.main.bounds.width, height: progressH)
            
        }
        
        if let url = URL(string: requestUrl){
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.psView.cancelParse.addTarget(self, action: #selector(psViewcancel), for: .touchUpInside)
        self.psView.confirmParse.addTarget(self, action: #selector(psViewconfirm), for: .touchUpInside)
    }
    
    
    @objc func myUrlfilter(){
        //定义正则
        // 1. 创建正则表达式规则
        let pattern = "(https://m.v.qq.com/x/cover)|(https://m.v.qq.com/cover/)|(http://m.iqiyi.com/v_)|(http://m.youku.com/video/id_XM)|(https://m.youku.com/video/id_XM)|(https://m.mgtv.com/b/)|(https://m.mgtv.com/l/)"
        
        // 2. 创建正则表达式对象
        guard let regex = try?NSRegularExpression(pattern: pattern, options: []) else { return }
        // 3. 匹配字符串中内容
        results =  regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
    }
    
    //实现psview的显示动画
    @objc func psViewshow() -> Void {
        UIView.animate(withDuration: 0.8, animations: {
            self.psView.frame.origin.y = UIScreen.main.bounds.height - self.statusH - self.navigationH - self.ParseViewH
        })
    }
    //psView取消按钮点击逻辑实现
    @objc func psViewcancel() -> Void {
        UIView.animate(withDuration: 0.6) {
            self.psView.frame.origin.y = UIScreen.main.bounds.height - self.statusH - self.navigationH
        }
    }
    
    //psView免VIP看按钮点击逻辑实现
    @objc func psViewconfirm() -> Void {
        self.psView.videoTitle.text = webView.title
        self.title = webView.title
        requestUrl = String(describing: webView.url)
        if let url = webView.url{
            requestUrl = url.absoluteString
        }
        print("\(requestUrl)>>>>>>>>>>>>>>>>>>>>>>>>")
        let vc = AlertController();
        vc.videoUrlString = requestUrl
            vc.videoTitleString = self.psView.videoTitle.text
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.present(vc, animated: true, completion: nil)
    }
    
    //退回上个界面
    @objc func dissSegue(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //判断是否可以返回
    @objc func backItemPressed() {
        if webView.canGoBack {
            webView.goBack()
        }else{
         print("返回失败,该页面是首页...")
        }
    }
    //加载本地html文件
    @objc func LoadHtml()  {
        webView.loadHTMLString("<html><body><h1>I'm Jack</h1></body></html>", baseURL: nil)
    }
    
//@WKUIDelegate
// WKWebView创建初始化加载的一些配置
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil;
    }
    
   
    //@WKNavigationDelegate
   //提供了可用来追踪加载过程的代理方法
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("decidePolicyFor")
        if let url = webView.url{
            print("url is \(url) decidePolicyFor")
            str = url.absoluteString
//            str = String(describing: url)
            requestUrl = str
        }
        self.title = webView.title
        self.psView.videoTitle.text = webView.title

        myUrlfilter()
        if results != []{
            psViewshow()
        }else{
            psViewcancel()
        }
        decisionHandler(.allow)  //使用该方法必须设置设置该方法是否允许跳转，否则报错  no called
    }

   //页面开始加载时调用1
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    
    
   // 接收到服务器跳转请求之后调用2
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation\n")
    }
    
   //3
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        self.psView.videoTitle.text = webView.title // 防止返回时title还是下个界面返回的title

    }
    
    //当内容开始返回时调用4
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit\n")
    }
    
    // 页面加载完成之后调用5
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        self.navigationItem.title = webView.title
        self.title = webView.title
        
        //防止部分界面在decide时返回的的类似于https://m.mgtv.com/channel/home/#/channel/home?ref=
        if let url = webView.url{
            print("url is \(url) decidePolicyFor")
            str = url.absoluteString
//            str = String(describing: url)
            requestUrl = str
        }
        myUrlfilter()
        if results != []{
            psViewshow()
        }else{
            psViewcancel()
        }
        
        print("\(String(describing: webView.url))didFinish\n")
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
    
    override func viewWillDisappear(_ animated: Bool) {
    }
}
