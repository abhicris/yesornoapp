//
//  CommentTableViewCell.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-10.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "chameleon.h"

@implementation CommentTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.layer.cornerRadius = _avatarImageView.layer.frame.size.height / 2;
        _avatarImageView.layer.borderWidth = 0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 8, 250, 21)];
        _nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
        _nameLabel.textColor =[UIColor flatNavyBlueColorDark];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
        _contentLabel.textColor = [UIColor flatNavyBlueColorDark];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        
        _timeIconview = [[UIImageView alloc] initWithFrame:CGRectZero];
        _timeIconview.contentMode = UIViewContentModeScaleAspectFill;
        _timeIconview.image = [UIImage imageNamed:@"time-icon"];
        [self addSubview:_timeIconview];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
        _timeLabel.textColor = [UIColor flatWhiteColorDark];
        [self addSubview:_timeLabel];
        
        _replyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_replyButton setBackgroundImage:[UIImage imageNamed:@"reply-icon"] forState:UIControlStateNormal];
        _replyButton.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_replyButton];
        
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLabel.text = @"reply";
        _replyLabel.textColor = [UIColor flatWhiteColorDark];
        _replyLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
        _replyLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_replyLabel];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
