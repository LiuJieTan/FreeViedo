//
//  GlobalConst.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/21.
//  Copyright © 2018年 微向暖年未央. All rights reserved.
//

import Foundation
import SwiftyJSON

import UIKit

//var parViewCount = 4
var parseListNameStr:Array<JSON> = []
var parseList1:[String] = []

let imageW:CGFloat = 75
let imageJG = (UIScreen.main.bounds.width - CGFloat(4 * imageW)) / 8

func fileSizeOfCache()-> Int {
    
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    //缓存目录路径
    print(cachePath)
    
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    
    //快速枚举出所有文件名 计算文件大小
    var size = 0
    for file in fileArr! {
        
        // 把文件名拼接到路径中
        let path = cachePath?.appending("/\(file)")
        // 取出文件属性
        let floder = try! FileManager.default.attributesOfItem(atPath: path!)
        // 用元组取出文件大小属性
        for (abc, bcd) in floder {
            // 累加文件大小
            if abc == FileAttributeKey.size {
                size += (bcd as AnyObject).integerValue
            }
        }
    }
    
    let mm = size / 1024 / 1024
    
    return mm
}

func clearCache() {
    
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    
    // 遍历删除
    for file in fileArr! {
        
        let path = cachePath?.appending("/\(file)")
        if FileManager.default.fileExists(atPath: path!) {
            
            do {
                try FileManager.default.removeItem(atPath: path!)
            } catch {
                
            }
        }
    }
}






