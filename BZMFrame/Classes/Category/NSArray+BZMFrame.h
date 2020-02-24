//
//  NSArray+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/24.
//

#import <UIKit/UIKit.h>

@interface NSArray (BZMFrame)

- (id)bzm_objectAtIndex:(NSInteger)index;
- (BOOL)bzm_containsObject:(id)object;
- (NSArray *)bzm_removeEquals;
- (NSArray *)bzm_addObjects:(NSArray *)objects;

@end
