//
//  NSObject+MTNativeFacebookLogin.m
//  MTNativeFacebookLoginDemo
//
//  Created by Tuan Tran Manh on 11/20/15.
//  Copyright © 2015 Tuan Tran Manh. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+MTNativeFacebookLogin.h"

@implementation NSObject (MTNativeFacebookLogin)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class fbSDKServerConfigurationClass = objc_getClass("FBSDKServerConfiguration");
        SEL originalSelector = @selector(useNativeDialogForDialogName:);
        SEL swizzledSelector = @selector(hvn_useNativeDialogForDialogName:);
        Method originalMethod = class_getInstanceMethod(fbSDKServerConfigurationClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(fbSDKServerConfigurationClass, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(fbSDKServerConfigurationClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(fbSDKServerConfigurationClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)hvn_useNativeDialogForDialogName:(NSString *)dialogName {
    BOOL useNativeDialog = [(NSObject *)self hvn_useNativeDialogForDialogName:dialogName];
    if (![dialogName isEqualToString:@"login"]) {
        return useNativeDialog;
    }
    
    return YES;
}

@end
