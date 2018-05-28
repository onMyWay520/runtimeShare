//
//  Person.m
//  runtime
//
//  Created by wuyongchao on 2018/5/28.
//  Copyright © 2018年 杭州拼便宜网络科技有限公司. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)eat {
    NSLog(@"吃鸡腿");
}

- (void)run:(NSUInteger)metre
{
    NSLog(@"跑了 %ld 米", metre);
}
@end
