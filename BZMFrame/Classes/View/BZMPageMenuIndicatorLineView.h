//
//  BZMPageMenuIndicatorLineView.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuIndicatorComponentView.h"

typedef NS_ENUM(NSUInteger, BZMPageMenuIndicatorLineStyle) {
    BZMPageMenuIndicatorLineStyleNormal             = 0,
    BZMPageMenuIndicatorLineStyleLengthen           = 1,
    BZMPageMenuIndicatorLineStyleLengthenOffset     = 2,
};

@interface BZMPageMenuIndicatorLineView : BZMPageMenuIndicatorComponentView
@property (nonatomic, assign) BZMPageMenuIndicatorLineStyle lineStyle;

/**
 line滚动时x的偏移量，默认为10；
 lineStyle为BZMPageMenuIndicatorLineStyleLengthenOffset有用；
 */
@property (nonatomic, assign) CGFloat lineScrollOffsetX;

@end
