//
//  BZMFrameManager.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMFrameManager.h"
#import <QMUIKit/QMUIKit.h>
#import "NSString+BZMFrame.h"
#import "UIApplication+BZMFrame.h"

@interface BZMFrameManager ()

@end

@implementation BZMFrameManager
- (instancetype)init {
    if (self = [super init]) {
        self.autoLogin = YES;
        self.loginPattern = @"login";
        self.appScheme = UIApplication.sharedApplication.bzm_urlScheme;
        self.baseURLString = BZMStrWithFmt(@"https://m.%@.com", self.appScheme);
        self.fontScale = IS_320WIDTH_SCREEN ? -2 : 0;
        self.page = [[BZMPage alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

@end
