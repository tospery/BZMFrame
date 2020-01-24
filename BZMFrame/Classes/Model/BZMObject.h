//
//  BZMObject.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/12.
//

#import <UIKit/UIKit.h>
#import "BZMIdentifiable.h"

@interface BZMObject : NSObject <BZMIdentifiable>
@property (nonatomic, copy, readonly) NSString *mid;

@end

