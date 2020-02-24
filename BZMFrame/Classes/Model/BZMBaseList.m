//
//  BZMBaseList.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMBaseList.h"

@interface BZMBaseList ()
@property (nonatomic, assign, readwrite) BOOL hasNext;
@property (nonatomic, assign, readwrite) NSInteger count;
@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation BZMBaseList
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *mapping = [NSDictionary mtl_identityPropertyMapWithModel:self];
    mapping = [mapping mtl_dictionaryByRemovingValuesForKeys:@[@"mid"]];
    return mapping;
}

@end
