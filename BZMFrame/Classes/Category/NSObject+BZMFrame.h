//
//  NSObject+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import <UIKit/UIKit.h>

@interface NSObject (BZMFrame)
@property (nonatomic, copy, readonly) NSString *bzm_className;

@property (class, nonatomic, copy, readonly) NSString *bzm_className;


/**
 *  转换为JSON Data
 */
- (NSData *)bzm_JSONData;
/**
 *  转换为字典或者数组
 */
- (id)bzm_JSONObject;
/**
 *  转换为JSON 字符串
 */
- (NSString *)bzm_JSONString;

/**
 *  转换为JSON 字符串
 */
- (NSString *)bzm_JSONStringPrettyPrinted;

@end

