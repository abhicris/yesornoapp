//
//  AppMainViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "AppMainViewController.h"
#import "VBFPopFlatButton.h"
#import "chameleon.h"
#import "YNCardTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PostViewController.h"
#import "DetailViewController.h"
#import "DateFormatter.h"
#import "RESideMenu/RESideMenu.h"
#import <AVOSCloud/AVOSCloud.h>
#import <POP/POP.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PullToReact.h"


#define QUERY_LIMIT 30
#define ORDER_BY @"createdAt"


@interface AppMainViewController ()
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, retain) AVUser *currentUser;

@end

@implementation AppMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.view.backgroundColor = [UIColor flatWhiteColor];
    self.currentUser = [AVUser currentUser];
    self.posts = [NSMutableArray array];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    [self initLeftMenuButton];
    [self initRightMenuButton];
    [self initTableView];
    [self initPostButton];

    [self findNewPosts:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(AVQuery *)getQuery
{
    AVQuery *query = [AVQuery queryWithClassName:@"Post"];
    [query setLimit:QUERY_LIMIT];
//    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
//    query.maxCacheAge = 60*60*24;
    [query orderByAscending:ORDER_BY];
    [query includeKey:@"author"];
    return query;
}
-(void)findNewPosts:(BOOL)isMore
{
    AVQuery *query = [self getQuery];
    if (self.posts.count) {
        if (!isMore) {
            NSDate *date = [[self.posts firstObject] objectForKey:@"createdAt"];
            [query whereKey:ORDER_BY greaterThan:date];
        } else {
            NSDate *date = [[self.posts lastObject] objectForKey:@"createdAt"];
            [query whereKey:ORDER_BY lessThan:date];
        }
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            if (objects.count) {
                NSMutableArray *newPosts = [NSMutableArray array];
                NSArray *postsIds = [self.posts valueForKeyPath:@"objectId"];
                for (AVObject *post in objects) {
                    if (![postsIds containsObject:post.objectId]) {
                        [newPosts addObject:post];
                    }
                }
                long offset = 0;
                if (isMore) {
                    offset = self.posts.count;
                }
                
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(offset, newPosts.count)];
                [self.posts insertObjects:newPosts atIndexes:indexSet];
                
                [self.posts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:ORDER_BY ascending:NO]]];
                [self.contentTableView reloadData];
            }
        }
    }];
    
}


- (void)initLeftMenuButton
{
    VBFPopFlatButton *leftMenuButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonMenuType buttonStyle:buttonPlainStyle];
    leftMenuButton.lineThickness = 2;
    leftMenuButton.tintColor = [UIColor whiteColor];
    [leftMenuButton addTarget:self action:@selector(leftMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftMenuButton];
}

- (void)initRightMenuButton
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [rightButton setTitle:@"" forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"ring-icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(notificationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)initPostButton
{
    UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 478, 50, 50)];
    [postButton setTitle:@"" forState:UIControlStateNormal];
    postButton.contentMode = UIViewContentModeScaleAspectFill;
    [postButton setBackgroundImage:[UIImage imageNamed:@"post-icon"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:postButton];
}

#pragma mark - UITableView DataSource Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #define TEXT_HEIGHT 166.0f
    #define PHOTO_HEIGHT 320.0f
    #define VEDIO_HEIGHT 320.0f
    #define AUDIO_HEIGHT 260.0f
    CGFloat height = 0.0;
    AVObject *itemDict = self.posts[indexPath.row];
    NSInteger type = [[itemDict.dictionaryForObject objectForKey:@"type"] integerValue];
    switch (type) {
        case 1:
        {
            return PHOTO_HEIGHT;
            
            break;
        }
        case 2:
        {
            height =  AUDIO_HEIGHT;
            break;
        }
        case 3:
        {
            height =  VEDIO_HEIGHT;
            break;
        }
        case 0:
            height =  TEXT_HEIGHT;
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //custom tableview cell - card style
    static NSString *cellIdentifier = @"itemcell";
    YNCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    AVObject *postObject = self.posts[indexPath.row];
    
    NSInteger type = [[postObject.dictionaryForObject objectForKey:@"type"] integerValue];

    AVUser *master = [postObject objectForKey:@"author"];
    
    switch (type) {
        case 0:
        {
            if (cell == nil) {
                cell = [[YNCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:TextType];
            }
            cell.avatarView.image = [UIImage imageNamed:[master.dictionaryForObject objectForKey:@"avatar"]];
            cell.authorNameLabel.text = [master.dictionaryForObject objectForKey:@"username"];
            
            cell.postTimeLabel.text = [DateFormatter friendlyDate:postObject.createdAt];

            cell.contentLabel.text = [postObject.dictionaryForObject objectForKey:@"content"];
 
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", [postObject.dictionaryForObject objectForKey:@"likecount"]];
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment2-icon"] forState:UIControlStateNormal];
            
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", [postObject.dictionaryForObject objectForKey:@"commentcount"]];
            
            [cell.shareButton setBackgroundImage:[UIImage imageNamed:@"share2-icon"] forState:UIControlStateNormal];
            
            [cell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            break;
        }
        case 1:
        {
            if (cell == nil) {
                cell = [[YNCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:PictureType];
            }

            cell.avatarView.image = [UIImage imageNamed:[master.dictionaryForObject objectForKey:@"avatar"]];
            
            cell.authorNameLabel.text = [master.dictionaryForObject objectForKey:@"username"];
            cell.postTimeLabel.text = [DateFormatter friendlyDate:postObject.createdAt];
            
            cell.contentLabel.text = [postObject.dictionaryForObject objectForKey:@"content"];
            
            NSDictionary *imageInfo = [postObject.dictionaryForObject objectForKey:@"attachinfo"];
            NSURL *imageUrl = [NSURL URLWithString:[imageInfo objectForKey:@"url"]];
            [cell.photoView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"test"]];
            
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", [postObject.dictionaryForObject objectForKey:@"likecount"]];
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment2-icon"] forState:UIControlStateNormal];
            
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", [postObject.dictionaryForObject objectForKey:@"commentcount"]];
            
            [cell.shareButton setBackgroundImage:[UIImage imageNamed:@"share2-icon"] forState:UIControlStateNormal];
            
            [cell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            break;
        }
        case 2:
        {
            if (cell == nil) {
                cell = [[YNCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:AudioType];
            }
            cell.avatarView.image = [UIImage imageNamed:@"default"];
            cell.authorNameLabel.text = @"Nicholas Xue";
            cell.postTimeLabel.text = [DateFormatter friendlyDate:postObject.createdAt];

            cell.contentLabel.text = [postObject.dictionaryForObject objectForKey:@"content"];
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = [postObject.dictionaryForObject objectForKey:@"likecount"];
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment2-icon"] forState:UIControlStateNormal];
            
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = [postObject.dictionaryForObject objectForKey:@"commentcount"];
            
            [cell.shareButton setBackgroundImage:[UIImage imageNamed:@"share2-icon"] forState:UIControlStateNormal];
            
            [cell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            break;
        }
    }
    return cell;
}

#pragma mark - UITableView delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [DetailViewController new];
    
    detailViewController.post = self.posts[indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)initTableView
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64) style:UITableViewStylePlain];
    self.contentTableView.backgroundColor= [UIColor clearColor];
    self.contentTableView.dataSource = self;
    self.contentTableView.delegate = self;
    self.contentTableView.separatorColor = [UIColor flatWhiteColor];
    [self.view addSubview:self.contentTableView];
}

- (void)leftMenuButtonPressed:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)postButtonPressed:(id)sender
{
    //create new post
    [self.navigationController pushViewController:[PostViewController new] animated:YES];
}

-(void)likeButtonPressed:(UIButton *)sender
{
    YNCardTableViewCell *cell = (YNCardTableViewCell *)[sender superview];
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    AVObject *post = self.posts[indexPath.row];

    int likecount = [[post.dictionaryForObject objectForKey:@"likecount"] intValue];
    NSMutableArray *likeUsersId = [post.dictionaryForObject objectForKey:@"likeusersid"];
    if (likeUsersId) {
        if ([likeUsersId containsObject:self.currentUser.objectId]) {
            likecount = likecount - 1;
            [post removeObject:self.currentUser.objectId forKey:@"likeusersid"];
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            
        } else {
            likecount = likecount + 1;
            [post addObject:self.currentUser.objectId forKey:@"likeusersid"];
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
        }
    } else {
        likecount = likecount + 1;
        [post addObject:self.currentUser.objectId forKey:@"likeusersid"];
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
    }
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%d", likecount];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.6f, 0.6f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 20;
    [cell.likeButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleanimation"];
    [post setObject:[NSNumber numberWithInt:likecount] forKey:@"likecount"];
    [post saveInBackground];
}
-(void)commentButtonPressed:(id)sender
{
    
}
-(void)shareButtonPressed:(id)sender
{
    //使用第三方分享插件
}
- (void)notificationButtonPressed:(id)sender
{
    NSLog(@"notifications to see!");
}

@end
