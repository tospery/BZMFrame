//
//  BZMFrameManager.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/3.
//

#import "BZMFrameManager.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMFunction.h"

@interface BZMFrameManager ()

@end

@implementation BZMFrameManager
- (instancetype)init {
    if (self = [super init]) {
        self.fontScale = IS_320WIDTH_SCREEN ? -2 : 0;
        //self.primaryColor = UIColorYellow;
    }
    return self;
}

- (BZMPage *)page {
    if (!_page) {
        _page = [[BZMPage alloc] init];
    }
    return _page;
}

- (UIImage *)loadingImage {
    if (!_loadingImage) {
        _loadingImage = BZMImageBundle(@"bzm_loading");
    }
    return _loadingImage;
}

- (UIImage *)waitingImage {
    if (!_waitingImage) {
        _waitingImage = BZMImageBundle(@"bzm_waiting");
    }
    return _waitingImage;
}

+ (instancetype)share {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end
