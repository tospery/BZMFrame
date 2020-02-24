//
//  UIDevice+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import <UIKit/UIKit.h>

@interface UIDevice (BZMFrame)
@property (nonatomic, assign, readonly) BOOL bzm_isJailBreaked;
@property (nonatomic, assign, readonly) CGFloat bzm_ppi;
@property (nonatomic, copy, readonly) NSString *bzm_uuid;
@property (nonatomic, copy, readonly) NSString *bzm_idfa;
@property (nonatomic, copy, readonly) NSString *bzm_idfv;
@property (nonatomic, copy, readonly) NSString *bzm_model;

@end

