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
        
        [self initYearLabel];
        [self initMdLabel];
        [self initHourLabel];
        [self initDetailLabel];
        [self initLineImageView];
        [self initTypeImageView];
        
        switch (cellItemType) {
            case PictureType:
            {
                _attachMentView = [[UIView alloc] initWithFrame:CGRectMake(91, 58, 221, 128)];
                _attachMentView.backgroundColor = [UIColor clearColor];
                [self addSubview:_attachMentView];
                break;
            }
            case VideoType:
            {
                _attachMentView = [[UIView alloc] initWithFrame:CGRectMake(91, 58, 221, 128)];
                _attachMentView.backgroundColor = [UIColor clearColor];
                [self addSubview:_attachMentView];
                break;
            }
            case AudioType:
            {
                _attachMentView = [[UIView alloc] initWithFrame:CGRectMake(91, 58, 221, 64)];
                _attachMentView.backgroundColor = [UIColor clearColor];
                [self addSubview:_attachMentView];
                break;
            }
            default:
            {
                
                break;
            }
                
        }
    }
    return self;
}

- (void)initYearLabel
{
    _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 40, 15)];
    _yearLabel.textColor = [UIColor flatNavyBlueColorDark];
    _yearLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    _yearLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_yearLabel];
}
-(void)initMdLabel
{
    _mdLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 25, 42, 15)];
    _mdLabel.textColor = [UIColor flatNavyBlueColorDark];
    _mdLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    _mdLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_mdLabel];
}

-(void)initHourLabel
{
    _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 32, 15)];
    _hourLabel.textColor = [UIColor flatNavyBlueColorDark];
    _hourLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    _hourLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_hourLabel];
}

-(void)initDetailLabel
{
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, 0, 175, 50)];
    _detailLabel.textColor = [UIColor flatNavyBlueColorDark];
    _detailLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _detailLabel.numberOfLines = 0;
    _detailLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_detailLabel];
}

- (void)initTypeImageView
{
    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 10, 20, 20)];
    _typeImageView.contentMode = UIViewContentModeScaleAspectFill;

    
    [self addSubview:_typeImageView];
}

- (void)initLineImageView
{
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 0, 2, 200)];
    _lineImageView.contentMode = UIViewContentModeScaleAspectFill;
    _lineImageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_lineImageView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
