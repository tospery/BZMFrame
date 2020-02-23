//
//  NSBundle+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "NSBundle+BZMFrame.h"
#import "NSString+BZMFrame.h"

@implementation NSBundle (BZMFrame)

+ (NSBundle *)bzm_bundleWithModule:(NSString *)module {
//    if (module.length == 0) {
//        return [NSBundle mainBundle];
//    }
//
////    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(module)];
////    if (!bundle) {
////        NSString *identifier = BZMStrWithFmt(@"org.cocoapods.%@", module);
////        bundle = [NSBundle bundleWithIdentifier:identifier];
////    }
//
    NSString *identifier = BZMStrWithFmt(@"org.cocoapods.%@", module);
    NSBundle *bundle = [NSBundle bundleWithIdentifier:identifier];
    return bundle ? bundle : NSBundle.mainBundle;
}

@end
