//
//  BZMFunction.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#ifndef BZMFunction_h
#define BZMFunction_h

#import <QMUIKit/QMUIKit.h>

#pragma mark - 本地化
#ifdef BZMEnableFuncLocalize
#define BZMT(local, display)                 (local)
#else
#define BZMT(local, display)                 (display)
#endif

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

#pragma mark - 便捷方法
#define BZMRandomNumber(x, y)                ((NSInteger)((x) + (arc4random() % ((y) - (x) + 1))))

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
    [NSNotificationCenter.defaultCenter addObserver:observer selector:selector name:name object:object];
}

CG_INLINE void
BZMNotify(NSString *notificationName, id object, NSDictionary *userInfo) {
    [NSNotificationCenter.defaultCenter postNotificationName:notificationName object:object userInfo:userInfo];
}

CG_INLINE void
BZMRemoveObserver(id observer) {
    [NSNotificationCenter.defaultCenter removeObserver:observer];
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


#endif /* BZMFunction_h */
