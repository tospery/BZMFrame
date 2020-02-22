//
//  BZMBaseModel.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>
#import "BZMIdentifiable.h"

@interface BZMBaseModel : MTLModel <MTLJSONSerializing, BZMIdentifiable>

@end

