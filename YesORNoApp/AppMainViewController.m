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


@interface AppMainViewController ()

@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong)NSDictionary *allData;
@property (nonatomic, strong)NSArray *itemListData;
@property (nonatomic, strong)NSDictionary *itemData;
@property (nonatomic, strong)NSDictionary *userInfo;


@end

@implementation AppMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.view.backgroundColor = [UIColor flatWhiteColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    [self initLeftMenuButton];
    [self initRightMenuButton];
    
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filepath = [bundle pathForResource:@"testdata" ofType:@"plist"];
    self.allData = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    NSLog(@"%@", self.allData);
    
    self.itemListData = self.allData[@"posts"];
    self.userInfo = self.allData[@"user"];
    [self initTableView];
    [self initPostButton];
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
//    NSLog(@"%d", [self.itemListData count]);
    return [self.itemListData count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //here set cell height according to itemtype
    #define TEXT_HEIGHT 166.0f
    #define PHOTO_HEIGHT 300.0f
    #define VEDIO_HEIGHT 340.0f
    #define AUDIO_HEIGHT 260.0f
    CGFloat height = 0.0;
    NSDictionary *itemDict = self.itemListData[indexPath.row];
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
    
    NSDictionary *itemDict = self.itemListData[indexPath.row];
    NSInteger type = [[itemDict objectForKey:@"type"] integerValue];
//    NSString *timeStr = [itemDict objectForKey:@"time"];
    NSDate *time = [NSDate date];
    //TODO figure out what's the cellitemtype according to data
    switch (type) {
        case 0:
        {
            if (cell == nil) {
                cell = [[YNCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:TextType];
            }
            cell.avatarImageView.image = [UIImage imageNamed:[self.userInfo objectForKey:@"avatar"]];
            cell.usernameLabel.text = [self.userInfo objectForKey:@"name"];
            NSLog(@"%@", [DateFormatter friendlyDate:time]);
            cell.timeLabel.text = [DateFormatter friendlyDate:time];
            cell.itemTypeIconView.image = [UIImage imageNamed:@"text-icon"];
            cell.itemContentLabel.text = [itemDict objectForKey:@"content"];
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", [itemDict objectForKey:@"likecount"]];
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment2-icon"] forState:UIControlStateNormal];
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", [itemDict objectForKey:@"commentcount"]];

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
            //here use static test data to bind
            //TODO use the real data
            cell.avatarImageView.image = [UIImage imageNamed:[self.userInfo objectForKey:@"avatar"]];
            
            cell.usernameLabel.text = [self.userInfo objectForKey:@"name"];
            cell.timeLabel.text = [DateFormatter friendlyDate:time];
            cell.itemTypeIconView.image = [UIImage imageNamed:@"photo-icon"];
            cell.itemContentLabel.text = [itemDict objectForKey:@"content"];
            
            cell.attachPhotoContainerView.image = [UIImage imageNamed:[itemDict objectForKey:@"attachurl"]];
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", [itemDict objectForKey:@"likecount"]];
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment2-icon"] forState:UIControlStateNormal];
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", [itemDict objectForKey:@"commentcount"]];
            
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
            cell.timeLabel.text = [DateFormatter friendlyDate:time];
            cell.itemTypeIconView.image = [UIImage imageNamed:@"photo-icon"];
            cell.itemContentLabel.text = [itemDict objectForKey:@"content"];
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = [itemDict objectForKey:@"likecount"];
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment2-icon"] forState:UIControlStateNormal];
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = [itemDict objectForKey:@"commentcount"];
            
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
    
    NSDictionary *itemdict = self.itemListData[indexPath.row];
    DetailViewController *detailViewController = [DetailViewController new];
    
    detailViewController.itemInfo = itemdict;
    detailViewController.authorInfo = self.userInfo;
    
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

-(void)likeButtonPressed:(id)sender
{
    
}
-(void)commentButtonPressed:(id)sender
{
    
}
-(void)shareButtonPressed:(id)sender
{
    
}
- (void)notificationButtonPressed:(id)sender
{
    NSLog(@"notifications to see!");
}

@end
