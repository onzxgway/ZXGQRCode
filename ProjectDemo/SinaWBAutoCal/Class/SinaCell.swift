//
//  SinaCell.swift
//  TableView自动计算高度
//
//  Created by san_xu on 2017/3/19.
//  Copyright © 2017年 朱献国. All rights reserved.
//

import UIKit

class SinaCell: UITableViewCell {

    var bottomContaints : Constraint?
    var stateModel : StateModel? { //模型数据
        didSet {
            //原创
            originalView.stateModel = stateModel
            //toolBar
            footerView.stateModel = stateModel
            //转发
            bottomContaints?.deactivate()
            if stateModel?.retweeted_status == nil {
                footerView.snp.makeConstraints { (make) in
                    bottomContaints = make.top.equalTo(originalView.snp.bottom).constraint
                }
                retweetView.isHidden = true
            } else {
                footerView.snp.makeConstraints { (make) in
                    bottomContaints = make.top.equalTo(retweetView.snp.bottom).constraint
                }
                retweetView.isHidden = false
                retweetView.stateModel = stateModel
            }
            print(stateModel?.retweeted_status)
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //添加子控件
        setupSubview()
        //
        backgroundColor = BackColor
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //添加子控件
    private func setupSubview() {
        //
        contentView.addSubview(originalView)
        contentView.addSubview(retweetView)
        contentView.addSubview(footerView)
        
        //设置约束
        originalView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(MARGIN)
            make.right.left.equalToSuperview()
        }
        retweetView.snp.makeConstraints { (make) in
            make.top.equalTo(originalView.snp.bottom)
            make.right.left.equalToSuperview()
        }
        footerView.snp.makeConstraints { (make) in
            bottomContaints = make.top.equalTo(retweetView.snp.bottom).constraint
            make.right.left.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp.bottom)
        }

    }

    ///MARK: -- 懒加载所有子控件
    //MARK:懒加载
    lazy var originalView : SinaOriginalView = {
        let originalView = SinaOriginalView()
        originalView.backgroundColor = UIColor.white
        return originalView
    }()
    
    lazy var footerView : SinaFooterView = SinaFooterView()
    
    lazy var retweetView : SinaRetweetView = SinaRetweetView()
}
