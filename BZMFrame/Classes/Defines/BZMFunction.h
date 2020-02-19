//
//  BZMFunc.h
//  BZMFrame
//
//  Created by 杨建祥 on 2019/12/30.
//

#ifndef BZMFunc_h
#define BZMFunc_h

#import <QMUIKit/QMUIKit.h>
#import <DKNightVersion/DKNightVersion.h>
#import "NSURL+BZMFrame.h"
#import "UIColor+BZMFrame.h"
#import "UIFont+BZMFrame.h"
#import "UIImage+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"

#pragma mark - 标准尺寸
#define BZMScreenWidth                       ScreenBoundsSize.width
#define BZMScreenHeight                      ScreenBoundsSize.height
#define BZMStatusBarHeight                   StatusBarHeight
#define BZMStatusBarHeightConstant           StatusBarHeightConstant
#define BZMNavBarHeight                      NavigationBarHeight
#define BZMNavContentTop                     NavigationContentTop
#define BZMNavContentTopConstant             NavigationContentTopConstant
#define BZMTabBarHeight                      TabBarHeight
#define BZMToolBarHeight                     ToolBarHeight

#pragma mark - 安全区域
#define BZMSafeArea                          SafeAreaInsetsConstantForDeviceWithNotch
#define BZMSafeBottom                        BZMSafeArea.bottom

#pragma mark - 颜色
#pragma mark 函数
#define BZMColorRGB(r, g, b)                 (UIColorMake((r), (g), (b)))
#define BZMColorRGBA(r, g, b, a)             (UIColorMakeWithRGBA((r), (g), (b), (a)))
#define BZMColorVal(hexValue)                ([UIColor bzm_colorWithHex:(hexValue)])
#define BZMColorStr(hexString)               ([UIColor qmui_colorWithHexString:(hexString)])
#define BZMColorKey(t)                       (DKColorPickerWithKey(t)(self.dk_manager.themeVersion))
#pragma mark 黑白
#define BZMColorClear                        (UIColorMakeWithRGBA(255, 255, 255, 0))
#define BZMColorWhite                        (UIColorMake(255, 255, 255))
#define BZMColorBlack                        (UIColorMake(0, 0, 0))

#pragma mark - 字体
#define BZMFont(x)                           ([UIFont bzm_normal:(x)])
#define BZMFontBold(x)                       ([UIFont bzm_bold:(x)])
#define BZMFontLight(x)                      ([UIFont bzm_light:(x)])

//#pragma mark - 字体
//#define BZMImageLoading          (BZMFrameManager.share.loadingImage)
//#define BZMImageWaiting          (BZMFrameManager.share.waitingImage)

#pragma mark - 日志
#ifdef DEBUG
#define BZMLogVerbose(fmt, ...)                                                                 \
NSLog(@"Verbose(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define BZMLogDebug(fmt, ...)                                                                   \
NSLog(@"Debug(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define BZMLogInfo(fmt, ...)                                                                    \
NSLog(@"Info(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define BZMLogWarn(fmt, ...)                                                                    \
NSLog(@"Warn(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define BZMLogError(fmt, ...)                                                                   \
NSLog(@"Error(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define BZMLogVerbose(fmt, ...)
#define BZMLogDebug(fmt, ...)
#define BZMLogInfo(fmt, ...)                                                                    \
NSLog(@"Info(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define BZMLogWarn(fmt, ...)                                                                    \
NSLog(@"Warn(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define BZMLogError(fmt, ...)                                                                   \
NSLog(@"Error(%s, %d): " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

//#define BZMLog(name, fmt, ...)               QMUILog((name), fmt, ##__VA_ARGS__)
//#define BZMLogInfo(name, fmt, ...)           QMUILogInfo((name), fmt, ##__VA_ARGS__)
//#define BZMLogWarn(name, fmt, ...)           QMUILogWarn((name), fmt, ##__VA_ARGS__)

#pragma mark - 便捷方法
#define BZMStrWithBool(x)                    ((x) ? @"YES" : @"NO")
#define BZMStrWithInt(x)                     ([NSString stringWithFormat:@"%llu", ((unsigned long long)x)])
#define BZMStrWithFlt(x)                     ([NSString stringWithFormat:@"%.2f", (x)])
#define BZMStrWithFmt(fmt, ...)              ([NSString stringWithFormat:(fmt), ##__VA_ARGS__])
#define BZMURLWithStr(x)                     ([NSURL bzm_urlWithString:(x)])
#define BZMURLWithPattern(x)                       ([NSURL bzm_urlWithPattern:(x)])
#define BZMImageColor(x)                     ([UIImage qmui_imageWithColor:(x)])
#define BZMImageFrame(x)                    ([UIImage bzm_imageInFrame:BZMStrWithFmt(@"BZMFrame/%@", (x))])
#define BZMRandomNumber(x, y)                ((NSInteger)((x) + (arc4random() % ((y) - (x) + 1))))

#pragma mark - 便捷属性
#define BZMPageAutomaticDimension            (-1)
#define BZMAppWindow                         (UIApplication.sharedApplication.delegate.window)

#pragma mark - 本地化
#ifdef BZMEnableFuncLocalize
#define BZMT(local, display)                 (local)
#else
#define BZMT(local, display)                 (display)
#endif

//// scale - 高宽比
//func metric(scale: CGFloat) -> CGFloat {
//    return flat(UIScreen.main.bounds.size.width * scale)
//}
//
//// value - 375标准
//func metric(_ value: CGFloat) -> CGFloat {
//    return flat(value / 375.f * UIScreen.width)
//}

#pragma mark - 尺寸
CG_INLINE CGFloat
BZMMetric(CGFloat value) {
    return flat(value / 375.f * BZMScreenWidth);
}

CG_INLINE CGFloat
BZMScale(CGFloat value) {
    return flat(value * BZMScreenWidth);
}

#pragma mark - 通知
CG_INLINE void
BZMAddObserver(NSString *name, id observer, SEL selector, id object) {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

CG_INLINE void
BZMNotify(NSString *notificationName, id object, NSDictionary *userInfo) {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object userInfo:userInfo];
}

CG_INLINE void
BZMRemoveObserver(id observer) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark - 默认
CG_INLINE BOOL
BZMBoolWithDft(BOOL value, BOOL dft) {
    if (value == NO) {
        return dft;
    }
    
    return value;
}

CG_INLINE NSInteger
BZMIntWithDft(NSInteger value, NSInteger dft) {
    if (value == 0) {
        return dft;
    }
    
    return value;
}

CG_INLINE id
BZMObjWithDft(id value, id dft) {
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return dft;
    }
    
    return value;
}

CG_INLINE NSString *
BZMStrWithDft(NSString *value, NSString *dft) {
    if (![value isKindOfClass:[NSString class]]) {
        return dft;
    }
    
    if (value.length == 0) {
        return dft;
    }
    
    return value;
}

CG_INLINE NSArray *
BZMArrWithDft(NSArray *value, NSArray *dft) {
    if (![value isKindOfClass:[NSArray class]]) {
        return dft;
    }
    
    if (value.count == 0) {
        return dft;
    }
    
    return value;
}

#pragma mark - 成员
CG_INLINE BOOL
BZMBoolMember(NSDictionary *dict, NSString *key, BOOL dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    return [dict bzm_numberForKey:key withDefault:@(dft)].boolValue;
}

CG_INLINE NSInteger
BZMIntMember(NSDictionary *dict, NSString *key, NSInteger dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    return [dict bzm_numberForKey:key withDefault:@(dft)].integerValue;
}

CG_INLINE NSString *
BZMStrMember(NSDictionary *dict, NSString *key, NSString *dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    return [dict bzm_stringForKey:key withDefault:dft];
}

CG_INLINE NSArray *
BZMArrMember(NSDictionary *dict, NSString *key, NSArray *dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    return [dict bzm_arrayForKey:key withDefault:dft];
}

CG_INLINE NSDictionary *
BZMDictMember(NSDictionary *dict, NSString *key, NSDictionary *dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    return [dict bzm_dictionaryForKey:key withDefault:dft];
}

CG_INLINE id
BZMObjMember(NSDictionary *dict, NSString *key, id dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    return [dict bzm_objectForKey:key withDefault:dft];
}

CG_INLINE UIColor *
BZMColorMember(NSDictionary *dict, NSString *key, UIColor *dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    id value = BZMObjMember(dict, key, dft);
    if ([value isKindOfClass:UIColor.class]) {
        return value;
    }else if ([value isKindOfClass:NSString.class]) {
        return BZMObjWithDft(BZMColorStr(value), dft);
    }
    return dft;
}

CG_INLINE NSURL *
BZMURLMember(NSDictionary *dict, NSString *key, NSURL *dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    id value = BZMObjMember(dict, key, dft);
    if ([value isKindOfClass:NSURL.class]) {
        return value;
    }else if ([value isKindOfClass:NSString.class]) {
        return BZMObjWithDft(BZMURLWithStr(value), dft);
    }
    return dft;
}

#pragma mark - 其他
//CG_INLINE NSArray *
//BZMDataSource(NSArray *arr) {
//    if (!arr ||
//        ![arr isKindOfClass:NSArray.class]) {
//        return nil;
//    }
//    return @[arr];
//}

#endif /* BZMFunc_h */
