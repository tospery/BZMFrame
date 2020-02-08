//
//  BZMBorderLayer.h
//  Kujia
//
//  Created by 杨建祥 on 2020/2/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_OPTIONS(NSUInteger, BZMBorderPosition) {
    BZMBorderPositionNone       = 0,
    BZMBorderPositionTop        = 1 << 0,
    BZMBorderPositionLeft       = 1 << 1,
    BZMBorderPositionBottom     = 1 << 2,
    BZMBorderPositionRight      = 1 << 3,
    BZMBorderPositionShadow     = 1 << 4
};

@interface BZMBorderLayer : CALayer
@property(nonatomic, assign) BZMBorderPosition borderPosition;
@property(nonatomic, strong) NSDictionary *borderColors;
@property(nonatomic, strong) NSDictionary *borderThicks;
@property(nonatomic, strong) NSDictionary *borderInsets;

@end

