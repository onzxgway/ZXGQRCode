//
//  UserModel.swift
//  TableView自动计算高度
//
//  Created by san_xu on 2017/3/19.
//  Copyright © 2017年 朱献国. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    ///  头像地址
    var profile_image_url : String?
    
    ///  昵称
    var screen_name : String?
    
    /// 用户认证图像
    /// 认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_level: Int = 0
    
    /// 会员等级 1-6
    var mbrank: Int = 0
    
    ///初始化方法
    init(dict:[String:Any]) {
        super.init()
        //kvc
        setValuesForKeys(dict)
    }
    
    //为了避免找不到匹配的key导致崩溃，
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
