//
//  UIApplication+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import <UIKit/UIKit.h>

@interface UIApplication (BZMFrame)
@property (nonatomic, strong, readonly) NSString *bzm_version;
@property (nonatomic, strong, readonly) NSString *bzm_urlScheme;
@property (nonatomic, strong, readonly) NSString *bzm_displayName;
@property (nonatomic, strong, readonly) NSString *bzm_teamID;
@property (nonatomic, strong, readonly) NSString *bzm_bundleID;

@end

