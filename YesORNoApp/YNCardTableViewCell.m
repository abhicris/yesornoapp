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
                [self initCellTop];
                [self initBottomControls];
                _likeButton.frame = CGRectMake(10, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 15, 14, 13);
                _likeCountLabel.frame = CGRectMake(32, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 15, 40, 15);
                _commentButton.frame = CGRectMake(90, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 15, 14, 14);
                _commentCountLabel.frame = CGRectMake(112, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 15, 38, 15);
                _shareButton.frame = CGRectMake(170, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 15, 14, 12);
                [self addBottomControls];
                break;
            case PictureType:
            {
                [self initCellTop];
                [self initBottomControls];
                _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 108, 286, 150)];
                _photoView.contentMode = UIViewContentModeScaleAspectFill;
                _photoView.clipsToBounds = YES;
                [self addSubview:_photoView];
                _likeButton.frame = CGRectMake(10, _photoView.frame.origin.y + _photoView.frame.size.height + 15, 14, 13);
                _likeCountLabel.frame = CGRectMake(32, _photoView.frame.origin.y + _photoView.frame.size.height + 15, 40, 15);
                _commentButton.frame = CGRectMake(90, _photoView.frame.origin.y + _photoView.frame.size.height + 15, 14, 14);
                _commentCountLabel.frame = CGRectMake(112, _photoView.frame.origin.y + _photoView.frame.size.height + 15, 38, 15);
                _shareButton.frame = CGRectMake(170, _photoView.frame.origin.y + _photoView.frame.size.height + 15, 14, 12);
                [self addBottomControls];
                
                break;
            }
            case AudioType:
            {
                [self initCellTop];
                [self initBottomControls];
                _attachView = [[UIView alloc] initWithFrame:CGRectMake(8, 108, 286, 100)];
                _attachView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:_attachView];
                _likeButton.frame = CGRectMake(10, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 14, 13);
                _likeCountLabel.frame = CGRectMake(32, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 40, 15);
                _commentButton.frame = CGRectMake(90, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 14, 14);
                _commentCountLabel.frame = CGRectMake(112, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 38, 15);
                _shareButton.frame = CGRectMake(170, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 14, 12);
                [self addBottomControls];
                break;
            }
            case VideoType:
            {
                [self initCellTop];
                [self initBottomControls];
                _attachView = [[UIView alloc] initWithFrame:CGRectMake(8, 108, 286, 150)];
                _attachView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:_attachView];
                _likeButton.frame = CGRectMake(10, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 14, 13);
                _likeCountLabel.frame = CGRectMake(32, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 40, 15);
                _commentButton.frame = CGRectMake(90, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 14, 14);
                _commentCountLabel.frame = CGRectMake(112, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 38, 15);
                _shareButton.frame = CGRectMake(170, _attachView.frame.origin.y + _attachView.frame.size.height + 15, 14, 12);
                [self addBottomControls];
                break;
            }
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)initCellTop
{
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
    _avatarView.layer.cornerRadius = _avatarView.layer.frame.size.height / 2;
    _avatarView.clipsToBounds = YES;
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_avatarView];
    
    _authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 8, 256, 21)];
    _authorNameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    _authorNameLabel.textColor = [UIColor flatNavyBlueColorDark];
    [self addSubview:_authorNameLabel];
    
    UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(56, 31, 14, 14)];
    timeIcon.contentMode = UIViewContentModeScaleAspectFill;
    timeIcon.image = [UIImage imageNamed:@"time-icon"];
    [self addSubview:timeIcon];
    
    _postTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 31, 232, 15)];
    _postTimeLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    _postTimeLabel.textColor = [UIColor flatWhiteColorDark];
    [self addSubview:_postTimeLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 56, 302, 44)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _contentLabel.textColor = [UIColor flatNavyBlueColorDark];
    [self addSubview:_contentLabel];
}

- (void)initBottomControls
{
    _likeButton = [[UIButton alloc] init];
    [_likeButton setTitle:@"" forState:UIControlStateNormal];
    
    _likeCountLabel = [[UILabel alloc] init];
    _likeCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _likeCountLabel.textColor = [UIColor flatNavyBlueColorDark];
    
    _commentButton = [[UIButton alloc] init];
    [_commentButton setTitle:@"" forState:UIControlStateNormal];
    
    _commentCountLabel = [[UILabel alloc] init];
    _commentCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _commentCountLabel.textColor = [UIColor flatNavyBlueColorDark];
    
    _shareButton = [[UIButton alloc] init];
    [_shareButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)addBottomControls
{
    [self addSubview:_likeButton];
    [self addSubview:_likeCountLabel];
    [self addSubview:_commentButton];
    [self addSubview:_commentCountLabel];
    [self addSubview:_shareButton];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 8;
    frame.size.width -= 2*8;
    frame.origin.y += 8;
    frame.size.height -= 2*8;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
