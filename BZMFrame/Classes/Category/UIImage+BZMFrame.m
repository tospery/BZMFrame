//
//  UIImage+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import "UIImage+BZMFrame.h"
#import <QMUIKit/QMUIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "NSString+BZMFrame.h"
#import "NSBundle+BZMFrame.h"

@implementation UIImage (BZMFrame)

+ (UIImage *)bzm_back {
    return [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(10, 18) lineWidth:1.5 tintColor:BZMColorKey(TEXT)];
}

+ (UIImage *)bzm_close {
    return [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) lineWidth:1.5 tintColor:BZMColorKey(TEXT)];
}

+ (UIImage *)bzm_indicator {
    return [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 11) lineWidth:1 tintColor:BZMColorKey(IND)];
}

+ (UIImage *)bzm_loading {
    return BZMImageFrame(@"loading");
}

+ (UIImage *)bzm_waiting {
    return BZMImageFrame(@"waiting");
}

+ (UIImage *)bzm_network {
    return BZMImageFrame(@"errorNetwork");
}

+ (UIImage *)bzm_server {
    return BZMImageFrame(@"errorServer");
}

+ (UIImage *)bzm_imageURLed:(NSString *)urlString {
    NSString *asset = BZMStrWithFmt(@"%@://", kBZMSchemeAsset);
    if ([urlString hasPrefix:asset]) {
        return [self bzm_imageInAsset:[urlString substringFromIndex:asset.length]];
    }
    
    NSString *bundle = BZMStrWithFmt(@"%@://", kBZMSchemeFrame);
    if ([urlString hasPrefix:bundle]) {
        return [self bzm_imageInFrame:[urlString substringFromIndex:bundle.length]];
    }
    
    NSString *resource = BZMStrWithFmt(@"%@://", kBZMSchemeResource);
    if ([urlString hasPrefix:resource]) {
        return [self bzm_imageInResource:[urlString substringFromIndex:resource.length]];
    }
    
    NSString *documents = BZMStrWithFmt(@"%@://", kBZMSchemeDocuments);
    if ([urlString hasPrefix:documents]) {
        return [self bzm_imageInDocuments:[urlString substringFromIndex:documents.length]];
    }
    
    return nil;
}

+ (UIImage *)bzm_imageInAsset:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    return [UIImage imageNamed:name];
}

+ (UIImage *)bzm_imageInFrame:(NSString *)path {
    if (path.length == 0) {
        return nil;
    }
    
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    if (arr.count != 2) {
        return nil;
    }
    
    NSString *module = arr[0];
    NSString *name = arr[1];
    
    NSBundle *bundle = [NSBundle bzm_bundleWithModule:module];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    if (image) {
        return image;
    }
    
    bundle = [NSBundle bundleWithPath:[bundle pathForResource:module ofType:@"bundle"]];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)bzm_imageInResource:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    NSArray *arr = [name componentsSeparatedByString:@"."];
    if (arr.count != 2) {
        return nil;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:arr[0] ofType:arr[1]];
    if (filePath.length == 0) {
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)bzm_imageInDocuments:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    NSString *filePath = [NSString bzm_filePathInDocuments:name];
    if (filePath.length == 0) {
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
