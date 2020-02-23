//
//  BZMLoginViewReactor.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMScrollViewReactor.h"
#import "BZMType.h"

@interface BZMLoginViewReactor : BZMScrollViewReactor
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, copy) BZMVoidBlock didLoginBlock;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong, readonly) RACSignal *validateSignal;

@end

