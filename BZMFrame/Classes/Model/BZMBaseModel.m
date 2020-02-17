//
//  BZMBaseModel.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMBaseModel.h"
#import <PINCache/PINCache.h>
#import "BZMFunction.h"
#import "NSString+BZMFrame.h"
#import "NSNumber+BZMFrame.h"
#import "MTLJSONAdapter+BZMFrame.h"

NSMutableDictionary *currents = nil;

@interface BZMBaseModel ()
@property (nonatomic, copy, readwrite) NSString *mid;

@end

@implementation BZMBaseModel
#pragma mark - Init
- (instancetype)initWithMid:(NSString *)mid {
    if (self = [super init]) {
        self.mid = mid;
    }
    return self;
}

#pragma mark - View
#pragma mark - Property
#pragma mark - Method
#pragma mark super

#pragma mark public
- (void)save {
    [self saveWithKey:self.mid];
}

- (void)saveWithKey:(NSString *)key {
    [PINCache.sharedCache setObject:self forKey:[self.class objectArchiverKey:key]];
}

#pragma mark private
#pragma mark - Delegate
#pragma mark BZMIdentifiable
- (void)updateMid:(NSString *)mid {
    self.mid = mid;
}

#pragma mark - Class
#pragma mark super
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *mapping = [NSDictionary mtl_identityPropertyMapWithModel:self];
    mapping = [mapping mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"mid": @"id"
    }];
    return mapping;
}

//+ (NSValueTransformer *)midJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        return [NSString bzm_stringWithObject:value];
//    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        return [NSString bzm_stringWithObject:value];
//    }];
//}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    return @{
        @"mid": [MTLJSONAdapter NSStringJSONTransformer]
    }[key];
}

#pragma mark public
+ (void)storeObject:(BZMBaseModel *)object {
    [object saveWithKey:object.mid];
}

+ (void)storeObject:(BZMBaseModel *)object withKey:(NSString *)key {
    [object saveWithKey:key];
}

+ (void)storeArray:(NSArray *)array {
    [PINCache.sharedCache setObject:array forKey:[self arrayArchiverKey]];
}

+ (void)eraseObject:(BZMBaseModel *)object {
    [self eraseObjectForKey:object.mid];
}

+ (void)eraseObjectForKey:(NSString *)key {
    NSString *archiverKey = [self objectArchiverKey:key];
    [PINCache.sharedCache removeObjectForKey:archiverKey];
}

+ (void)eraseArray {
    NSString *archiverKey = [self arrayArchiverKey];
    [PINCache.sharedCache removeObjectForKey:archiverKey];
}

+ (instancetype)cachedObject {
    return [self cachedObjectWithKey:nil];
}

+ (instancetype)cachedObjectWithKey:(NSString *)key {
    NSString *archiverKey = [self objectArchiverKey:key];
    BZMBaseModel *object = [PINCache.sharedCache objectForKey:archiverKey];
    if (!object) {
        NSString *path = [NSBundle.mainBundle pathForResource:archiverKey ofType:@"json"];
        if (path.length != 0) {
            NSData *data = [NSData dataWithContentsOfFile:path options:0 error:nil];
            if (data) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (json && [json isKindOfClass:NSDictionary.class]) {
                    object = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:json error:nil];
                }
            }
        }
    }
    return object;
}

+ (NSArray *)cachedArray {
    NSString *archiverKey = [self arrayArchiverKey];
    NSArray *array = [PINCache.sharedCache objectForKey:archiverKey];
    if (!array) {
        NSString *path = [NSBundle.mainBundle pathForResource:archiverKey ofType:@"json"];
        if (path.length != 0) {
            NSData *data = [NSData dataWithContentsOfFile:path options:0 error:nil];
            if (data) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (json && [json isKindOfClass:NSArray.class]) {
                    array = [MTLJSONAdapter modelsOfClass:self fromJSONArray:json error:nil];
                }
            }
        }
    }
    return array;
}

+ (instancetype)current {
    if (!currents) {
        currents = [NSMutableDictionary dictionary];
    }
    NSString *key = [self objectArchiverKey:nil];
    BZMBaseModel *obj = [currents bzm_objectForKey:key];
    if (!obj) {
        obj = [self cachedObject];
        if (!obj) {
            obj = [[self alloc] init];
        }
        [currents setObject:obj forKey:key];
    }
    return obj;
}

#pragma mark private
+ (NSString *)objectArchiverKey:(NSString *)key {
    NSString *name = NSStringFromClass(self.class);
    if (key.length == 0) {
        return BZMStrWithFmt(@"%@#object", name);
    }
    
    return BZMStrWithFmt(@"%@#object#%@", name, key);
}

+ (NSString *)arrayArchiverKey {
    return BZMStrWithFmt(@"%@#array", NSStringFromClass(self.class));
}


@end
