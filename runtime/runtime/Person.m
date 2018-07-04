//
//  Person.m
//  runtime
//
//  Created by wuyongchao on 2018/5/28.
//  Copyright © 2018年 杭州拼便宜网络科技有限公司. All rights reserved.
//

#import "Person.h"
#import "ArchieveModel.h"
#import <objc/runtime.h>
@implementation Person
//- (void)eat {
//    NSLog(@"吃鸡腿");
//}
//
//- (void)run:(NSUInteger)metre
//{
//    NSLog(@"跑了 %ld 米", metre);
//}
//当类调用一个没有实现的类方法就会到这里！！
/*这个函数与forwardingTargetForSelector类似，都会在对象不能接受某个selector时触发，执行起来略有差别。前者的目的主要在于给客户一个机会来向该对象添加所需的selector，后者的目的在于允许用户将selector转发给另一个对象。另外触发时机也不完全一样，该函数是个类函数，在程序刚启动，界面尚未显示出时，就会被调用。*/
+(BOOL)resolveClassMethod:(SEL)sel{
    NSLog(@"==%@",NSStringFromSelector(sel));
    return [super resolveClassMethod:sel];
}

//当类调用一个没有实现的对象方法就会到这里！！
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(eat)) {
        // 动态添加eat方法
        /*
         第一个参数：给哪个类添加方法
         第二个参数：添加方法的方法编号
         第三个参数：添加方法的函数实现（函数地址）
         第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
         */
        class_addMethod(self, @selector(eat), eat, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}
//将无法处理的selector转发给其他对象
-(id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector==@selector(eat)) {
        return [ArchieveModel new] ;
    }
    else{
        return [super forwardingTargetForSelector:aSelector];
    }
}
/**
 *  转发方法打包转发出去
 *
 *  @param anInvocation
 */
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    for (id item in self) {
        if ([item respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:item];
        }
    }
}
// 默认方法都有两个隐式参数，
void eat(id self,SEL sel)
{
    NSLog(@"++%@ %@",self,NSStringFromSelector(sel));
}

@end
