//
//  BZMPageFactory.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import <UIKit/UIKit.h>

@interface BZMPageFactory : NSObject
+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;
+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent;

@end

