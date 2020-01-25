//
//  BZMSupplementary.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/26.
//

#import <UIKit/UIKit.h>

@protocol BZMSupplementary <NSObject>
@property (class, strong, readonly) NSString *kind;
@property (class, strong, readonly) NSString *identifier;

//+ (NSString *)kind;
//+ (NSString *)identifier;
//+ (CGSize)sizeForSection:(NSInteger)section;

@end

