//
//  BZMBaseModel.h
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>
#import "BZMIdentifiable.h"

@interface BZMBaseModel : MTLModel <MTLJSONSerializing, BZMIdentifiable>
@property (nonatomic, copy, readonly) NSString *mid;

- (void)save;
- (void)saveWithKey:(NSString *)key;

+ (void)storeObject:(BZMBaseModel *)object;
+ (void)storeObject:(BZMBaseModel *)object withKey:(NSString *)key;
+ (void)storeArray:(NSArray *)array;

+ (BZMBaseModel *)cachedObject;
+ (BZMBaseModel *)cachedObjectWithKey:(NSString *)key;
+ (NSArray *)cachedArray;

+ (instancetype)current;

@end

