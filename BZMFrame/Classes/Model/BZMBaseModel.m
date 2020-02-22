//
//  BZMBaseModel.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMBaseModel.h"
#import "MTLJSONAdapter+BZMFrame.h"

@interface BZMBaseModel ()
@property (nonatomic, strong, readwrite) NSString *mid;

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
#pragma mark private
#pragma mark - Delegate
#pragma mark - Class
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *mapping = [NSDictionary mtl_identityPropertyMapWithModel:self];
    mapping = [mapping mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"mid": @"id"
    }];
    return mapping;
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    return @{
        @"mid": [MTLJSONAdapter NSStringJSONTransformer]
    }[key];
}

@end
