//
//  BZMCollectionCell.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import "BZMReactiveView.h"
#import "BZMCollectionItem.h"

@interface BZMCollectionCell : UICollectionViewCell <BZMReactiveView>
@property (class, assign, readonly) UIEdgeInsets margin;
@property (class, assign, readonly) UIOffset padding;
@property (nonatomic, strong, readonly) BZMCollectionItem *viewModel;

@end

