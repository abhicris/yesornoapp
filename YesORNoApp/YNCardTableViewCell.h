//
//  YNCardTableViewCell.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-4.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIChameleonView/KIChameleonView.h>
#import <AVOSCloud/AVOSCloud.h>

@interface YNCardTableViewCell : UITableViewCell

typedef NS_ENUM(NSInteger, SharedItemType)
{
    TextType,
    PictureType,
    AudioType,
    VideoType
};

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellItemType:(SharedItemType)cellItemType;


@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *postTimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) KIChameleonView *attachView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) AVObject *post;

@end
