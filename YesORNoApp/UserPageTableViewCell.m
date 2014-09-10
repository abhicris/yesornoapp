//
//  UserPageTableViewCell.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "UserPageTableViewCell.h"
#import "chameleon.h"

@implementation UserPageTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellItemType:(SharedItemType)cellItemType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        
        switch (cellItemType) {
            case PictureType:
            {
                [self initControls];
                _typeIconView.backgroundColor = [UIColor flatRedColor];
                _typeIconView.image = [UIImage imageNamed:@"photo-s-icon"];
                
                _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(83, 78, 229, 80)];
                _photoView.contentMode = UIViewContentModeScaleAspectFill;
                _photoView.layer.masksToBounds = YES;
                [self addSubview:_photoView];
                
                _timeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(83, 166, 14, 14)];
                _timeIconView.contentMode = UIViewContentModeScaleAspectFill;
                _timeIconView.image = [UIImage imageNamed:@"time-icon"];
                
                _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 162, 207, 21)];
                _timeLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
                _timeLabel.textColor = [UIColor flatWhiteColorDark];
                
                
                [self addSubviews];
                break;
            }
            case VideoType:
            {

                break;
            }
            case AudioType:
            {

                break;
            }
            case TextType:
            {

                [self initControls];
                _typeIconView.backgroundColor = [UIColor flatSkyBlueColor];
                _typeIconView.image = [UIImage imageNamed:@"text-s-icon"];
                
                _timeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(83, 83, 14, 14)];
                _timeIconView.contentMode = UIViewContentModeScaleAspectFill;
                _timeIconView.image = [UIImage imageNamed:@"time-icon"];
                
                _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 79, 207, 21)];
                _timeLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
                _timeLabel.textColor = [UIColor flatWhiteColorDark];
                
                [self addSubviews];

                break;
            }
                
        }
    }
    return self;
}

- (void)initControls
{
    _typeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
    _typeIconView.contentMode = UIViewContentModeCenter;
    _typeIconView.layer.cornerRadius = _typeIconView.layer.frame.size.height / 2;
    _typeIconView.layer.masksToBounds = YES;

    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 8, 30, 30)];
    _avatarImageView.layer.cornerRadius = _avatarImageView.layer.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 8, 229, 21)];
    _nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    _nameLabel.textColor = [UIColor flatNavyBlueColorDark];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 29, 229, 46)];
    _contentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor flatNavyBlueColorDark];
}

- (void)addSubviews
{
    [self addSubview:_typeIconView];
    [self addSubview:_avatarImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_contentLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_timeIconView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
