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
#import "ArchieveModel.h"
#define SCREENT_HEIGHT      [[UIScreen mainScreen] bounds].size.height
#define SCREENT_WIDTH       [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self messageLearn];
//    [self swizzleImage];
//    [self modelWithDict];
//    [self encodeAndDecode];
    //在debug模式下回崩溃，在release模式下正常，切换模式即可，可以减少线上闪退
    NSArray * a = [[NSArray alloc] init];
    [self ArrayAbnormal:a];
}
-(void)ArrayAbnormal:(NSArray *)array{
    [array objectAtIndex:22];
    
}
//归档和解档
-(void)encodeAndDecode{
    ArchieveModel *model=[[ArchieveModel alloc]init];
    model.name=@"张三";
    model.age=@25;
    model.height=@168;
    //  归档文件的路径
    NSString *filePath = [NSHomeDirectory()stringByAppendingPathComponent:@"person.archiver"];
    //  判断该文件是否存在
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        //  不存在的时候，归档存储一个Student的对象
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:model forKey:@"student"];
        [archiver finishEncoding];
        BOOL success = [data writeToFile:filePath atomically:YES];
        if (success) {
         NSLog(@"归档成功！");
        }
    }
    else{
        //  存在的时候，不再进行归档，而是解挡！
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        ArchieveModel *studentFromSaving = [unArchiver decodeObjectForKey:@"student"];
       NSLog(@"%@",studentFromSaving.name);
    }

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
//    objc_msgSend(per, @selector(run:), 100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
