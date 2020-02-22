//
//  NSObject+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "NSObject+BZMFrame.h"
#import <Mantle/Mantle.h>

@implementation NSObject (BZMFrame)

#pragma mark - Instance
- (NSString *)bzm_className {
    return self.class.bzm_className;
}

- (id)bzm_JSONObject {
    if ([self isKindOfClass:NSString.class]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    
    if ([self isKindOfClass:NSData.class]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    
    if ([self isKindOfClass:NSDictionary.class]) {
        return self;
    }
    
    if ([self conformsToProtocol:@protocol(MTLJSONSerializing)]) {
        id<MTLJSONSerializing> model = (id<MTLJSONSerializing>)self;
        return [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    }
    
    if ([self isKindOfClass:NSArray.class]) {
        id json = [MTLJSONAdapter JSONArrayFromModels:(NSArray *)self error:nil];
        if (!json) {
            json = self;
        }
        return json;
    }
    
    return nil;
}

- (NSData *)bzm_JSONData {
    return [self bzm_JSONData:NO];
}

- (NSData *)bzm_JSONData:(BOOL)prettyPrinted {
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    return [NSJSONSerialization dataWithJSONObject:self.bzm_JSONObject options:(prettyPrinted ? NSJSONWritingPrettyPrinted : kNilOptions) error:nil];
}

- (NSString *)bzm_JSONString {
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    return [[NSString alloc] initWithData:self.bzm_JSONData encoding:NSUTF8StringEncoding];
}

#pragma mark - Class
+ (NSString *)bzm_className {
    return NSStringFromClass(self);
}

@end
