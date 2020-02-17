//
//  Monkey.m
//  _objc_msgForward_demo
//
//  Created by ShanYuQin on 2020/2/13.
//  Copyright © 2020 ShanYuQin. All rights reserved.
//

#import "Monkey.h"
#import "ForwardingTarget.h"
#import <objc/runtime.h>

@interface Monkey()
@property (nonatomic, strong) ForwardingTarget *target;
@end

@implementation Monkey

- (instancetype)init
{
    self = [super init];
    if (self) {
        _target = [ForwardingTarget new];
        //通过performSelector 调用了一个未实现的方法子，编译可以通过，运行的时候会崩溃。
        [self performSelector:@selector(sel) withObject:@"yeyu"];
    }
    
    return self;
}


id dynamicMethodIMP(id self, SEL _cmd, NSString *str)
{
    NSLog(@"%@ 里动态添加的方法:%s",NSStringFromClass([self class]),__FUNCTION__);
    NSLog(@"%@", str);
    return @"1";
}


//+ (BOOL)resolveInstanceMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
//    //通过实现该方法，调用到自己实现的IMPL 可以找到哪里出了问题，也可以保证程序不会崩溃
//    class_addMethod(self.class, sel, (IMP)dynamicMethodIMP, "@@:");
//    BOOL result = [super resolveInstanceMethod:sel];
//    result = YES;
//    return result; // 1
//}

//- (id)forwardingTargetForSelector:(SEL)aSelector __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
//    id result = [super forwardingTargetForSelector:aSelector];
//    result = self.target;
//    NSLog(@"%@ 调用了 %s",NSStringFromClass([self class]),__FUNCTION__);
//    return result; // 2
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
        NSLog(@"%@ 调用了 %s",NSStringFromClass([self class]),__FUNCTION__);
    id result = [super methodSignatureForSelector:aSelector];
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    result = sig;
    return result; // 3
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
        NSLog(@"%@ 调用了 %s",NSStringFromClass([self class]),__FUNCTION__);
    //    [super forwardInvocation:anInvocation];
    anInvocation.selector = @selector(invocationTest);
    [self.target forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

@end
