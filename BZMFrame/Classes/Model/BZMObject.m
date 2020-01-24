//
//  BZMObject.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/12.
//

#import "BZMObject.h"

@interface BZMObject ()
@property (nonatomic, copy, readwrite) NSString *mid;

@end

@implementation BZMObject
- (instancetype)initWithMid:(NSString *)mid {
    if (self = [super init]) {
        self.mid = mid;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:BZMObject.class]) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    BZMObject *obj = (BZMObject *)object;
    return [self.mid isEqualToString:obj.mid];
}

- (void)updateMid:(NSString *)mid {
    self.mid = mid;
}

@end
