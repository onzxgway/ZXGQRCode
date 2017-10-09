//
//  SinaPictureView.swift
//  SinaSwiftLearn
//
//  Created by san_xu on 2017/3/15.
//  Copyright © 2017年 huakala. All rights reserved.
//

import UIKit

let SinaPictureViewCell = "SinaPictureViewCell"

class SinaPictureView: UICollectionView,UICollectionViewDataSource {
    
    // 定义一个变量
    var pics: [[String:Any]]? {

        didSet{
            //获取Size
            let size = getSize()
            self.snp.updateConstraints { (make) in
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
            //刷新
            reloadData()
        }
        
    }
    
    let flowLayout = UICollectionViewFlowLayout()//布局对象
    init() {
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0) , collectionViewLayout: flowLayout)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        backgroundColor = UIColor.white
        
        //设置数据源
        dataSource = self
        
        //设置大小
        flowLayout.itemSize = CGSize(width: ItemWidth, height: ItemWidth)
        flowLayout.minimumLineSpacing = ItemMargin
        flowLayout.minimumInteritemSpacing = ItemMargin
        
        //注册cell
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SinaPictureViewCell)
    }
    
    func getSize() -> CGSize {
        
        if pics?.count == 1 {
            return CGSize(width: ItemWidth, height: ItemWidth)
        } else if pics?.count == 4 {
            return CGSize(width: (2 * ItemWidth + ItemMargin), height: (2 * ItemWidth + ItemMargin))
        } else {
            if let imgCount = pics?.count {
                let row = (imgCount - 1 ) / 3 + 1
                let heigth = CGFloat(row) * (ItemWidth) + (CGFloat(row) - 1) * ItemMargin
                return CGSize(width: SCREENW - CGFloat(2 * MARGIN), height: heigth)
            }
        }
        return CGSize()
    }

}

extension SinaPictureView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics?.count ?? 0
    }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SinaPictureViewCell, for: indexPath)
        
        let imgView = UIImageView()
        cell.contentView.addSubview(imgView)
        imgView.frame = cell.bounds
        let dict = pics?[indexPath.item]
        imgView.sd_setImage(with: URL(string: dict?["thumbnail_pic"] as! String))
        
        return cell
        
    }
    
}
