//
//  FriendCardTableViewCell.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-5.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "FriendCardTableViewCell.h"
#import "chameleon.h"

@implementation FriendCardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.layer.cornerRadius = _avatarImageView.layer.frame.size.height / 2;
        _avatarImageView.layer.borderWidth = 0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 170, 21)];
        _nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        _nameLabel.textColor =[UIColor flatNavyBlueColorDark];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 178, 56)];
        _profileLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
        _profileLabel.textColor = [UIColor flatNavyBlueColorDark];
        _profileLabel.alpha = 0.8f;
        _profileLabel.numberOfLines = 0;
        _profileLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_profileLabel];
        
        _addOrCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 15, 20, 20)];
        [_addOrCancelButton setTitle:@"" forState:UIControlStateNormal];
        _addOrCancelButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_addOrCancelButton];
    }
    return self;
}









- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
