//
//  BZMBorderLayer.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/25.
//

#import "BZMBorderLayer.h"
#import <QMUIKit/QMUIKit.h>
#import <DKNightVersion/DKNightVersion.h>
#import "BZMFunction.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMBorderLayer ()
@property (nonatomic, strong) CALayer *topBorder;
@property (nonatomic, strong) CALayer *bottomBorder;
@property (nonatomic, strong) CALayer *leftBorder;
@property (nonatomic, strong) CALayer *rightBorder;
@property (nonatomic, strong) NSArray *shadowLayers;

@end

@implementation BZMBorderLayer
#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        self.borderColor = nil;
        self.borderWidth = 0;
        
        [self addSublayer:self.topBorder];
        [self addSublayer:self.bottomBorder];
        [self addSublayer:self.leftBorder];
        [self addSublayer:self.rightBorder];
        
        for (CALayer *layer in self.shadowLayers) {
            [self addSublayer:layer];
        }
        
        [self updateBordersHidden];
        [self updateBordersColor];
    }
    return self;
}

#pragma mark - Property
- (CALayer *)topBorder {
    if (!_topBorder) {
        _topBorder = CALayer.layer;
    }
    return _topBorder;
}

- (CALayer *)bottomBorder {
    if (!_bottomBorder) {
        _bottomBorder = CALayer.layer;
    }
    return _bottomBorder;
}

- (CALayer *)leftBorder {
    if (!_leftBorder) {
        _leftBorder = CALayer.layer;
    }
    return _leftBorder;
}

- (CALayer *)rightBorder {
    if (!_rightBorder) {
        _rightBorder = CALayer.layer;
    }
    return _rightBorder;
}

- (NSArray *)shadowLayers {
    if (!_shadowLayers) {
        _shadowLayers = @[CALayer.layer, CALayer.layer, CALayer.layer];
    }
    return _shadowLayers;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateBordersFrame];
}

- (void)setBorderPosition:(BZMBorderPosition)borderPosition {
    _borderPosition = borderPosition;
    [self updateBordersHidden];
}

- (void)setBorderColors:(NSDictionary *)borderColors {
    _borderColors = borderColors;
    [self updateBordersColor];
}

- (void)setBorderThicks:(NSDictionary *)borderThicks {
    _borderThicks = borderThicks;
    [self updateBordersFrame];
}

- (void)setBorderInsets:(NSDictionary *)borderInsets {
    _borderInsets = borderInsets;
    [self updateBordersFrame];
}

#pragma mark - Method
- (void)layoutSublayers {
    [super layoutSublayers];
    self.topBorder.zPosition = self.sublayers.count;
    self.leftBorder.zPosition = self.topBorder.zPosition;
    self.bottomBorder.zPosition = self.topBorder.zPosition;
    self.rightBorder.zPosition = self.topBorder.zPosition;
    
    if ((self.borderPosition & BZMBorderPositionShadow) == BZMBorderPositionShadow) {
        [CATransaction begin];
        [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
        for (NSInteger i = 0; i < self.shadowLayers.count; ++i) {
            CALayer *layer = self.shadowLayers[i];
            layer.frame = CGRectMake(0, self.bounds.size.height + ((CGFloat)i / UIScreen.mainScreen.scale), self.bottomBorder.bounds.size.width, PixelOne);
        }
        [CATransaction commit];
    }
}

- (void)updateBordersHidden {
    self.topBorder.hidden = ((self.borderPosition & BZMBorderPositionTop) != BZMBorderPositionTop);
    self.bottomBorder.hidden = ((self.borderPosition & BZMBorderPositionBottom) != BZMBorderPositionBottom);
    self.leftBorder.hidden = ((self.borderPosition & BZMBorderPositionLeft) != BZMBorderPositionLeft);
    self.rightBorder.hidden = ((self.borderPosition & BZMBorderPositionRight) != BZMBorderPositionRight);
    
    BOOL shadowHidden = ((self.borderPosition & BZMBorderPositionShadow) != BZMBorderPositionShadow);
    for (CALayer *layer in self.shadowLayers) {
        layer.hidden = shadowHidden;
    }
}

- (void)updateBordersColor {
    self.topBorder.backgroundColor = [self colorForBorder:BZMBorderPositionTop].CGColor;
    self.bottomBorder.backgroundColor = [self colorForBorder:BZMBorderPositionBottom].CGColor;
    self.leftBorder.backgroundColor = [self colorForBorder:BZMBorderPositionLeft].CGColor;
    self.rightBorder.backgroundColor = [self colorForBorder:BZMBorderPositionRight].CGColor;
    
    if ((self.borderPosition & BZMBorderPositionShadow) == BZMBorderPositionShadow) {
        UIColor *color = [self colorForBorder:BZMBorderPositionShadow];
        for (NSInteger i = 0; i < self.shadowLayers.count; ++i) {
            CGFloat alpha = ((CGFloat)(self.shadowLayers.count - i - 0.6) / (CGFloat)self.shadowLayers.count);
            CALayer *layer = self.shadowLayers[i];
            layer.backgroundColor = [color colorWithAlphaComponent:alpha].CGColor;
        }
    }
}

- (void)updateBordersFrame {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGFloat thick = [self thickForBorder:BZMBorderPositionTop];
    UIEdgeInsets insets = [self insetsForBorder:BZMBorderPositionTop];
    self.topBorder.frame = CGRectMake(insets.left, 0, self.bounds.size.width - insets.left - insets.right, thick);
    
    thick = [self thickForBorder:BZMBorderPositionBottom];
    insets = [self insetsForBorder:BZMBorderPositionBottom];
    self.bottomBorder.frame = CGRectMake(insets.left, self.bounds.size.height - thick, self.bounds.size.width - insets.left - insets.right, thick);
    
    thick = [self thickForBorder:BZMBorderPositionLeft];
    insets = [self insetsForBorder:BZMBorderPositionLeft];
    self.leftBorder.frame = CGRectMake(0, insets.top, thick, self.bounds.size.height - insets.top - insets.bottom);
    
    thick = [self thickForBorder:BZMBorderPositionRight];
    insets = [self insetsForBorder:BZMBorderPositionRight];
    self.rightBorder.frame = CGRectMake(self.bounds.size.width - thick, insets.top, thick, self.bounds.size.height - insets.top - insets.bottom);
    
    [CATransaction commit];
}

- (UIColor *)colorForBorder:(BZMBorderPosition)position {
    UIColor *color = [self.borderColors bzm_objectForKey:@(position)];
    if (!color || ![color isKindOfClass:UIColor.class]) {
        return DKColorPickerWithKey(SEP)(self.dk_manager.themeVersion);
    }
    return color;
}

- (CGFloat)thickForBorder:(BZMBorderPosition)position {
    NSNumber *thick = [self.borderThicks bzm_numberForKey:@(position)];
    if (!thick || ![thick isKindOfClass:NSNumber.class]) {
        return PixelOne;
    }
    return thick.floatValue;
}

- (UIEdgeInsets)insetsForBorder:(BZMBorderPosition)position {
    NSString *str = [self.borderInsets bzm_stringForKey:@(position)];
    if (!str || ![str isKindOfClass:NSString.class]) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsFromString(str);
}

@end

