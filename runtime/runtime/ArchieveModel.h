//
//  ArchieveModel.h
//  runtime
//
//  Created by wuyongchao on 2018/6/5.
//  Copyright © 2018年 杭州拼便宜网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchieveModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSNumber *height;

@end
