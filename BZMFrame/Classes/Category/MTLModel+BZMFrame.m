//
//  MTLModel+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/24.
//

#import "MTLModel+BZMFrame.h"

@implementation MTLModel (BZMFrame)

- (void)mergeValuesWithIgnoreKeys:(NSArray *)ignoreKeys fromModel:(id<MTLModel>)model {
    NSSet *propertyKeys = model.class.propertyKeys;

    for (NSString *key in self.class.propertyKeys) {
        if (![propertyKeys containsObject:key]) continue;
        if ([ignoreKeys containsObject:key]) continue;

        [self mergeValueForKey:key fromModel:model];
    }
}

@end
