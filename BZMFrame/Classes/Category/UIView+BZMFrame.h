//
//  UIView+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import <DKNightVersion/DKNightVersion.h>

@interface UIView (BZMFrame)
@property (nonatomic, assign) CGFloat bzm_borderWidth;
@property (nonatomic, assign) CGFloat bzm_cornerRadius;
@property (nonatomic, copy, setter = dk_setBorderColorPicker:) DKColorPicker dk_borderColorPicker;

- (BOOL)bzm_toastWithParameters:(NSDictionary *)parameters completion:(void(^)(BOOL didTap))completion;

@end

