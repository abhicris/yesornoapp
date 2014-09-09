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
            case TextType:
                [self initCardContainerView];
                _cardContainerView.frame = CGRectMake(10, 10, 300, 146);
                [self initItemTypeIconView];
                _itemTypeIconView.frame = CGRectMake(272, 8, 18, 22);
                [self addTopControls];
                
                [self initOtherControlls];
                
                _likeButton.frame = CGRectMake(8, 118, 14, 13);
                _likeCountLabel.frame = CGRectMake(30, 113, 34, 21);
                _commentButton.frame = CGRectMake(72, 118, 14, 14);
                _commentCountLabel.frame = CGRectMake(94, 113, 34, 21);
                _shareButton.frame = CGRectMake(136, 118, 14, 12);
                
                [self addAllCardSubViews];
                [self addSubview:_cardContainerView];
                break;
            case PictureType:
                [self initCardContainerView];
                _cardContainerView.frame = CGRectMake(10, 10, 300, 280);
                
                [self initItemTypeIconView];
                _itemTypeIconView.frame = CGRectMake(272, 8, 20, 20);
                [self addTopControls];
                
                [self initAttachPhotoContainerView];
                _attachPhotoContainerView.frame = CGRectMake(8, 109, 284, 134);
 
                [self initOtherControlls];
                _likeButton.frame = CGRectMake(8, 256, 14, 13);
                _likeCountLabel.frame = CGRectMake(30, 251, 34, 21);
                _commentButton.frame = CGRectMake(72, 256, 14, 14);
                _commentCountLabel.frame = CGRectMake(94, 251, 34, 21);
                _shareButton.frame = CGRectMake(136, 256, 14, 12);
                
                [self addAllCardSubViews];
                [_cardContainerView addSubview:_attachPhotoContainerView];
                [self addSubview:_cardContainerView];
                
                break;
            case AudioType:
                [self initCardContainerView];
                _cardContainerView.frame = CGRectMake(10, 10, 300, 230);
                [self initItemTypeIconView];
                _itemTypeIconView.frame = CGRectMake(272, 8, 20, 28);
                
                [self addTopControls];
                
                [self initAttachAudioContainerView];
                _attachAudioContainerView.frame = CGRectMake(8, 114, 284, 80);
                
                [self initOtherControlls];
                _likeButton.frame = CGRectMake(8, 214, 14, 13);
                _likeCountLabel.frame = CGRectMake(30, 209, 34, 21);
                _commentButton.frame = CGRectMake(72, 214, 14, 14);
                _commentCountLabel.frame = CGRectMake(94, 209, 34, 21);
                _shareButton.frame = CGRectMake(136, 214, 14, 12);
                
                [self addAllCardSubViews];
                [_cardContainerView addSubview:_attachAudioContainerView];
                [self addSubview:_cardContainerView];
                break;
            case VideoType:
                [self initCardContainerView];
                _cardContainerView.frame = CGRectMake(10, 10, 300, 360);
                [self initItemTypeIconView];
                _itemTypeIconView.frame = CGRectMake(272, 8, 20, 14);
                
                [self addTopControls];
                [self initAttachVideoContainerView];
                _attachVideoContainerView.frame = CGRectMake(8, 114, 284, 160);
                
                [self initOtherControlls];
                _likeButton.frame = CGRectMake(8, 293, 14, 13);
                _likeCountLabel.frame = CGRectMake(30, 288, 34, 21);
                _commentButton.frame = CGRectMake(72, 293, 14, 14);
                _commentCountLabel.frame = CGRectMake(94, 288, 34, 21);
                _shareButton.frame = CGRectMake(136, 293, 14, 12);
                
                [self addAllCardSubViews];
                [_cardContainerView addSubview:_attachVideoContainerView];
                [self addSubview:_cardContainerView];
                break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    return self;
}

-(void)addAllCardSubViews
{
    [_cardContainerView addSubview:_avatarImageView];
    [_cardContainerView addSubview:_usernameLabel];
    [_cardContainerView addSubview:_timeLabel];
    [_cardContainerView addSubview:_itemTypeIconView];
    [_cardContainerView addSubview:_itemContentLabel];
    
    [_cardContainerView addSubview:_likeButton];
    [_cardContainerView addSubview:_likeCountLabel];
    [_cardContainerView addSubview:_commentButton];
    [_cardContainerView addSubview:_commentCountLabel];
    [_cardContainerView addSubview:_shareButton];
}

- (void)addTopControls
{
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
    _avatarImageView.layer.cornerRadius = _avatarImageView.layer.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.backgroundColor = [UIColor clearColor];
    [_cardContainerView addSubview:_avatarImageView];
    [self initNameLabel];
    _usernameLabel.frame = CGRectMake(61, 8, 180, 21);
    [self initTimeLabel];
    _timeLabel.frame = CGRectMake(61, 27, 180, 21);
    
    [self initItemContentLabel];
    _itemContentLabel.frame = CGRectMake(8, 56, 284, 50);
    
}

- (void)initCardContainerView
{
    _cardContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _cardContainerView.backgroundColor = [UIColor whiteColor];
    _cardContainerView.layer.borderWidth = 0;
    _cardContainerView.layer.cornerRadius = 2;
}


-(void)initNameLabel
{
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _usernameLabel.textColor = [UIColor flatNavyBlueColorDark];
    _usernameLabel.backgroundColor = [UIColor clearColor];
    _usernameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
}

-(void)initTimeLabel
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [UIColor flatGrayColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font =[UIFont fontWithName:@"Roboto-Medium" size:12];
}

- (void)initItemTypeIconView
{
    _itemTypeIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _itemTypeIconView.backgroundColor =[UIColor clearColor];
    _itemTypeIconView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)initItemContentLabel
{
    _itemContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _itemContentLabel.textColor = [UIColor flatNavyBlueColorDark];
    _itemContentLabel.numberOfLines = 0;
    _itemContentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
}

-(void)initAttachPhotoContainerView
{
    _attachPhotoContainerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _attachPhotoContainerView.backgroundColor = [UIColor clearColor];
    _attachPhotoContainerView.layer.borderWidth = 0;
    _attachPhotoContainerView.layer.masksToBounds = YES;
    _attachPhotoContainerView.clipsToBounds = YES;
    _attachPhotoContainerView.contentMode = UIViewContentModeScaleAspectFill;
    
}

-(void)initAttachAudioContainerView
{
    _attachVideoContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _attachAudioContainerView.backgroundColor = [UIColor clearColor];
}

- (void)initAttachVideoContainerView
{
    _attachVideoContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _attachVideoContainerView.backgroundColor = [UIColor clearColor];
}



-(void)initOtherControlls
{
    _likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _likeButton.contentMode = UIViewContentModeScaleAspectFill;
    [_likeButton setTitle:@"" forState:UIControlStateNormal];
    _likeButton.backgroundColor= [UIColor clearColor];

    
    _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _likeCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _likeCountLabel.textColor = [UIColor flatWhiteColorDark];

    
    _commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _commentButton.backgroundColor = [UIColor clearColor];
    [_commentButton setTitle:@"" forState:UIControlStateNormal];
    _commentButton.contentMode = UIViewContentModeScaleAspectFill;

    
    _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _commentCountLabel.textColor = [UIColor flatWhiteColorDark];

    
    _shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setTitle:@"" forState:UIControlStateNormal];
    _shareButton.contentMode = UIViewContentModeScaleAspectFill;

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
