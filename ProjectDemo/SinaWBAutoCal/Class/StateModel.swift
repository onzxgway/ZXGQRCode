//
//  StateModel.swift
//  TableView自动计算高度
//
//  Created by san_xu on 2017/3/19.
//  Copyright © 2017年 朱献国. All rights reserved.
//

import UIKit

class StateModel: NSObject {
    
    ///  微博的id
    var id : CLongLong?
    ///  发布当前微博的人
    var user : UserModel?
    /// 创建时间
    var created_at : String?
    ///  来源
    var source : String?
    ///  当前微博的内容
    var text : String?
    ///  一张缩略图的地址
    var thumbnail_pic : String?
    ///  微博配图的数组
    var pic_urls : [[String:Any]]?
    /// 代表当前微博转发的别人的微博的内容
    var retweeted_status : StateModel?
    
    ///转发数
    var reposts_count : NSInteger = 0
    ///评论数
    var comments_count : NSInteger = 0
    ///表态数
    var attitudes_count : NSInteger = 0
    
    ///初始化方法
    init(dict:[String:Any]) {
        super.init()
        //kvc
        setValuesForKeys(dict)
        //
        if let dict = dict["user"] {
            user = UserModel(dict: dict as! [String : Any])
        }
        // 读取转发微博的信息
        if let retweeted = dict["retweeted_status"] as? [String: Any] {
            retweeted_status = StateModel(dict: retweeted)
        }
    }
    
    //为了避免找不到匹配的key导致崩溃，
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
