//
//  UIView+BZMFrame.h
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/30.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZMBorderLayer.h"

@interface UIView (BZMFrame)
@property (nonatomic, assign) CGFloat bzm_borderWidth;
@property (nonatomic, assign) CGFloat bzm_cornerRadius;
@property (nonatomic, strong) UIColor *bzm_borderColor;
@property (nonatomic, strong, readonly) BZMBorderLayer *bzm_borderLayer;

@end

