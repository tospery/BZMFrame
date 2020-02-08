//
//  MTLJSONAdapter+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/21.
//

#import <Mantle/Mantle.h>

@interface MTLJSONAdapter (BZMFrame)
+ (NSValueTransformer *)NSStringJSONTransformer;
+ (NSValueTransformer *)UIColorJSONTransformer;

@end

