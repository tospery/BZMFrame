//
//  BZMIdentifiable.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/12.
//

#import <Foundation/Foundation.h>

@protocol BZMIdentifiable <NSObject>
@property (nonatomic, copy, readonly) NSString *mid;

- (instancetype)initWithMid:(NSString *)mid;

- (void)updateMid:(NSString *)mid;

@end

