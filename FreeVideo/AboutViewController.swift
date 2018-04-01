//
//  AboutViewController.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/24.
//  Copyright © 2018年 微向暖年未央. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var cacheSizeLabel: UILabel!
    
    @IBOutlet weak var cleanCache: UIButton!
    var navBar:UINavigationBar!
    var navItem:UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem = UINavigationItem()
        navItem.title = "关于"
        let itemL = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(diss))
        navItem.leftBarButtonItem = itemL
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        navBar.pushItem(navItem, animated: true)

//        navBar.barTintColor = UIColor.blue
        self.view.addSubview(navBar)
        
        
        let cacheSize = fileSizeOfCache()
        cacheSizeLabel.text = String(cacheSize)
        cleanCache.addTarget(self, action: #selector(cleanCacheFun), for: .touchUpInside)
        
    }
    @objc func diss(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func cleanCacheFun(){
        clearCache()
        let ac = UIAlertController(title: "清理缓存", message: "清理成功", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (result) in
            self.cacheSizeLabel.text = "0"
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
