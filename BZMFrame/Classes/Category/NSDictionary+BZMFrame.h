//
//  NSDictionary+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMFunction.h"
#import "NSURL+BZMFrame.h"
#import "UIColor+BZMFrame.h"

@interface NSDictionary (BZMFrame)

- (NSString *)bzm_stringForKey:(id)key;
- (NSString *)bzm_stringForKey:(id)key withDefault:(NSString *)dft;
- (NSNumber *)bzm_numberForKey:(id)key;
- (NSNumber *)bzm_numberForKey:(id)key withDefault:(NSNumber *)dft;
- (NSArray *)bzm_arrayForKey:(id)key;
- (NSArray *)bzm_arrayForKey:(id)key withDefault:(NSArray *)dft;
- (NSDictionary *)bzm_dictionaryForKey:(id)key;
- (NSDictionary *)bzm_dictionaryForKey:(id)key withDefault:(NSDictionary *)dft;
- (id)bzm_objectForKey:(id)key;
- (id)bzm_objectForKey:(id)key withDefault:(id)dft;

- (NSDictionary *)bzm_dictionaryByUnderlineValuesFromCamel;

+ (NSDictionary *)bzm_dictionaryFromID:(id)data;

@end

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

CG_INLINE CGFloat
BZMFltMember(NSDictionary *dict, NSString *key, CGFloat dft) {
    if (!dict || ![dict isKindOfClass:NSDictionary.class] || !dict.count) {
        return dft;
    }
    return [dict bzm_numberForKey:key withDefault:@(dft)].floatValue;
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
