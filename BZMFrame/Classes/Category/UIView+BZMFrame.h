//
//  UIView+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

@interface UIView (BZMFrame)

- (BOOL)bzm_toastWithParameters:(NSDictionary *)parameters completion:(void(^)(BOOL didTap))completion;

@end

