//
//  ViewController.m
//  多线程
//
//  Created by san_xu on 2017/9/19.
//  Copyright © 2017年 onzxgway. All rights reserved.
//

#import "ViewController.h"
#import <pthread/pthread.h>

@interface ViewController ()

@end

@implementation ViewController {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
}

- (void)loadView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    self.view = _scrollView;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    _imageView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demo5];
    
}

//队列组
- (void)demo5 {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:arc4random_uniform(4)];
        NSLog(@"ABC1.zip");
    });
    
    dispatch_queue_t queue = dispatch_queue_create("zxg", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:arc4random_uniform(4)];
        NSLog(@"ABC2.zip");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"下载完成");
    });
}

/**
 需求：任务1，2在子线程顺序执行，->异步 串行
      完成之后通知主线程顺序执行任务3，4，->主队列 添加任务3、4
      完成之后并发执行任务5，6，7 ->异步 并发
 分析：
 */
- (void)demo4 {
    dispatch_queue_t queue = dispatch_queue_create("zxg", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"3");
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"4");
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"5");
            });
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"6");
            });
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"7");
            });
            
        });
        
    });
    
//    CFRelease(queue);
}

/**
 需求：1，登录 2，扣费 3，下载 4，完成提示  有序并发执行，
 分析：串行队列 异步可以实现   并发队列 异步也可以实现
 */
- (void)demo3 {
    //并发队列 异步也可以实现
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("abc", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(conCurrentQueue, ^{
        
        dispatch_sync(conCurrentQueue, ^{
            NSLog(@"1，登录");
        });
        dispatch_sync(conCurrentQueue, ^{
            NSLog(@"2，扣费");
        });
        dispatch_sync(conCurrentQueue, ^{
            NSLog(@"3，下载");
        });
        dispatch_sync(conCurrentQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"4，完成提示");
            });
        });
    });
    
//    //串行队列 异步可以实现
//    dispatch_queue_t serialQueue = dispatch_queue_create("abc", DISPATCH_QUEUE_SERIAL);
//    
//    dispatch_async(serialQueue, ^{
//        NSLog(@"1，登录");
//    });
//    
//    dispatch_async(serialQueue, ^{
//        NSLog(@"2，扣费");
//    });
//    
//    dispatch_async(serialQueue, ^{
//        NSLog(@"3，下载");
//    });
//    
//    dispatch_async(serialQueue, ^{
    //        dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"4，完成提示");
    //        });
//    });
}

- (void)demo2 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *url = @"http://img.ivsky.com/img/tupian/pre/201708/14/bailu.jpg";
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *img = [UIImage imageWithData:imgData];
        //更新图片
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = img;
            [_imageView sizeToFit];
            _scrollView.contentSize = _imageView.image.size;
        });
    });
}

//多线程技术一，GCD
- (void)demo1 {
    
    //队列:存放任务的容器。FIFO
//    串行队列:一次执行一个，等待上一个执行结束之后，才可以执行下一个。
    dispatch_queue_t serialQueue = dispatch_queue_create("SERIAL", DISPATCH_QUEUE_SERIAL);
//    并发队列:内部多个任务可以同时执行。
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    
    //任务:线程要执行的代码块
    dispatch_block_t block = dispatch_block_create("", ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    //串行队列 同步
    dispatch_sync(serialQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    //串行队列 异步
    dispatch_async(serialQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    //并发队列 同步
    dispatch_sync(conCurrentQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    //并发队列 异步
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    //实际项目中，不需要手动创建队列，因为系统提供了现成的队列。
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    //主队列 同步 死锁
    dispatch_sync(mainQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    //主队列 异步
    dispatch_async(mainQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    //全局并发队列 同步
    dispatch_sync(globalQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    //全局并发队列 异步
    dispatch_async(globalQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//多线程技术一，NSThread
- (void)demo {
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"**%@",[NSThread currentThread]);
    }];//
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"****%@",[NSThread currentThread]);
    }];
    thread.name = @"zxg";
    [thread start];
    
    [self performSelectorInBackground:@selector(test:) withObject:@"heihei"];
    
    NSThread *t = [[NSThread alloc] init];
    t.name = @"__Main";
    NSLog(@"*%@",[NSThread currentThread]);
}

- (void)test:(NSString *)str {
     NSLog(@"*****%@***%@******",[NSThread currentThread],str);
}




@end
