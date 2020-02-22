//
//  BZMType.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#ifndef BZMType_h
#define BZMType_h

#pragma mark - Block类型
typedef void        (^BZMVoidBlock)(void);
typedef BOOL        (^BZMBoolBlock)(void);
typedef NSInteger   (^BZMIntBlock) (void);
typedef id          (^BZMIdBlock)  (void);

typedef void        (^BZMVoidBlock_bool)(BOOL);
typedef BOOL        (^BZMBoolBlock_bool)(BOOL);
typedef NSInteger   (^BZMIntBlock_bool) (BOOL);
typedef id          (^BZMIdBlock_bool)  (BOOL);

typedef void        (^BZMVoidBlock_int)(NSInteger);
typedef BOOL        (^BZMBoolBlock_int)(NSInteger);
typedef NSInteger   (^BZMIntBlock_int) (NSInteger);
typedef id          (^BZMIdBlock_int)  (NSInteger);

typedef void        (^BZMVoidBlock_string)(NSString *);
typedef BOOL        (^BZMBoolBlock_string)(NSString *);
typedef NSInteger   (^BZMIntBlock_string) (NSString *);
typedef id          (^BZMIdBlock_string)  (NSString *);

typedef void        (^BZMVoidBlock_id)(id);
typedef BOOL        (^BZMBoolBlock_id)(id);
typedef NSInteger   (^BZMIntBlock_id) (id);
typedef id          (^BZMIdBlock_id)  (id);

#endif /* BZMType_h */
