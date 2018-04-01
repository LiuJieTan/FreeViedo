//
//  iQiYiAPI.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/19.
//  Copyright © 2018年 微向暖年未央. All rights reserved.
//

import Foundation
import Moya

let parseListProvider = MoyaProvider<parseList>()

public enum parseList{
    case noticeList
    case parseVideo(String,String)
    case parseListName
}

extension parseList: TargetType{
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .noticeList:
            return URL(string: "https://liujietan.github.io/noticeList/")!
        case .parseVideo(let url,_):
            return URL(string: url)!;
        default:
            return URL(string: "https://liujietan.github.io/noticeList/")!
        }
    }
    
    //各个请求的具体路径
    public var path:String{
        switch self {
        case .noticeList:
            return "notice.json"
        case .parseListName:
            return "parseList.json"
        case .parseVideo(_,_):
            return ""
        }
        
    }
        
    public var method: Moya.Method{
        switch self {
        case .noticeList:
            return .get
        case .parseListName:
            return .get
        case .parseVideo(_,_):
            return .post
        }
    }
    
    public var task: Task{
        switch self {
        case .noticeList:
            return .requestPlain
        case .parseListName:
            return .requestPlain
        case .parseVideo(_,let params2):
            var params: [String:Any] = [:]
            params["url"] = params2
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
}
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String: String]? {
        return nil
    }
        
     
 }




