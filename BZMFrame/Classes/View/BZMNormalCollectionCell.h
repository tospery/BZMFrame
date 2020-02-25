//
//  BZMNormalCollectionCell.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/25.
//

#import "BZMCollectionCell.h"

@interface BZMNormalCollectionCell : BZMCollectionCell
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *detailLabel;
@property (nonatomic, strong, readonly) UIImageView *avatarImageView;
@property (nonatomic, strong, readonly) UIImageView *arrowImageView;

@end

