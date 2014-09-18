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
@property (nonatomic, strong) UILabel *postCount;
@property (nonatomic, strong) UILabel *friendsCount;
@end

@implementation UserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    self.userPosts = [NSMutableArray array];
    if (_master == nil) {
        self.userInfo = [AVUser currentUser];
        [self initLeftMenuButton];
        [self initRightMenuButton];
        [self initpostsTableView];
        [self initTopUserInfoView];
        
        [self loadUserPosts];
    } else {
        AVQuery *query = [AVUser query];
        [query whereKey:@"objectId" equalTo:[_master objectForKey:@"objectId"]];
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
    AVQuery *postQuery = [AVQuery queryWithClassName:@"Question"];
    [postQuery whereKey:@"author" equalTo:self.userInfo];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        self.postCount.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:posts.count]];
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
    UIView *topUserInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 265)];
    topUserInfoView.backgroundColor = [UIColor flatWhiteColor];
    
    UIImageView *topBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
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

    UILabel *postTitle = [[UILabel alloc] initWithFrame:CGRectMake(32, 213, 44, 21)];
    postTitle.text = @"Posts";
    postTitle.textColor = [UIColor flatNavyBlueColorDark];
    postTitle.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    postTitle.backgroundColor = [UIColor clearColor];
    
    [topUserInfoView addSubview:postTitle];
    
    self.postCount = [[UILabel alloc] initWithFrame:CGRectMake(17, 236, 75, 21)];
    self.postCount.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    self.postCount.textColor = [UIColor flatNavyBlueColorDark];

    self.postCount.textAlignment = NSTextAlignmentCenter;
    self.postCount.backgroundColor = [UIColor clearColor];
    
    [topUserInfoView addSubview:self.postCount];
    
    UILabel *friendsTitle = [[UILabel alloc] initWithFrame:CGRectMake(138, 213, 44, 21)];
    friendsTitle.text = @"Friends";
    friendsTitle.textColor = [UIColor flatNavyBlueColorDark];
    friendsTitle.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    friendsTitle.backgroundColor = [UIColor clearColor];
    
    [topUserInfoView addSubview:friendsTitle];
    self.friendsCount = [[UILabel alloc] initWithFrame:CGRectMake(123, 236, 75, 21)];
    self.friendsCount.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    self.friendsCount.textColor = [UIColor flatNavyBlueColorDark];
    NSArray *friends = [self.userInfo.dictionaryForObject objectForKey:@"friends"];
    self.friendsCount.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:friends.count]];
    self.friendsCount.textAlignment = NSTextAlignmentCenter;
    self.friendsCount.backgroundColor = [UIColor clearColor];
    
    [topUserInfoView addSubview:self.friendsCount];
    
    
    UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(212, 218, 94, 32)];
    UIButton *cancelFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(212, 218, 94, 32)];
    
    addFriendButton.backgroundColor = [UIColor flatMintColor];
    cancelFriendButton.backgroundColor = [UIColor flatRedColor];
    
    [addFriendButton setTitle:@"Add" forState:UIControlStateNormal];
    [cancelFriendButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addFriendButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    cancelFriendButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    addFriendButton.layer.cornerRadius = 5;
    cancelFriendButton.layer.cornerRadius = 5;
    
    [addFriendButton addTarget:self action:@selector(addFriendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelFriendButton addTarget:self action:@selector(cancelFriendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (self.hasFriended) {
        [topUserInfoView addSubview:cancelFriendButton];
    } else {
        [topUserInfoView addSubview:addFriendButton];
    }
    
    self.postsTableView.tableHeaderView = topUserInfoView;
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
            
            NSDictionary *imageFileInfo = [itemDict.dictionaryForObject objectForKey:@"attachphoto"];
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
