//
//  MTLModel+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/24.
//

#import <Mantle/Mantle.h>

@interface MTLModel (BZMFrame)
- (void)mergeValuesWithIgnoreKeys:(NSArray *)ignoreKeys fromModel:(id<MTLModel>)model;

@end

