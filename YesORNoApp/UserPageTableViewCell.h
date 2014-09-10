//
//  UserPageTableViewCell.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPageTableViewCell : UITableViewCell
typedef NS_ENUM(NSInteger, SharedItemType)
{
    TextType,
    PictureType,
    AudioType,
    VideoType
};
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellItemType:(SharedItemType)cellItemType;

@property (nonatomic, strong)UIImageView *typeIconView;
@property (nonatomic, strong)UIImageView *avatarImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIImageView *timeIconView;
@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIImageView *photoView;

@end
