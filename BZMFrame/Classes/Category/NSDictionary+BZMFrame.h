//
//  NSDictionary+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (BZMFrame)

- (NSDictionary *)bzm_dictionaryByUnderlineValuesFromCamel;

- (NSString *)bzm_stringForKey:(NSString *)key;
- (NSString *)bzm_stringForKey:(NSString *)key withDefault:(NSString *)dft;

- (NSNumber *)bzm_numberForKey:(NSString *)key;
- (NSNumber *)bzm_numberForKey:(NSString *)key withDefault:(NSNumber *)dft;

- (NSArray *)bzm_arrayForKey:(NSString *)key;
- (NSArray *)bzm_arrayForKey:(NSString *)key withDefault:(NSArray *)dft;

- (NSDictionary *)bzm_dictionaryForKey:(NSString *)key;
- (NSDictionary *)bzm_dictionaryForKey:(NSString *)key withDefault:(NSDictionary *)dft;

- (id)bzm_objectForKey:(NSString *)key;
- (id)bzm_objectForKey:(NSString *)key withDefault:(id)dft;
- (id)bzm_objectForKey:(NSString *)key withDefault:(id)dft baseClass:(Class)cls;

+ (NSDictionary *)bzm_dictionaryFromID:(id)data;

@end
