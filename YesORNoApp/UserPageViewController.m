//
//  UserPageViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "UserPageViewController.h"
#import "VBFPopFlatButton.h"
#import "chameleon.h"
#import "RESideMenu/RESideMenu.h"
#import "UserPageTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UserSettingViewController.h"
#import "DateFormatter.h"

@interface UserPageViewController ()
@property (nonatomic, strong)UIView *topUserInfoView;
@property (nonatomic, strong)UIImageView *topBackgroundImageView;
@property (nonatomic, strong)UIImageView *avatarView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *profileLabel;
@property (nonatomic, strong)UIImageView *genderImageView;
@property (nonatomic, strong)UIImageView *locationImageView;
@property (nonatomic, strong)UILabel *genderLabel;
@property (nonatomic, strong)UILabel *locationLabel;
@property (nonatomic, strong)UILabel *postTitle;
@property (nonatomic, strong)UILabel *friendsTitle;
@property (nonatomic, strong)UILabel *postCount;
@property (nonatomic, strong)UILabel *friendsCount;
@property (nonatomic, strong)UIButton *addFriendButton;
@property (nonatomic, strong)UIButton *cancelFriendButton;
@property (nonatomic, strong)UITableView *postsTableView;


@property (nonatomic, strong)VBFPopFlatButton *leftMenuButton;
@property (nonatomic, strong)UIButton *rightMenuButton;

@property (nonatomic)BOOL hasFriended;

@property (nonatomic)NSInteger typeCell;

@property (nonatomic, strong)NSArray *postData;
@end

@implementation UserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Me";
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    [self initLeftMenuButton];
    [self initRightMenuButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftMenuButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightMenuButton];
    
    self.hasFriended = YES;
    self.typeCell = 0;
    [self initpostsTableView];
    [self initTopUserInfoView];
}

- (void)initLeftMenuButton
{
    self.leftMenuButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonMenuType buttonStyle:buttonPlainStyle];
    self.leftMenuButton.lineThickness = 2;
    self.leftMenuButton.tintColor = [UIColor whiteColor];
    [self.leftMenuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initRightMenuButton
{
    self.rightMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [self.rightMenuButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightMenuButton setBackgroundImage:[UIImage imageNamed:@"edit-icon"] forState:UIControlStateNormal];
    [self.rightMenuButton addTarget:self action:@selector(editProfileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)initTopUserInfoView
{
    self.topUserInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 265)];
    self.topUserInfoView.backgroundColor = [UIColor flatWhiteColor];
    
    [self initTopBackgroundImageView];
    [self initavatarImageView];
    [self initNameLabel];
    [self initProfileLabel];
    [self initGenderImageView];
    [self initGenderLabel];
    [self initLocationImageView];
    [self initLocationLabel];
    [self initPostTitle];
    [self initPostCount];
    [self initFriendCount];
    [self initFriendTitle];
    [self initAddOrCancelButton];
    
    
//    [self.view addSubview:self.topUserInfoView];
    self.postsTableView.tableHeaderView = self.topUserInfoView;
}

- (void)initTopBackgroundImageView
{
    self.topBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    self.topBackgroundImageView.backgroundColor = [UIColor clearColor];
    self.topBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topBackgroundImageView.image = [UIImage imageNamed:@"test-blur"];
    
    [self.topUserInfoView addSubview:self.topBackgroundImageView];
}

- (void)initavatarImageView
{
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 22, 60, 60)];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = self.avatarView.layer.frame.size.height / 2;
    self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarView.layer.borderWidth = 2;
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.image = [UIImage imageNamed:@"default2"];
    
    [self.topBackgroundImageView addSubview:self.avatarView];
}

- (void)initNameLabel
{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 90, 181, 21)];
    self.nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.text = @"Nicholas Xue";
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    [self.topBackgroundImageView addSubview:self.nameLabel];
}

- (void)initProfileLabel
{
    self.profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 111, 181, 40)];
    self.profileLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    self.profileLabel.textAlignment = NSTextAlignmentCenter;
    self.profileLabel.text = @"A normal geek and also a very funny handsome guy!";
    self.profileLabel.numberOfLines = 0;
    self.profileLabel.textColor = [UIColor whiteColor];
    self.profileLabel.backgroundColor = [UIColor clearColor];
    
    [self.topBackgroundImageView addSubview:self.profileLabel];
}

- (void)initGenderImageView
{
    self.genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(98, 159, 16, 16)];
    self.genderImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.genderImageView.backgroundColor = [UIColor clearColor];
    self.genderImageView.image = [UIImage imageNamed:@"gender-icon"];
    
    [self.topBackgroundImageView addSubview:self.genderImageView];
}

- (void)initLocationImageView
{
    self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(176, 159, 14, 20)];
    self.locationImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.locationImageView.backgroundColor = [UIColor clearColor];
    self.locationImageView.image = [UIImage imageNamed:@"location-icon"];
    
    [self.topBackgroundImageView addSubview:self.locationImageView];
}

- (void)initGenderLabel
{
    self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 160, 46, 15)];
    self.genderLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.genderLabel.text = @"Female";
    self.genderLabel.textColor = [UIColor whiteColor];
    self.genderLabel.backgroundColor = [UIColor clearColor];
    
    [self.topBackgroundImageView addSubview:self.genderLabel];
}

- (void)initLocationLabel
{
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(198, 160, 90, 15)];
    self.locationLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.locationLabel.text = @"Shanghai, China";
    self.locationLabel.textColor = [UIColor whiteColor];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    
    [self.topBackgroundImageView addSubview:self.locationLabel];
}

- (void)initPostTitle
{
    self.postTitle = [[UILabel alloc] initWithFrame:CGRectMake(32, 213, 44, 21)];
    self.postTitle.text = @"Posts";
    self.postTitle.textColor = [UIColor flatNavyBlueColorDark];
    self.postTitle.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.postTitle.backgroundColor = [UIColor clearColor];
    
    [self.topUserInfoView addSubview:self.postTitle];
}

- (void)initPostCount
{
    self.postCount = [[UILabel alloc] initWithFrame:CGRectMake(17, 236, 75, 21)];
    self.postCount.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    self.postCount.textColor = [UIColor flatNavyBlueColorDark];
    self.postCount.text = @"200000";
    self.postCount.textAlignment = NSTextAlignmentCenter;
    self.postCount.backgroundColor = [UIColor clearColor];
    
    [self.topUserInfoView addSubview:self.postCount];
}

- (void)initFriendTitle
{
    self.friendsTitle = [[UILabel alloc] initWithFrame:CGRectMake(138, 213, 44, 21)];
    self.friendsTitle.text = @"Friends";
    self.friendsTitle.textColor = [UIColor flatNavyBlueColorDark];
    self.friendsTitle.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.friendsTitle.backgroundColor = [UIColor clearColor];
    
    [self.topUserInfoView addSubview:self.friendsTitle];
}

- (void)initFriendCount
{
    self.friendsCount = [[UILabel alloc] initWithFrame:CGRectMake(123, 236, 75, 21)];
    self.friendsCount.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    self.friendsCount.textColor = [UIColor flatNavyBlueColorDark];
    self.friendsCount.text = @"200";
    self.friendsCount.textAlignment = NSTextAlignmentCenter;
    self.friendsCount.backgroundColor = [UIColor clearColor];
    
    [self.topUserInfoView addSubview:self.friendsCount];
}


- (void)initAddOrCancelButton
{
    self.addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(212, 218, 94, 32)];
    self.cancelFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(212, 218, 94, 32)];
    
    self.addFriendButton.backgroundColor = [UIColor flatMintColor];
    self.cancelFriendButton.backgroundColor = [UIColor flatRedColor];
    
    [self.addFriendButton setTitle:@"Add" forState:UIControlStateNormal];
    [self.cancelFriendButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addFriendButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    self.cancelFriendButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    self.addFriendButton.layer.cornerRadius = 5;
    self.cancelFriendButton.layer.cornerRadius = 5;
    
    [self.addFriendButton addTarget:self action:@selector(addFriendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelFriendButton addTarget:self action:@selector(cancelFriendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (self.hasFriended) {
        [self.topUserInfoView addSubview:self.cancelFriendButton];
    } else {
        [self.topUserInfoView addSubview:self.addFriendButton];
    }
}


-(void)initpostsTableView
{
    self.postsTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.postsTableView.backgroundColor = [UIColor whiteColor];
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    self.postsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.postsTableView];
}

- (void)editProfileButtonPressed:(id)sender
{
    [self.navigationController pushViewController:[UserSettingViewController new] animated:YES];
}

-(void)addFriendButtonPressed:(id)sender
{
    
}
-(void)cancelFriendButtonPressed:(id)sender
{
    
}
#pragma mark - UITableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define PICTURE_HEIGHT 200
#define VIDEO_HEIGHT 200
#define AUDIO_HEIGHT 140
#define TEXT_HEIGHT 60
//    NSInteger typeCell = self.postData[indexPath.row];
    CGFloat height = 0.0f;
    switch (self.typeCell) {
        case PictureType:
        {
            height = PICTURE_HEIGHT;
            break;
        }
        case AudioType:
        {
            height =  AUDIO_HEIGHT;
            break;
        }
        case VideoType:
        {
            height =  VIDEO_HEIGHT;
            break;
        }
        case TextType:
        {
            height =  TEXT_HEIGHT;
            break;
        }

    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"postcell";
    UserPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (self.typeCell) {
        case PictureType:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:PictureType];
            }
            cell.yearLabel.text = @"2014年";
            cell.mdLabel.text = @"6月2日";
            cell.hourLabel.text = @"12:30";
            cell.detailLabel.text = @"You will also find VBFDoubleSegment which is just a helping class.";
            cell.typeImageView.image = [UIImage imageNamed:@"photo-icon"];
            cell.lineImageView.image = [UIImage imageNamed:@"line-icon"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.attachMentView.frame), CGRectGetHeight(cell.attachMentView.frame))];
            imageView.image = [UIImage imageNamed:@"test"];
            [cell.attachMentView addSubview:imageView];
            
            return cell;
            break;

        }
        case VideoType:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:VideoType];
            }
            cell.yearLabel.text = @"2014年";
            cell.mdLabel.text = @"6月2日";
            cell.hourLabel.text = @"12:30";
            cell.detailLabel.text = @"You will also find VBFDoubleSegment which is just a helping class.";
            cell.typeImageView.image = [UIImage imageNamed:@"video-icon"];
            cell.lineImageView.image = [UIImage imageNamed:@"line-icon"];
            //TODO add Video player
            
            return cell;
            break;
        }
        case AudioType:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:AudioType];
            }
            cell.yearLabel.text = @"2014年";
            cell.mdLabel.text = @"6月2日";
            cell.hourLabel.text = @"12:30";
            cell.detailLabel.text = @"You will also find VBFDoubleSegment which is just a helping class.";
            cell.typeImageView.image = [UIImage imageNamed:@"micro-icon"];
            cell.lineImageView.image = [UIImage imageNamed:@"line-icon"];
            //TODO add audio player
            
            return cell;
            break;
        }
        default:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:TextType];
            }
            cell.yearLabel.text = @"2014年";
            cell.mdLabel.text = @"6月2日";
            cell.hourLabel.text = @"12:30";
            cell.detailLabel.text = @"You will also find VBFDoubleSegment which is just a helping class.";
            cell.typeImageView.image = [UIImage imageNamed:@"text-icon"];
            cell.lineImageView.image = [UIImage imageNamed:@"line-icon"];
            
            return cell;

            break;
        }
    }
 
    return cell;
}
@end
