//
//  BZMIdentifiable.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

@protocol BZMIdentifiable <NSObject>
@property (nonatomic, strong, readonly) NSString *mid;

- (instancetype)initWithMid:(NSString *)mid;

@end

