//
//  BZMBaseSessionManager.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/24.
//

#import <RESTful/RESTful.h>

@interface BZMBaseSessionManager : RESTHTTPSessionManager

- (RACSignal *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters;

@end

