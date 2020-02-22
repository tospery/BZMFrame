//
//  NSObject+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

@interface NSObject (BZMFrame)
@property (nonatomic, strong, readonly) NSString *bzm_className;
@property (nonatomic, strong, readonly) id bzm_JSONObject;
@property (nonatomic, strong, readonly) NSData *bzm_JSONData;
@property (nonatomic, strong, readonly) NSString *bzm_JSONString;
@property (class, strong, readonly) NSString *bzm_className;

- (NSData *)bzm_JSONData:(BOOL)prettyPrinted;

@end

