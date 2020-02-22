//
//  MTLJSONAdapter+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <Mantle/Mantle.h>

@interface MTLJSONAdapter (BZMFrame)
+ (NSValueTransformer *)NSStringJSONTransformer;
+ (NSValueTransformer *)UIColorJSONTransformer;

@end

