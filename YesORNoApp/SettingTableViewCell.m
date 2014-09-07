//
//  SettingTableViewCell.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "chameleon.h"

@implementation SettingTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initInfoLabel];
        [self initTitleLabel];
        [self initItemImageView];
    }
    
    return self;
}

-(void)initTitleLabel
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 70, 21)];
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    _titleLabel.textColor = [UIColor flatNavyBlueColorDark];
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_titleLabel];
}

-(void)initInfoLabel
{
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(149, 8, 163, 34)];
    _infoLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    _infoLabel.textColor = [UIColor flatNavyBlueColorDark];
    _infoLabel.textAlignment = NSTextAlignmentRight;
    _infoLabel.numberOfLines = 0;
    _infoLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_infoLabel];
}

-(void)initItemImageView
{
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(272, 5, 40, 40)];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFill;
    _itemImageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_itemImageView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
