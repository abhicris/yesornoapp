//
//  UserPageTableViewCell.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPageTableViewCell : UITableViewCell
typedef NS_ENUM(NSInteger, SharedItemType)
{
    TextType,
    PictureType,
    AudioType,
    VideoType
};
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellItemType:(SharedItemType)cellItemType;

@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UILabel *mdLabel;
@property (nonatomic, strong)UILabel *hourLabel;
@property (nonatomic, strong)UIImageView *typeImageView;
@property (nonatomic, strong)UIImageView *lineImageView;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIView *attachMentView;

@end
