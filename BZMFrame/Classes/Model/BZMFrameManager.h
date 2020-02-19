//
//  BZMFrameManager.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/3.
//

#import <UIKit/UIKit.h>
#import "BZMPage.h"

@class BZMFrameManager;

@interface BZMFrameManager : NSObject
@property (nonatomic, assign) CGFloat autoLogin;
@property (nonatomic, assign) CGFloat fontScale;
@property (nonatomic, strong) NSString *loginPattern;
@property (nonatomic, strong) NSString *baseURLString;
@property (nonatomic, strong) BZMPage *page;

+ (instancetype)share;

@end

