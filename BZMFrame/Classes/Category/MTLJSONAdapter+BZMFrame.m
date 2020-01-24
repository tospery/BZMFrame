//
//  MTLJSONAdapter+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/21.
//

#import "MTLJSONAdapter+BZMFrame.h"
#import "NSValueTransformer+BZMFrame.h"

@implementation MTLJSONAdapter (BZMFrame)
+ (NSValueTransformer *)UIColorJSONTransformer {
    return [NSValueTransformer valueTransformerForName:BZMColorValueTransformerName];
}

@end
