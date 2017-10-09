//
//  SinaOriginalView.swift
//  SinaSwiftLearn
//
//  Created by san_xu on 2017/3/14.
//  Copyright © 2017年 huakala. All rights reserved.
//

import UIKit

class SinaOriginalView: UIView {
    
    var bottomContaints : Constraint?
    
    var stateModel : StateModel? {//模型数据
        didSet {
            // 赋值
            // 昵称
            nameLabel.text = stateModel?.user?.screen_name
            // 头像
            iconImage.sd_setImage(with: URL(string: stateModel?.user?.profile_image_url ?? ""))
            // 认证头像 认证类型 -1：没有认证，0:认证用户，2,3,5: 企业认证，220: 达人
            var img : UIImage?
            switch (stateModel?.user?.verified_level ?? -1) {
            case -1:
                img = nil
            case 0:
                img = UIImage(named: "avatar_vip")
            case 2,3,5:
                img = UIImage(named: "avatar_enterprise_vip")
            case 220:
                img = UIImage(named: "avatar_grassroot")
            default:
                img = nil
            }
            verifitiedImageView.image = img
            // 等级
            levelImageView.image = UIImage(named: "common_icon_membership_level" + "\(stateModel?.user?.mbrank ?? 0)")
            //时间
            timeLabel.text = stateModel?.created_at ?? ""
            //来源
            sourceLabel.text = stateModel?.source ?? ""
            // 内容
            contentLabel.text = stateModel?.text
            // 配图
            bottomContaints?.deactivate()
            if stateModel?.pic_urls?.count == 0 {
                self.snp.makeConstraints { (make) in
                    self.bottomContaints = make.bottom.equalTo(contentLabel.snp.bottom).offset(MARGIN).constraint
                }
                pictureView.isHidden = true
            } else {
                self.snp.makeConstraints { (make) in
                    self.bottomContaints = make.bottom.equalTo(pictureView.snp.bottom).offset(MARGIN).constraint
                }
                pictureView.isHidden = false
                pictureView.pics = stateModel?.pic_urls

            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        //
        addSubview(iconImage)
        addSubview(nameLabel)
        addSubview(levelImageView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(verifitiedImageView)
        addSubview(pictureView)
        
        //iconImage 添加约束
        iconImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(MARGIN)
            make.left.equalTo(self.snp.left).offset(MARGIN)
            make.width.height.equalTo(40)
        }
        
        //nameLabel 添加约束
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImage.snp.top)
            make.left.equalTo(iconImage.snp.right).offset(MARGIN)
        }
        
        //levelImageView 添加约束
        levelImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(MARGIN)
        }
        
        //verifitiedImageView 添加约束
        verifitiedImageView.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(iconImage.snp.right)
            make.centerY.equalTo(iconImage.snp.bottom)
        }
        
        //timeLabel 添加约束
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImage.snp.bottom)
            make.left.equalTo(nameLabel.snp.left)
        }
        
        //sourceLabel 添加约束
        sourceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.left.equalTo(timeLabel.snp.right).offset(MARGIN)
        }
        
        //contentLabel 添加约束  高度自动计算得到
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImage.snp.bottom).offset(MARGIN)
            make.right.equalTo(self.snp.right).offset(-MARGIN)
            make.left.equalTo(iconImage.snp.left)
        }
        
        //pictureView 添加约束
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(MARGIN)
            make.left.equalTo(iconImage.snp.left)
            make.height.width.equalTo(ItemWidth)
        }
        
        //告诉self的底部是哪里
        self.snp.makeConstraints { (make) in
            self.bottomContaints = make.bottom.equalTo(pictureView.snp.bottom).offset(MARGIN).constraint
        }
        
    }
    
    //MARK:---懒加载
    //iconImage
    lazy var iconImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "avatar_default_big")
        return img
    }()
    
    //nameLabel
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: BFONT_SIZE)
        return nameLabel
    }()
    
    //levelImageView
    lazy var levelImageView : UIImageView = {
        let levelImageView = UIImageView()
        levelImageView.image = UIImage(named: "common_icon_membership_level1")
        return levelImageView
    }()
    
    ///  认证图片
    lazy var verifitiedImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "avatar_enterprise_vip")
        return img
    }()
    
    ///   时间
    lazy var timeLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: SFONT_SIZE)
        label.textColor = UIColor.orange
        return label
    }()
    
    ///   来源
    lazy var sourceLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: SFONT_SIZE)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    // 内容
    lazy var contentLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: BFONT_SIZE)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //配图
    lazy var pictureView:SinaPictureView = SinaPictureView()
}
