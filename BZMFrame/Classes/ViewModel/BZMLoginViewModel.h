//
//  BZMLoginViewModel.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/3.
//

#import "BZMScrollViewModel.h"
#import "BZMType.h"

@protocol BZMLoginViewModelDelegate <BZMScrollViewModelDelegate>

@end

@interface BZMLoginViewModel : BZMScrollViewModel
@property (nonatomic, strong, readonly) RACSignal *validLoginSignal;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, copy) BZMVoidBlock didLoginBlock;

@end

