//
//  FriendCardTableViewCell.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-5.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCardTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *avatarImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *addOrCancelButton;
@property (nonatomic, strong)UILabel *profileLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
