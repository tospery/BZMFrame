//
//  BZMBaseSessionManager.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/24.
//

#import <RESTful/RESTful.h>

@interface BZMBaseSessionManager : RESTHTTPSessionManager

- (RACSignal *)get:(NSString *)URLString parameters:(NSDictionary *)parameters;

@end

