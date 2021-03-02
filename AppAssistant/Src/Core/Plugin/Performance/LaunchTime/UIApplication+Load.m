//
//  UIApplication+Load.m
//  AppAssistant
//
//  Created by wangbao on 2020/11/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIApplication (Load)

+ (void)load
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    Class app = NSClassFromString(@"UIApplication");
    [app performSelector:@selector(applicationLoadHandle)];
    #pragma clang diagnostic pop
}

@end
