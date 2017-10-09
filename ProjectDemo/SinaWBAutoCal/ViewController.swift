//
//  ViewController.swift
//  TableView自动计算高度
//
//  Created by san_xu on 2017/3/19.
//  Copyright © 2017年 朱献国. All rights reserved.
//

import UIKit

let REUSE = "UITableViewCell";

class ViewController: UIViewController,UITableViewDataSource {
    
    override func loadView() {
        super.loadView()
        
        //网络请求数据
        SVProgressHUD.show()
        loadData { (dataArr:[Dictionary<String, Any>]) in
            SVProgressHUD.dismiss()
            //1,字典转模型
            for dic in dataArr{
                let stateModel = StateModel(dict: dic)
                self.dataSource.append(stateModel)
            }
            //2,刷新
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    //MARK:lazy load
    lazy var tableView : UITableView = {
        //tableView
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.dataSource = self
        table.register(SinaCell.self, forCellReuseIdentifier: REUSE)
        
        //分割线到头
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        table.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        //自动计算Cell的高度
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension
        
        return table
    }()
    //数据源
    lazy var dataSource:[StateModel] = [StateModel]()
}

extension ViewController {
    //MARK: -- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE, for: indexPath) as! SinaCell
        cell.stateModel = dataSource[indexPath.row]
        //分割线到头
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        return cell
    }
    
    //MARK: -- 加载网络数据
    func loadData(backData:((_:[Dictionary<String,Any>])->())?){
        //原创微博无图
        let dictOne : [String:Any] = ["created_at":"刚才",
                                      "id":4086305191803438,
                                      "text":"假如生活欺骗了你，\n不要悲伤，不要心急，\n忧郁的日子里需要镇静。",
                                      "source":"来自iPhone 7Plus",
                                      "user":["profile_image_url":"http://tva3.sinaimg.cn/crop.0.73.555.555.50/006aA1sfjw8euibg2y8bpj30i10m8my5.jpg",
                                              "id":2258727990,
                                              "screen_name":"诗圣",
                                              "verified_level":2,
                                              "mbrank":4
                                            ],
                                      "reposts_count":10,
                                      "comments_count":233,
                                      "attitudes_count":0,
                                      "retweeted_status": NSNull(),
                                      "pic_urls": Array<Any>()
        ]
        
        //原创微博有一张图
        let dictTwo : [String:Any] = ["created_at":"2小时前",
                                      "id":4086305191805150,
                                      "text":"【沪指下挫近1%创年内最大跌幅，结束四连阳】17日，沪深两市股指尾盘开始集体剧烈杀跌，今日收放量大阴线，回补昨天的跳空高开缺口。截至发稿，沪指下跌0.97%，报收3237点；深成指下跌1.03%，报收10515点；创业板下跌0.87%，报收1949点。盘面上，次新股、银行、券商和钢铁等板块跌幅居前。",
                                      "source":"来自iPhone 6s",
                                      "user":["profile_image_url":"http://tva4.sinaimg.cn/crop.0.0.1024.1024.50/86a17422jw8f5teqphdovj20sg0sggo0.jpg",
                                              "id":2258727970,
                                              "screen_name":"央视财经",
                                              "verified_level":3,
                                              "mbrank":5
                                            ],
                                      "reposts_count":1,
                                      "comments_count":3,
                                      "attitudes_count":2,
                                      "retweeted_status":NSNull(),
                                      "pic_urls": [["thumbnail_pic": "http://wx3.sinaimg.cn/thumbnail/86a17422ly1fdpus2ledgj20dg0kr7al.jpg"],
                                                   ["thumbnail_pic": "http://wx1.sinaimg.cn/thumbnail/006szvLFgy1fdp07h438tj310y1fcb29.jpg"],
                                                   ["thumbnail_pic": "http://wx3.sinaimg.cn/thumbnail/006szvLFgy1fdp07m0e01j310y1fchdt.jpg"],
                                                   ["thumbnail_pic": "http://wx2.sinaimg.cn/thumbnail/006szvLFgy1fdp07p204ej310y1fc7wh.jpg"]]
        ];
        
        //原创微博九张图片
        let dictThree : [String:Any] = ["created_at":"下午13:08",
                                        "id":4086306373537556,
                                        "text":"【蓝天下的人间仙境】青海省玛多县，海拔4270米，中国海拔最高的县城。立春后的又一场降雪，如同进入童话世界。一起看，这里是中国。",
                                        "source":"来自iPhone 6s",
                                        "user":["profile_image_url":"http://tva2.sinaimg.cn/crop.0.0.512.512.50/9e5389bbjw8eylgqjhrzsj20e80e8jrw.jpg",
                                                "id":2656274875,
                                                "screen_name":"央视新闻",
                                                "verified_level":3,
                                                "mbrank":6
                                            ],
                                        "reposts_count":93,
                                        "comments_count":100,
                                        "attitudes_count":322,
                                        "retweeted_status":NSNull(),
                                        "pic_urls": [["thumbnail_pic": "http://wx1.sinaimg.cn/thumbnail/9e5389bbly1fdpuuitzsnj20p00e9n2m.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx3.sinaimg.cn/thumbnail/9e5389bbly1fdpuujlhlvj20p00drq8s.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx3.sinaimg.cn/thumbnail/9e5389bbly1fdpuukmo5oj20p00dd44w.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx1.sinaimg.cn/thumbnail/9e5389bbly1fdpuulw7xaj20p00eg0y7.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx3.sinaimg.cn/thumbnail/9e5389bbly1fdpuunbwaqj20p00inthq.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx2.sinaimg.cn/thumbnail/9e5389bbly1fdpuuouvn5j20p00fowmo.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx3.sinaimg.cn/thumbnail/9e5389bbly1fdpuupsi0pj20p00djgs1.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx1.sinaimg.cn/thumbnail/9e5389bbly1fdpuuqyzq6j20p00gs7b7.jpg"
                                            ],
                                                     ["thumbnail_pic": "http://wx2.sinaimg.cn/thumbnail/9e5389bbly1fdpuusd3mkj20p00gi468.jpg"
                                            ],
            ]
        ];
        
        
        //转发无图
        let retweetedDict : [String:Any] = ["created_at":"",
                                            "id":000,
                                            "text":"【起司薯球】对起司和马铃薯毫无抵抗力，看着就好吃啊，快收吧[馋嘴]",
                                            "source":" <a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>",
                                            "user":[  "profile_image_url":"http://tva2.sinaimg.cn/crop.0.0.1080.1080.50/96b2dea3jw8ellk70yelij20u00u0dha.jpg",
                                                      "id":2528304803,
                                                      "screen_name":"热手工",
                                                      "verified_level":0,
                                                      "mbrank":0
            ],
                                            "reposts_count":0,
                                            "comments_count":0,
                                            "attitudes_count":0,
                                            "retweeted_status":NSNull(),
                                            "pic_urls": Array<Any>()
        ];
        
        
        
        let dictFour : [String:Any] = ["created_at":"上午10:28",
                                       "id":4086306105963084,
                                       "text":"起司控，看过来~",
                                       "source":"微博 weibo.com",
                                       "user":["profile_image_url":"http://tva2.sinaimg.cn/crop.0.0.1080.1080.50/96b2dea3jw8ellk70yelij20u00u0dha.jpg",
                                               "id":2528304803,
                                               "screen_name":"热手工",
                                               "verified_level":220,
                                               "mbrank":6
                                        ],
                                       "reposts_count":11,
                                       "comments_count":0,
                                       "attitudes_count":1,
                                       "retweeted_status":retweetedDict,
                                       "pic_urls": Array<Any>()
        ];
        
        //转发有图
        let retweetedDict2 : [String:Any] = ["created_at":"",
                                             "id":000,
                                             "text":"生活中的很多问题，并不需要放在心里，人生的很多负担，并不需要挑在肩上。一念放下，才能感受到简单生活的乐趣，才能感受到心灵飞翔的自在。放下烦恼，就得到了快乐；放下贪欲，就得到了平和；放下怨恨，就得到了解脱。放下即是解脱，即是拥有。一念放下，一切自在。",
                                             "source":" <a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>",
                                             "user":[  "profile_image_url":"http://tva2.sinaimg.cn/crop.0.0.1080.1080.50/96b2dea3jw8ellk70yelij20u00u0dha.jpg",
                                                       "id":2528304803,
                                                       "screen_name":"热手工",
                                                       "verified_level":0,
                                                       "mbrank":0
            ],
                                             "reposts_count":0,
                                             "comments_count":0,
                                             "attitudes_count":0,
                                             "retweeted_status":NSNull(),
                                             "pic_urls": [["thumbnail_pic": "http://wx1.sinaimg.cn/thumbnail/5009f331ly1fdpixa6m1mj20zk0nptna.jpg"
                                                ]]
        ];
        
        let dictFive : [String:Any] = ["created_at":"昨天",
                                       "id":4086305195535967,
                                       "text":"转发微博",
                                       "source":"微博 HTML5 版",
                                       "user":[  "profile_image_url":"http://tva2.sinaimg.cn/crop.0.0.640.640.50/5009f331jw8eo6joa8x2hj20hs0hsdh8.jpg",
                                                 "id":1342829361,
                                                 "screen_name":"加措活佛-慈爱基金",
                                                 "verified_level":3,
                                                 "mbrank":5
                                                ],
                                       "reposts_count":0,
                                       "comments_count":22,
                                       "attitudes_count":4,
                                       "retweeted_status":retweetedDict2,
                                       "pic_urls": Array<Any>()
        ];
        
        let backArray = Array(arrayLiteral: dictOne,dictTwo,dictThree,dictFour,dictFive)
        
        //模拟网络延时2秒钟
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            if let backDataArr = backData {
                backDataArr(backArray)
            }
        }
    }
}

