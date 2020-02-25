//
//  BZMPage.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/25.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BZMPageStyle){
    BZMPageStyleGroup,
    BZMPageStyleOffset
};

@interface BZMPage : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) BZMPageStyle style;

@end

