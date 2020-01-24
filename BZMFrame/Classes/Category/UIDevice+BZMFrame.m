//
//  UIDevice+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/6.
//

#import "UIDevice+BZMFrame.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>
#include <sys/stat.h>
#include <objc/objc.h>
#include <objc/runtime.h>
#include <dlfcn.h>
#import <AdSupport/ASIdentifierManager.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <FCUUID/FCUUID.h>
#import "BZMFunction.h"
#import "UIApplication+BZMFrame.h"

@implementation UIDevice (BZMFrame)
- (BOOL)bzm_isJailBreaked {
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                       @"/bin/bash",
                       @"/usr/sbin/sshd",
                       @"/etc/apt"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        return YES;
    }
    
    int ret;
    Dl_info dylib_info;
    struct stat stat_info;
    int (*func_stat)(const char*, struct stat*) = stat;
    char *dylib_name = "/usr/lib/system/libsystem_kernel.dylib";
    if ((ret = dladdr(func_stat, &dylib_info)) &&
        strncmp(dylib_info.dli_fname, dylib_name, strlen(dylib_name))) {
        if (0 == stat("/Applications/Cydia.app", &stat_info)) {
            return YES;
        }
    }
    
    if (getenv("DYLD_INSERT_LIBRARIES")) {
        return YES;
    }
    
    return NO;
}

static NSString *sUuid = nil;
- (NSString *)bzm_uuid {
    if (sUuid.length == 0) {
        NSString *key = @"uuid";
        NSString *service = @"device.info";
        NSString *accessGroup = BZMStrWithFmt(@"%@.shared", [UIApplication sharedApplication].bzm_teamID);
        
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:service accessGroup:accessGroup];
        keychain.synchronizable = YES;
        
        NSString *result = keychain[key];
        if (result.length == 0) {
            result = [FCUUID uuidForDevice];
            keychain[key] = result;
        }
        sUuid = result;
    }
    return sUuid;
}

- (NSString *)bzm_idfa {
    return [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
}

- (NSString *)bzm_idfv {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

- (NSString *)bzm_model {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *identifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *model = @"iPhone 8";
    if ([identifier isEqualToString:@"i386"] ||
        [identifier isEqualToString:@"x86_64"]) {
        model = @"Simulator";
    }else if ([identifier isEqualToString:@"iPhone1,1"]) {
        model = @"iPhone 1G";
    }else if ([identifier isEqualToString:@"iPhone1,2"]) {
        model = @"iPhone 3G";
    }else if ([identifier isEqualToString:@"iPhone2,1"]) {
        model = @"iPhone 3GS";
    }else if ([identifier isEqualToString:@"iPhone3,1"] ||
              [identifier isEqualToString:@"iPhone3,2"]) {
        model = @"iPhone 4";
    }else if ([identifier isEqualToString:@"iPhone4,1"]) {
        model = @"iPhone 4S";
    }else if ([identifier isEqualToString:@"iPhone5,1"] ||
              [identifier isEqualToString:@"iPhone5,2"]) {
        model = @"iPhone 5";
    }else if ([identifier isEqualToString:@"iPhone5,3"] ||
              [identifier isEqualToString:@"iPhone5,4"]) {
        model = @"iPhone 5C";
    }else if ([identifier isEqualToString:@"iPhone6,1"] ||
              [identifier isEqualToString:@"iPhone6,2"]) {
        model = @"iPhone 5S";
    }else if ([identifier isEqualToString:@"iPhone7,2"]) {
        model = @"iPhone 6";
    }else if ([identifier isEqualToString:@"iPhone7,1"]) {
        model = @"iPhone 6 Plus";
    }else if ([identifier isEqualToString:@"iPhone8,1"]) {
        model = @"iPhone 6s";
    }else if ([identifier isEqualToString:@"iPhone8,2"]) {
        model = @"iPhone 6s Plus";
    }else if ([identifier isEqualToString:@"iPhone8,4"]) {
        model = @"iPhone SE";
    }else if ([identifier isEqualToString:@"iPhone9,1"] ||
              [identifier isEqualToString:@"iPhone9,3"]) {
        model = @"iPhone 7";
    }else if ([identifier isEqualToString:@"iPhone9,2"] ||
              [identifier isEqualToString:@"iPhone9,4"]) {
        model = @"iPhone 7 Plus";
    }else if ([identifier isEqualToString:@"iPhone10,1"] ||
              [identifier isEqualToString:@"iPhone10,4"]) {
        model = @"iPhone 8";
    }else if ([identifier isEqualToString:@"iPhone10,2"] ||
              [identifier isEqualToString:@"iPhone10,5"]) {
        model = @"iPhone 8 Plus";
    }else if ([identifier isEqualToString:@"iPhone10,3"] ||
              [identifier isEqualToString:@"iPhone10,6"]) {
        model = @"iPhone X";
    }else if ([identifier isEqualToString:@"iPhone11,8"]) {
        model = @"iPhone XR";
    }else if ([identifier isEqualToString:@"iPhone11,2"]) {
        model = @"iPhone XS";
    }else if ([identifier isEqualToString:@"iPhone11,4"] ||
              [identifier isEqualToString:@"iPhone11,6"]) {
        model = @"iPhone XS Max";
    }
    
    return model;
}

- (CGFloat)bzm_ppi {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *identifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    CGFloat ppi = 326;
    if ([identifier isEqualToString:@"i386"] ||
        [identifier isEqualToString:@"x86_64"]) {
        ppi = 132;
    }else if ([identifier isEqualToString:@"iPhone1,1"]) {
        ppi = 163;
    }else if ([identifier isEqualToString:@"iPhone1,2"]) {
        ppi = 163;
    }else if ([identifier isEqualToString:@"iPhone2,1"]) {
        ppi = 163;
    }else if ([identifier isEqualToString:@"iPhone3,1"] ||
              [identifier isEqualToString:@"iPhone3,2"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone4,1"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone5,1"] ||
              [identifier isEqualToString:@"iPhone5,2"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone5,3"] ||
              [identifier isEqualToString:@"iPhone5,4"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone6,1"] ||
              [identifier isEqualToString:@"iPhone6,2"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone7,2"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone7,1"]) {
        ppi = 401;
    }else if ([identifier isEqualToString:@"iPhone8,1"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone8,2"]) {
        ppi = 401;
    }else if ([identifier isEqualToString:@"iPhone8,4"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone9,1"] ||
              [identifier isEqualToString:@"iPhone9,3"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone9,2"] ||
              [identifier isEqualToString:@"iPhone9,4"]) {
        ppi = 401;
    }else if ([identifier isEqualToString:@"iPhone10,1"] ||
              [identifier isEqualToString:@"iPhone10,4"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone10,2"] ||
              [identifier isEqualToString:@"iPhone10,5"]) {
        ppi = 401;
    }else if ([identifier isEqualToString:@"iPhone10,3"] ||
              [identifier isEqualToString:@"iPhone10,6"]) {
        ppi = 458;
    }else if ([identifier isEqualToString:@"iPhone11,8"]) {
        ppi = 326;
    }else if ([identifier isEqualToString:@"iPhone11,2"]) {
        ppi = 458;
    }else if ([identifier isEqualToString:@"iPhone11,4"] ||
              [identifier isEqualToString:@"iPhone11,6"]) {
        ppi = 458;
    }
    
    return ppi;
}

@end
