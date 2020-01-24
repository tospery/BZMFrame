//
//  UIImage+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import <UIKit/UIKit.h>

@interface UIImage (BZMFrame)

+ (UIImage *)bzm_imageURLed:(NSString *)urlString;
+ (UIImage *)bzm_imageInAsset:(NSString *)name;
+ (UIImage *)bzm_imageInBundle:(NSString *)name;
+ (UIImage *)bzm_imageInResource:(NSString *)name;
+ (UIImage *)bzm_imageInDocuments:(NSString *)name;

@end

