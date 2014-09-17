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

@interface AppMainViewController ()
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, retain) NSMutableArray *authors;
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
    self.authors = [NSMutableArray array];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    [self initLeftMenuButton];
    [self initRightMenuButton];
    [self initTableView];
    [self initPostButton];

//    [self loadNewPosts];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadNewPosts];
}

- (void)loadNewPosts
{
    AVQuery *query = [AVQuery queryWithClassName:@"Question"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        NSMutableArray *newPosts = [NSMutableArray array];
        NSArray *postIds = [self.posts valueForKeyPath:@"objectId"];
        if (error == nil) {
            for (AVObject *post in posts) {
                if (![postIds containsObject:post.objectId]) {
                    [newPosts addObject:post];
                }
            }
            posts = [newPosts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]]];
            long offset = 0;
            if (self.posts.count) {
                offset = self.posts.count;
            }
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(offset, posts.count)];
            [self.posts insertObjects:posts atIndexes:set];
            
            [self.contentTableView reloadData];
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
    #define PHOTO_HEIGHT 300.0f
    #define VEDIO_HEIGHT 340.0f
    #define AUDIO_HEIGHT 260.0f
    CGFloat height = 0.0;
    NSDictionary *itemDict = self.posts[indexPath.row];
    NSInteger type = [[itemDict objectForKey:@"type"] integerValue];
    switch (type) {
        case 1:
        {
            height =  PHOTO_HEIGHT;
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

    NSDictionary *master = [postObject.dictionaryForObject objectForKey:@"master"];
    
    NSArray *likeusersId = [postObject.dictionaryForObject objectForKey:@"likeusersid"];
    //TODO figure out what's the cellitemtype according to data
    switch (type) {
        case 0:
        {
            if (cell == nil) {
                cell = [[YNCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:TextType];
            }
            cell.avatarImageView.image = [UIImage imageNamed:[master objectForKey:@"avatar"]];
            cell.usernameLabel.text = [master objectForKey:@"username"];
            
            cell.timeLabel.text = [DateFormatter friendlyDate:postObject.createdAt];
            cell.itemTypeIconView.image = [UIImage imageNamed:@"text-icon"];
            cell.itemContentLabel.text = [postObject.dictionaryForObject objectForKey:@"content"];
            if ([likeusersId containsObject:[master objectForKey:@"objectId"]]) {
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
            } else
            {
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            }
            
           
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

            cell.avatarImageView.image = [UIImage imageNamed:[master objectForKey:@"avatar"]];
            
            cell.usernameLabel.text = [master objectForKey:@"username"];
            cell.timeLabel.text = [DateFormatter friendlyDate:postObject.createdAt];
            

            
            cell.itemTypeIconView.image = [UIImage imageNamed:@"photo-icon"];
            cell.itemContentLabel.text = [postObject.dictionaryForObject objectForKey:@"content"];
            
            NSDictionary *imageFileInfo = [postObject.dictionaryForObject objectForKey:@"attachphoto"];
            NSURL *imageUrl = [NSURL URLWithString:[imageFileInfo objectForKey:@"url"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            cell.attachPhotoContainerView.image = [UIImage imageWithData:imageData];
            
            
            if ([likeusersId containsObject:[master objectForKey:@"objectId"]]) {
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
            } else
            {
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            }
            
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
            cell.avatarImageView.image = [UIImage imageNamed:@"default"];
            cell.usernameLabel.text = @"Nicholas Xue";
            cell.timeLabel.text = [DateFormatter friendlyDate:postObject.createdAt];
            cell.itemTypeIconView.image = [UIImage imageNamed:@"photo-icon"];
            cell.itemContentLabel.text = [postObject.dictionaryForObject objectForKey:@"content"];
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
    //Now go to the static page
    //TODO the real data page
    
    DetailViewController *detailViewController = [DetailViewController new];
    
    detailViewController.post = self.posts[indexPath.row];
    NSDictionary *author = [[self.posts[indexPath.row] dictionaryForObject] objectForKey:@"master"];
    detailViewController.author = author;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)initTableView
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
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
    YNCardTableViewCell *cell = (YNCardTableViewCell *)[[[sender superview] superview] superview];
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
