//
//  ViewController.m
//  ZXGConfuse
//
//  Created by san_xu on 2017/10/9.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSString *_name;
}
@end

@implementation ViewController

/**
 代码混淆主要步骤：
 1.创建一个sh后缀的脚本文件，再创建一个func.list文件，导入工程目录下。
 2.配置Build Phase,添加要执行的脚本的路径。（Build Phase -> + -> New Run Script Phase -> Run Script）
     路径添加成功之后，command + B ，发现运行报错（Permission denied）。
     解决方案：终端进入项目路径，输入 chmod 755 confuse.sh 回车，然后再编译一下即可。打开项目目录，会发现多了两个文件 symbols 和 codeObfuscation.h。
 3.在pch文件中包含codeObfuscation.h,重新 build 。
 4.接下来就可以在func.list 文件中 添加你所需要混淆的代码，写入要混淆的方法名或变量名。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
}

//***************************
- (void)modifyName {
    NSLog(@"hello world!");
}

/**
 注意事项：该方法在func.list文件中，写法如下
     modifyAge
     address
 */
- (void)modifyAge:(NSInteger)age andAddress:(NSString *)add {
    NSLog(@"hello world!");
}
/**
modifyName
modifyAge
andAddress
_name
*/
//***************************

/**
 上述方法的缺陷：
 1.要混淆的方法名称，需要手动一个一个添加到func.list中，很麻烦，如果自动添加？
 2.代码混淆比较耗时。
 解决方案：将需要屏蔽的方法名添加一个前缀，然后再sh文件中配置
 */

- (void)XXX_testA {}
- (void)XXX_testB {}
- (void)XXX_testC {}

/**
 class-dump的安装和使用:
 安装：1.到http://stevenygard.com/projects/class-dump/下载class-dump-3.5.dmg。
      2.把class-dump拷贝到/usr/local/bin目录下，在终端输入sudo chmod 777 /usr/local/bin/class-dump更改权限，安装完成。
      3.在终端输入class-dump，显示class-dump信息，表示安装成功，就可以正常使用了。
 使用：1.项目打包一个ipa文件，更改文件名称为zip格式，然后解压之后得到.app的目标文件。
      2.用终端输入命令class-dump -H [.app文件的路径] -o [输出文件夹路径]
         在[输出文件夹路径]就可以得到所有的.h文件了
 */


@end
