//
//  BZMFunction.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#ifndef BZMFunction_h
#define BZMFunction_h

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
