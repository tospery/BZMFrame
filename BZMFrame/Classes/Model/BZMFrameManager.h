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
@property (nonatomic, assign) CGFloat fontScale;
@property (nonatomic, strong) BZMPage *page;
//@property (nonatomic, strong) UIColor *primaryColor;
@property (nonatomic, strong) UIImage *loadingImage; // YBZM_TODO 换到UIImage分类中，通过运行时修改
@property (nonatomic, strong) UIImage *waitingImage;
//@property (nonatomic, strong) UIImage *emptyImage;
//@property (nonatomic, strong) UIImage *networkImage;
//@property (nonatomic, strong) UIImage *serverImage;
//@property (nonatomic, strong) UIImage *expireImage;

+ (instancetype)share;

@end

