//
//  SinaRetweetView.swift
//  SinaSwiftLearn
//
//  Created by san_xu on 2017/3/15.
//  Copyright © 2017年 huakala. All rights reserved.
//

import UIKit

class SinaRetweetView: UIView {
    
    var bottomContaints : Constraint?
    
    var stateModel : StateModel? {//模型数据
        didSet {
            // 赋值
            contentLabel.text = stateModel?.retweeted_status?.text

            // 配图
            bottomContaints?.deactivate()
            if stateModel?.retweeted_status?.pic_urls?.count == 0 {
                self.snp.makeConstraints { (make) in
                    self.bottomContaints = make.bottom.equalTo(contentLabel.snp.bottom).offset(MARGIN).constraint
                }
                pictureView.isHidden = true
            } else {
                self.snp.makeConstraints { (make) in
                    self.bottomContaints = make.bottom.equalTo(pictureView.snp.bottom).offset(MARGIN).constraint
                }
                pictureView.isHidden = false
                pictureView.pics = stateModel?.retweeted_status?.pic_urls

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

    // 2
    private func setupSubview(){
        
        backgroundColor = BackColor
        //
        addSubview(contentLabel)
        addSubview(pictureView)
        
        // 设置约束
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(MARGIN)
            make.left.equalTo(self.snp.left).offset(MARGIN)
            make.right.equalTo(self.snp.right).offset(-MARGIN)
        }
        
        //pictureView 添加约束
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(MARGIN)
            make.left.equalTo(self.snp.left).offset(MARGIN)
            make.height.width.equalTo(ItemWidth)
        }
        
        // 告诉转发微博的底部到 contentLabel的底部
        self.snp.makeConstraints { (make) in
             self.bottomContaints = make.bottom.equalTo(pictureView.snp.bottom).offset(MARGIN).constraint
        }
    }
    
    //MARK:懒加载
    lazy var contentLabel: UILabel = {
        let  label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: BFONT_SIZE)
        label.numberOfLines = 0
        return label
    }()
    
    //配图
    lazy var pictureView:SinaPictureView = SinaPictureView()
}
