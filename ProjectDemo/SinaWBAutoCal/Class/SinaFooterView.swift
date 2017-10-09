//
//  SinaFooterView.swift
//  SinaSwiftLearn
//
//  Created by san_xu on 2017/3/14.
//  Copyright © 2017年 huakala. All rights reserved.
//

import UIKit

class SinaFooterView: UIView {
    
    var stateModel : StateModel? {//模型数据
        didSet {
            // 赋值
            leftButton.setTitle(stateModel?.reposts_count == 0 ? "转发": "\(stateModel?.reposts_count ?? 0)", for: .normal)
            centerButton.setTitle(stateModel?.comments_count == 0 ? "评论": "\(stateModel?.comments_count ?? 0)", for: .normal)
            rightButton.setTitle(stateModel?.attitudes_count == 0 ? "赞": "\(stateModel?.attitudes_count ?? 0)", for: .normal)
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
        
        backgroundColor = UIColor.white
        //
        addSubview(leftButton)
        addSubview(centerButton)
        addSubview(rightButton)
        
        //三个按钮添加约束
        rightButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(rightButton.snp.width)
        }
        leftButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(rightButton.snp.width)
        }
        centerButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(rightButton.snp.left)
            make.left.equalTo(leftButton.snp.right)
            make.width.equalTo(rightButton.snp.width)
        }
        
        //添加2条竖线
        let line1 = getLine()
        let line2 = getLine()
        addSubview(line1)
        addSubview(line2)
        
        //设置约束
        line1.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(leftButton.snp.right)
        }
        line2.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(centerButton.snp.right)
        }
        
        //添加分割线
        addSubview(line)
        //设置约束
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(0.5)
        }
        
    }
    
    // 创造一条线
    private func getLine() -> UIImageView {
        return UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    }
    
    //MARK:懒加载
    //rightBtn
    lazy var rightButton : UIButton = {
        let buttton = UIButton(type: UIButtonType.custom)
        buttton.setImage(UIImage(named: "timeline_icon_like"), for: UIControlState.normal)
        buttton.titleLabel?.font = UIFont.systemFont(ofSize: SFONT_SIZE)
        buttton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        return buttton
    }()
    
    //centerBtn
    lazy var centerButton : UIButton = {
        let buttton = UIButton(type: UIButtonType.custom)
        buttton.setImage(UIImage(named: "timeline_icon_comment"), for: UIControlState.normal)
        buttton.titleLabel?.font = UIFont.systemFont(ofSize: SFONT_SIZE)
        buttton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        return buttton
    }()
    
    //LeftBtn
    lazy var leftButton : UIButton = {
        let buttton = UIButton(type: UIButtonType.custom)
        buttton.setImage(UIImage(named: "timeline_icon_retweet"), for: UIControlState.normal)
        buttton.titleLabel?.font = UIFont.systemFont(ofSize: SFONT_SIZE)
        buttton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        return buttton
    }()
    
    //水平分割线
    lazy var line:UIImageView = {
        let line = UIImageView()
        line.backgroundColor = LineColor
        return line
    }()
}
