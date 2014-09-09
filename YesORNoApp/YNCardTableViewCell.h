//
//  YNCardTableViewCell.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-4.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCardTableViewCell : UITableViewCell

typedef NS_ENUM(NSInteger, SharedItemType)
{
    TextType,
    PictureType,
    AudioType,
    VideoType
};

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellItemType:(SharedItemType)cellItemType;
@property (nonatomic, strong) UIView *cardContainerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *itemTypeIconView;
@property (nonatomic, strong) UILabel *itemContentLabel;

@property (nonatomic, strong) UIImageView *attachPhotoContainerView;
@property (nonatomic, strong) UIView *attachAudioContainerView;
@property (nonatomic, strong) UIView *attachVideoContainerView;

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UILabel *commentCountLabel;


@end
