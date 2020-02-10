//
//  UIImage+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import "UIImage+BZMFrame.h"
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

+ (UIImage *)bzm_loading {
    return BZMImageBundle(@"loading");
}

+ (UIImage *)bzm_waiting {
    return BZMImageBundle(@"waiting");
}

+ (UIImage *)bzm_network {
    return BZMImageBundle(@"error_network");
}

+ (UIImage *)bzm_server {
    return BZMImageBundle(@"error_server");
}


+ (UIImage *)bzm_imageURLed:(NSString *)urlString {
    NSString *asset = BZMStrWithFmt(@"%@://", kBZMSchemeAsset);
    if ([urlString hasPrefix:asset]) {
        return [self bzm_imageInAsset:[urlString substringFromIndex:asset.length]];
    }
    
    NSString *bundle = BZMStrWithFmt(@"%@://", kBZMSchemeBundle);
    if ([urlString hasPrefix:bundle]) {
        return [self bzm_imageInBundle:[urlString substringFromIndex:bundle.length]];
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

+ (UIImage *)bzm_imageInBundle:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    NSArray *arr = [name componentsSeparatedByString:@"/"];
    if (arr.count != 2) {
        return nil;
    }
    
    NSString *module = arr[0];
    NSString *file = arr[1];
    
    NSBundle *bundle = [NSBundle bzm_bundleWithModule:module];
    bundle = [NSBundle bundleWithPath:[bundle pathForResource:module ofType:@"bundle"]];
    
    return [UIImage imageNamed:file inBundle:bundle compatibleWithTraitCollection:nil];
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
