//
//  UIImage+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import <UIKit/UIKit.h>
#import <DKNightVersion/DKNightVersion.h>

#define BZMImageFrame(x)        ([UIImage bzm_imageInFrame:BZMStrWithFmt(@"BZMFrame/%@", (x))])

@interface UIImage (BZMFrame)
@property (nonatomic, copy, setter = dk_setTintColorPicker:) DKColorPicker dk_tintColorPicker;
@property (class, strong, readonly) UIImage *bzm_back;
@property (class, strong, readonly) UIImage *bzm_close;
@property (class, strong, readonly) UIImage *bzm_indicator;
@property (class, strong, readonly) UIImage *bzm_loading;
@property (class, strong, readonly) UIImage *bzm_waiting;
@property (class, strong, readonly) UIImage *bzm_network;
@property (class, strong, readonly) UIImage *bzm_server;

+ (UIImage *)bzm_imageWithURL:(NSString *)urlString;
+ (UIImage *)bzm_imageInAsset:(NSString *)name;
+ (UIImage *)bzm_imageInFrame:(NSString *)name;
+ (UIImage *)bzm_imageInResource:(NSString *)name;
+ (UIImage *)bzm_imageInDocuments:(NSString *)name;

@end

