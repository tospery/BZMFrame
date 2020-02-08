//
//  NSDictionary+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (BZMFrame)

- (NSDictionary *)bzm_dictionaryByUnderlineValuesFromCamel;

- (NSString *)bzm_stringForKey:(id)key;
- (NSString *)bzm_stringForKey:(id)key withDefault:(NSString *)dft;

- (NSNumber *)bzm_numberForKey:(id)key;
- (NSNumber *)bzm_numberForKey:(id)key withDefault:(NSNumber *)dft;

- (NSArray *)bzm_arrayForKey:(id)key;
- (NSArray *)bzm_arrayForKey:(id)key withDefault:(NSArray *)dft;

- (NSDictionary *)bzm_dictionaryForKey:(id)key;
- (NSDictionary *)bzm_dictionaryForKey:(id)key withDefault:(NSDictionary *)dft;

- (id)bzm_objectForKey:(id)key;
- (id)bzm_objectForKey:(id)key withDefault:(id)dft;

+ (NSDictionary *)bzm_dictionaryFromID:(id)data;

@end
