//
//  YNCardTableViewCell.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-4.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "YNCardTableViewCell.h"
#import "chameleon.h"

@implementation YNCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellItemType:(SharedItemType)cellItemType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor flatWhiteColor];
        
        switch (cellItemType) {
            case PictureType:
                _cardContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 360)];
                [self initCardContainerView];
                [self addSubviewsToView];
                
                [self initAttachPhotoContainerView];
                
                _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 327, 20, 20)];
                [self initOtherControlls];
                break;
            case AudioType:
                _cardContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 230)];
                [self initCardContainerView];
                [self addSubviewsToView];
                
                [self initAttachAudioContainerView];
                _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 196, 20, 20)];
                [self initOtherControlls];
                break;
            case VideoType:
                _cardContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 360)];
                [self initCardContainerView];
                [self addSubviewsToView];
                
                [self initAttachVideoContainerView];
                _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 327, 20, 20)];
                [self initOtherControlls];
                break;
            default:
                
                _cardContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 150)];
                [self initCardContainerView];
                [self addSubviewsToView];
                
                _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 124, 20, 20)];
                [self initOtherControlls];
                break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    return self;
}

- (void)initCardContainerView
{
    _cardContainerView.backgroundColor = [UIColor whiteColor];
    _cardContainerView.layer.borderWidth = 0;
    _cardContainerView.layer.cornerRadius = 2;
    [self addSubview:_cardContainerView];
}

-(void)addSubviewsToView
{
    [self initAvatarImageView];
    [self initNameLabel];
    [self initTimeLabel];
    [self initItemTypeIconView];
    [self initItemContentLabel];
}

- (void)initAvatarImageView
{
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    _avatarImageView.layer.cornerRadius = _avatarImageView.layer.frame.size.width / 2;
    _avatarImageView.layer.borderWidth = 0;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.backgroundColor = [UIColor whiteColor];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_cardContainerView addSubview:_avatarImageView];
}

-(void)initNameLabel
{
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 180, 17)];
    _usernameLabel.textColor = [UIColor flatNavyBlueColorDark];
    _usernameLabel.backgroundColor = [UIColor clearColor];
    _usernameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    [_cardContainerView addSubview:_usernameLabel];
}

-(void)initTimeLabel
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 28, 180, 15)];
    _timeLabel.textColor = [UIColor flatGrayColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font =[UIFont fontWithName:@"Roboto-Regular" size:12];
    [_cardContainerView addSubview:_timeLabel];
}

- (void)initItemTypeIconView
{
    _itemTypeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 20, 20)];
    _itemTypeIconView.backgroundColor =[UIColor clearColor];
    _itemTypeIconView.contentMode = UIViewContentModeCenter;
    [_cardContainerView addSubview:_itemTypeIconView];
}

- (void)initItemContentLabel
{
    _itemContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 280, 60)];
    _itemContentLabel.textColor = [UIColor flatNavyBlueColorDark];
    _itemContentLabel.numberOfLines = 0;
//    _itemContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _itemContentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13];
    [_cardContainerView addSubview:_itemContentLabel];
}

-(void)initAttachPhotoContainerView
{
    _attachPhotoContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 122, 280, 193)];
    _attachPhotoContainerView.backgroundColor = [UIColor clearColor];
    _attachPhotoContainerView.layer.borderWidth = 0;
    
    [_cardContainerView addSubview:_attachPhotoContainerView];
    
}

-(void)initAttachAudioContainerView
{
    _attachAudioContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 122, 280, 60)];
    _attachAudioContainerView.backgroundColor = [UIColor clearColor];
    [_cardContainerView addSubview:_attachAudioContainerView];
}

- (void)initAttachVideoContainerView
{
    _attachVideoContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 122, 280, 193)];
    _attachVideoContainerView.backgroundColor = [UIColor clearColor];
    [_cardContainerView addSubview:_attachVideoContainerView];
}



-(void)initOtherControlls
{
    _likeButton.contentMode = UIViewContentModeCenter;
    [_likeButton setTitle:@"" forState:UIControlStateNormal];
    _likeButton.backgroundColor= [UIColor clearColor];
    [_cardContainerView addSubview:_likeButton];
    
    _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, _likeButton.frame.origin.y + 2, 55, 15)];
    _likeCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _likeCountLabel.textColor = [UIColor flatNavyBlueColorDark];
    [_cardContainerView addSubview:_likeCountLabel];
    
    _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(100, _likeButton.frame.origin.y, 20, 20)];
    _commentButton.backgroundColor = [UIColor clearColor];
    [_commentButton setTitle:@"" forState:UIControlStateNormal];
    _commentButton.contentMode = UIViewContentModeCenter;
    [_cardContainerView addSubview:_commentButton];
    
    _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(128, _likeButton.frame.origin.y+2, 55, 15)];
    _commentCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _commentCountLabel.textColor = [UIColor flatNavyBlueColorDark];
    [_cardContainerView addSubview:_commentCountLabel];
    
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(190, _likeButton.frame.origin.y, 20, 20)];
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setTitle:@"" forState:UIControlStateNormal];
    _shareButton.contentMode = UIViewContentModeCenter;
    [_cardContainerView addSubview:_shareButton];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
