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
#import <AVOSCloud/AVOSCloud.h>
#import "DateFormatter.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserPageViewController ()

@property (nonatomic, strong)UITableView *postsTableView;
@property (nonatomic, strong)AVUser *userInfo;
@property (nonatomic, strong)NSMutableArray *userPosts;
@property (nonatomic)BOOL hasFriended;


@property (nonatomic, strong) UIButton *postTipButton;
@property (nonatomic, strong) UIButton *followerButton;
@property (nonatomic, strong) UIButton *followeeButton;
@end

@implementation UserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    self.userPosts = [NSMutableArray array];
    if (_user == nil) {
        self.userInfo = [AVUser currentUser];
        [self initLeftMenuButton];
        [self initRightMenuButton];
        [self initpostsTableView];
        [self initTopUserInfoView];
        
        [self loadUserPosts];
    } else {
        AVQuery *query = [AVUser query];
        [query whereKey:@"objectId" equalTo:[_user objectForKey:@"objectId"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (error == nil) {
                if (users.count) {
                    self.userInfo = [users firstObject];
                    [self initLeftMenuButton];
                    [self initRightMenuButton];
                    [self initpostsTableView];
                    [self initTopUserInfoView];
                    
                    [self loadUserPosts];
                }
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    }
}


- (void)loadUserPosts
{
    AVQuery *postQuery = [AVQuery queryWithClassName:@"Post"];
    [postQuery whereKey:@"author" equalTo:self.userInfo];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        
        NSMutableArray *newPosts = [NSMutableArray array];
        NSArray *postIds = [self.userPosts valueForKeyPath:@"objectId"];
        if (error == nil) {
            for (AVObject *post in posts) {
                if (![postIds containsObject:post.objectId]) {
                    [newPosts addObject:post];
                }
            }
            posts = [newPosts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]]];
            long offset = 0;
            if (self.userPosts.count) {
                offset = self.userPosts.count;
            }
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(offset, posts.count)];
            [self.userPosts insertObjects:posts atIndexes:set];
            [self.postsTableView reloadData];
        }
    
    }];
    
}

- (void)initLeftMenuButton
{
    VBFPopFlatButton *leftMenuButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonMenuType buttonStyle:buttonPlainStyle];
    leftMenuButton.lineThickness = 2;
    leftMenuButton.tintColor = [UIColor whiteColor];
    [leftMenuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftMenuButton];
}

- (void)initRightMenuButton
{
    UIButton *rightMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [rightMenuButton setTitle:@"" forState:UIControlStateNormal];
    [rightMenuButton setBackgroundImage:[UIImage imageNamed:@"edit-icon"] forState:UIControlStateNormal];
    [rightMenuButton addTarget:self action:@selector(editProfileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightMenuButton];
}



- (void)initTopUserInfoView
{
    UIView *topUserInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 305)];
    topUserInfoView.backgroundColor = [UIColor flatWhiteColor];
    
    UIImageView *topBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    topBackgroundImageView.backgroundColor = [UIColor clearColor];
    topBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    topBackgroundImageView.clipsToBounds = YES;
    topBackgroundImageView.image = [UIImage imageNamed:@"test-blur"];
    
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 22, 60, 60)];
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.layer.cornerRadius = avatarView.layer.frame.size.height / 2;
    avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarView.layer.borderWidth = 2;
    avatarView.layer.masksToBounds = YES;
    avatarView.image = [UIImage imageNamed:[self.userInfo.dictionaryForObject objectForKey:@"avatar"]];
    
    [topBackgroundImageView addSubview:avatarView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 90, 181, 21)];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = [self.userInfo.dictionaryForObject objectForKey:@"username"];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    
    [topBackgroundImageView addSubview:nameLabel];
    
    UILabel *profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 111, 181, 40)];
    profileLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    profileLabel.textAlignment = NSTextAlignmentCenter;
    profileLabel.text = [self.userInfo.dictionaryForObject objectForKey:@"profile"];
    profileLabel.numberOfLines = 0;
    profileLabel.textColor = [UIColor whiteColor];
    profileLabel.backgroundColor = [UIColor clearColor];
    
    [topBackgroundImageView addSubview:profileLabel];
    
    UIImageView *genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(98, 159, 16, 16)];
    genderImageView.contentMode = UIViewContentModeScaleAspectFill;
    genderImageView.backgroundColor = [UIColor clearColor];
    genderImageView.image = [UIImage imageNamed:@"gender-icon"];
    
    [topBackgroundImageView addSubview:genderImageView];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(176, 159, 14, 20)];
    locationImageView.contentMode = UIViewContentModeScaleAspectFill;
    locationImageView.backgroundColor = [UIColor clearColor];
    locationImageView.image = [UIImage imageNamed:@"location-icon"];
    
    [topBackgroundImageView addSubview:locationImageView];
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 160, 46, 15)];
    genderLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    genderLabel.text = [self.userInfo.dictionaryForObject objectForKey:@"gender"];
    genderLabel.textColor = [UIColor whiteColor];
    genderLabel.backgroundColor = [UIColor clearColor];
    
    [topBackgroundImageView addSubview:genderLabel];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(198, 160, 90, 15)];
    locationLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    locationLabel.text = [self.userInfo.dictionaryForObject objectForKey:@"location"];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.backgroundColor = [UIColor clearColor];
    
    [topBackgroundImageView addSubview:locationLabel];
    
    [topUserInfoView addSubview:topBackgroundImageView];

    
    self.postTipButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 255, 80, 50)];
    self.postTipButton.backgroundColor = [UIColor clearColor];
    self.postTipButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.postTipButton.titleLabel.numberOfLines = 0;
    self.postTipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.postTipButton setTitleColor:[UIColor flatNavyBlueColorDark] forState:UIControlStateNormal];
    AVQuery *postCountQuery = [AVQuery queryWithClassName:@"Post"];
    [postCountQuery whereKey:@"author" equalTo:self.userInfo];
    [postCountQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error == nil) {
            [self.postTipButton setTitle:[NSString stringWithFormat:@"Posts\r%@", [NSNumber numberWithInteger:number]] forState:UIControlStateNormal];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    
    [self.postTipButton addTarget:self action:@selector(postTipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topUserInfoView addSubview:self.postTipButton];
    
    self.followerButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 255, 80, 50)];
    self.followerButton.backgroundColor = [UIColor clearColor];
    self.followerButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.followerButton.titleLabel.numberOfLines = 0;
    self.followerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.followerButton setTitleColor:[UIColor flatNavyBlueColorDark] forState:UIControlStateNormal];
    AVQuery *followerCount = [AVQuery queryWithClassName:@"_Follower"];
    [followerCount whereKey:@"follower" equalTo:self.userInfo];
    [followerCount countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error == nil) {
            [self.followerButton setTitle:[NSString stringWithFormat:@"Followers\r%@", [NSNumber numberWithInteger:number]] forState:UIControlStateNormal];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    [self.followerButton addTarget:self action:@selector(followerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topUserInfoView addSubview:self.followerButton];
    
    self.followeeButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 255, 80, 50)];
    self.followeeButton.backgroundColor = [UIColor clearColor];
    self.followeeButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.followeeButton.titleLabel.numberOfLines = 0;
    self.followeeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.followeeButton setTitleColor:[UIColor flatNavyBlueColorDark] forState:UIControlStateNormal];
    AVQuery *followeeCount = [AVQuery queryWithClassName:@"_Followee"];
    [followeeCount whereKey:@"master" equalTo:self.userInfo];
    [followeeCount countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error == nil) {
            [self.followeeButton setTitle:[NSString stringWithFormat:@"Followees\r%@", [NSNumber numberWithInteger:number]] forState:UIControlStateNormal];
        } else {
            NSLog(@"Error: %@", error);
        }

    }];
    [self.followeeButton addTarget:self action:@selector(followeeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topUserInfoView addSubview:self.followeeButton];
    
    
    
    if (self.userInfo != [AVUser currentUser]) {
        UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 195, 84, 36)];
        UIButton *cancelFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 195, 84, 36)];
        
        addFriendButton.backgroundColor = [UIColor clearColor];
        cancelFriendButton.backgroundColor = [UIColor clearColor];
        addFriendButton.layer.borderColor = [UIColor flatMintColor].CGColor;
        cancelFriendButton.layer.borderColor = [UIColor flatRedColor].CGColor;
        addFriendButton.layer.borderWidth = 1;
        cancelFriendButton.layer.borderWidth = 1;
        addFriendButton.layer.cornerRadius = 18;
        cancelFriendButton.layer.cornerRadius = 18;
        
        addFriendButton.clipsToBounds = YES;
        cancelFriendButton.clipsToBounds = YES;
        
        
        [addFriendButton setTitle:@"Follow" forState:UIControlStateNormal];
        [cancelFriendButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [addFriendButton setTitleColor:[UIColor flatMintColor] forState:UIControlStateNormal];
        [cancelFriendButton setTitleColor:[UIColor flatRedColor] forState:UIControlStateNormal];
        addFriendButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
        cancelFriendButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
        
        
        [addFriendButton addTarget:self action:@selector(addFriendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cancelFriendButton addTarget:self action:@selector(cancelFriendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (self.hasFriended) {
            [topUserInfoView addSubview:cancelFriendButton];
        } else {
            [topUserInfoView addSubview:addFriendButton];
        }
    }
    self.postsTableView.tableHeaderView = topUserInfoView;
}


- (void)postTipButtonPressed:(UIButton *)sender
{
    
}

- (void)followerButtonPressed:(UIButton *)sender
{
    
}

- (void)followeeButtonPressed:(UIButton *)sender
{
    
}

-(void)initpostsTableView
{
    self.postsTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.postsTableView.backgroundColor = [UIColor whiteColor];
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    self.postsTableView.separatorColor = [UIColor flatWhiteColor];
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
    return [self.userPosts count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDict = self.userPosts[indexPath.row];
    NSInteger type = [[itemDict objectForKey:@"type"] integerValue];
#define PICTURE_HEIGHT 193
#define VIDEO_HEIGHT 200
#define AUDIO_HEIGHT 140
#define TEXT_HEIGHT 110
//    NSInteger typeCell = self.postData[indexPath.row];
    CGFloat height = 0.0f;
    switch (type) {
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
    AVObject *itemDict = self.userPosts[indexPath.row];
    NSInteger type = [[itemDict objectForKey:@"type"] integerValue];
    static NSString *cellIdentifier = @"postcell";
    UserPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (type) {
        case PictureType:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:PictureType];
            }
            cell.avatarImageView.image = [UIImage imageNamed:[self.userInfo.dictionaryForObject objectForKey:@"avatar"]];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.username];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@", [itemDict.dictionaryForObject objectForKey:@"content"]];
            
            NSDictionary *imageFileInfo = [itemDict.dictionaryForObject objectForKey:@"attachinfo"];
            NSURL *imageUrl = [NSURL URLWithString:[imageFileInfo objectForKey:@"url"]];

            [cell.photoView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"test"]];
            
            cell.timeLabel.text = [DateFormatter friendlyDate:itemDict.createdAt];
            [self addLineView:cell];
            return cell;
            break;

        }
        case VideoType:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:VideoType];
            }

            //TODO add Video player
            
            return cell;
            break;
        }
        case AudioType:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:AudioType];
            }

            //TODO add audio player
            
            return cell;
            break;
        }
        case TextType:
        {
            if (cell == nil) {
                cell = [[UserPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:TextType];
            }
            cell.avatarImageView.image = [UIImage imageNamed:[self.userInfo.dictionaryForObject objectForKey:@"avatar"]];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.username];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@", [itemDict.dictionaryForObject objectForKey:@"content"]];
            cell.timeLabel.text = [DateFormatter friendlyDate:itemDict.createdAt];
            
            [self addLineView:cell];
            return cell;

            break;
        }
    }
 
    return cell;
}
-(void)addLineView:(UserPageTableViewCell *)cell
{
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(18, 29, 1, cell.timeIconView.frame.origin.y + cell.timeIconView.frame.size.height + 13 - 29 + 7)];
//    NSLog(@"%f", cell.frame.size.height);
    line.backgroundColor = [UIColor flatWhiteColor];
    [cell addSubview:line];
}
@end
