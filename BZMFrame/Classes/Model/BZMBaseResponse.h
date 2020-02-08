//
//  BZMBaseResponse.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/24.
//

#import <RESTful/RESTful.h>

@interface BZMBaseResponse : RESTResponse
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign) NSInteger code;

@end

