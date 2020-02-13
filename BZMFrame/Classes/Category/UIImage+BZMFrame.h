//
//  UIImage+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import <UIKit/UIKit.h>

@interface UIImage (BZMFrame)
@property (class, strong, readonly) UIImage *bzm_close;
@property (class, strong, readonly) UIImage *bzm_loading;
@property (class, strong, readonly) UIImage *bzm_waiting;
@property (class, strong, readonly) UIImage *bzm_network;
@property (class, strong, readonly) UIImage *bzm_server;
@property (class, strong, readonly) UIImage *bzm_arrowRight;
@property (class, strong, readonly) UIImage *bzm_arrowLeft;

+ (UIImage *)bzm_imageURLed:(NSString *)urlString;
+ (UIImage *)bzm_imageInAsset:(NSString *)name;
+ (UIImage *)bzm_imageInFrame:(NSString *)name;
+ (UIImage *)bzm_imageInResource:(NSString *)name;
+ (UIImage *)bzm_imageInDocuments:(NSString *)name;

@end

