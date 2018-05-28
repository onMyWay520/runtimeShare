//
//  ViewController.m
//  runtime
//
//  Created by wuyongchao on 2018/5/28.
//  Copyright © 2018年 杭州拼便宜网络科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>
#import "UIImage+Swizzling.h"
#import "NSObject+hook.h"
#define SCREENT_HEIGHT      [[UIScreen mainScreen] bounds].size.height
#define SCREENT_WIDTH       [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self messageLearn];
    [self swizzleImage];
    [self modelWithDict];
}
#pragma mark - 字典转模型
-(void)modelWithDict{
    NSDictionary *dic = @{@"name":@"我",
                          @"sex":@"男",
                          @"age":@25
                          };
    Person *model = [Person modelWithDict:dic];
    NSLog(@"name:%@  sex:%@  age:%@",model.name,model.sex,model.age);
}
#pragma mark - 交换方法
-(void)swizzleImage{
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, SCREENT_HEIGHT)];
    imgView.image=[UIImage yc_imageNamed:@"guide"];
    [self.view addSubview:imgView];
}
#pragma mark - 消息转发机制
-(void)messageLearn{
    // 使用 Runtime 创建一个对象
    // 根据类名获取到类
    Class personClass=objc_getClass("Person");
    // 同过类创建实例对象
    // 如果这里报错，请将 Build Setting -> Enable Strict Checking of objc_msgSend Calls 改为 NO
    Person *person=objc_msgSend(personClass, @selector(alloc));
    // 通过 Runtime 初始化对象
    person=objc_msgSend(person, @selector(init));
    // 通过 Runtime 调用对象方法
    // 调用的这个方法没有声明只有实现所以这里会有警告
    // 但是发送消息的时候会从方法列表里寻找方法
    // 所以这个能够成功执行
    objc_msgSend(person, @selector(eat));
    // 当然，objc_msgSend 可以传递参数
    Person *per=objc_msgSend(objc_msgSend(objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
    objc_msgSend(per, @selector(run:), 100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
