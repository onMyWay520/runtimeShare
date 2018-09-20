//
//  NSObject+hook.h
//  runtime
//
//  Created by wuyongchao on 2018/5/28.
//  Copyright © 2018年 杭州拼便宜网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (hook)
+ (NSArray *)yc_objcProperties;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
