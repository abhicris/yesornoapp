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

@interface AppMainViewController ()
@property (nonatomic, strong) VBFPopFlatButton *leftMenuButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic) NSInteger itemType;



@property (nonatomic, strong)NSArray *itemListData;
@property (nonatomic, strong)NSDictionary *itemData;

@end

@implementation AppMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.view.backgroundColor = [UIColor flatWhiteColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    [self initLeftMenuButton];
    [self initRightMenuButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftMenuButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    //self.itemType = 1;
    [self initTableView];
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
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"ring-icon"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(notificationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UITableView DataSource Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //here set cell height according to itemtype
    #define TEXT_HEIGHT 170
    #define PHOTO_HEIGHT 380
    #define VEDIO_HEIGHT 380
    #define AUDIO_HEIGHT 250
    
    self.itemData = self.itemListData[indexPath.row];
    switch (self.itemType) {
        case 1:
        {
            return PHOTO_HEIGHT;
            break;
        }
        case 2:
        {
            return AUDIO_HEIGHT;
            break;
        }
        case 3:
        {
            return VEDIO_HEIGHT;
            break;
        }
        default:
            return TEXT_HEIGHT;
            break;
    }

    return TEXT_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //custom tableview cell - card style
    static NSString *cellIdentifier = @"itemcell";
    YNCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //TODO figure out what's the cellitemtype according to data
    switch (self.itemType) {
        case 1:
        {
            if (cell == nil) {
                cell = [[YNCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:PictureType];
            }
            //here use static test data to bind
            //TODO use the real data
            cell.avatarImageView.image = [UIImage imageNamed:@"default"];
            
            cell.usernameLabel.text = @"Nicholas Xue";
            cell.timeLabel.text = @"21小时前";
            cell.itemTypeIconView.image = [UIImage imageNamed:@"photo-icon"];
            cell.itemContentLabel.text = @"It is important to define pewPewSound as an iVar or property, and not as a local variable so that you can dispose of it later in dealloc. It is declared as a SystemSoundID.";
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, CGRectGetHeight(cell.attachPhotoContainerView.frame))];
            
            NSLog(@"%f", CGRectGetWidth(cell.attachPhotoContainerView.frame));
            NSLog(@"%f", CGRectGetHeight(cell.attachPhotoContainerView.frame));
            
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            photoView.image = [UIImage imageNamed:@"test"];
            [cell.attachPhotoContainerView addSubview:photoView];
            
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like-icon"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = @"12";
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment-icon"] forState:UIControlStateNormal];
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = @"231";
            
            [cell.shareButton setBackgroundImage:[UIImage imageNamed:@"share-icon"] forState:UIControlStateNormal];
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
            cell.timeLabel.text = @"21小时前";
            cell.itemTypeIconView.image = [UIImage imageNamed:@"photo-icon"];
            cell.itemContentLabel.text = @"It is important to define pewPewSound as an iVar or property, and not as a local variable so that you can dispose of it later in dealloc. It is declared as a SystemSoundID.";
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like-icon"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = @"12";
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment-icon"] forState:UIControlStateNormal];
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = @"231";
            
            [cell.shareButton setBackgroundImage:[UIImage imageNamed:@"share-icon"] forState:UIControlStateNormal];
            [cell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            return cell;
        }
        default:
        {
            if (cell == nil) {
                cell = [[YNCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier CellItemType:TextType];
            }
            cell.avatarImageView.image = [UIImage imageNamed:@"default"];
            cell.usernameLabel.text = @"Nicholas Xue";
            cell.timeLabel.text = @"21小时前";
            cell.itemTypeIconView.image = [UIImage imageNamed:@"photo-icon"];
            cell.itemContentLabel.text = @"It is important to define pewPewSound as an iVar or property, and not as a local variable so that you can dispose of it later in dealloc. It is declared as a SystemSoundID.";
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like-icon"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.likeCountLabel.text = @"12";
            
            [cell.commentButton setBackgroundImage:[UIImage imageNamed:@"comment-icon"] forState:UIControlStateNormal];
            [cell.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentCountLabel.text = @"231";
            
            [cell.shareButton setBackgroundImage:[UIImage imageNamed:@"share-icon"] forState:UIControlStateNormal];
            [cell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            break;
        }
    }
}


-(void)initTableView
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44) style:UITableViewStylePlain];
    self.contentTableView.backgroundColor= [UIColor clearColor];
    self.contentTableView.dataSource = self;
    self.contentTableView.delegate = self;
    self.contentTableView.separatorColor = [UIColor flatWhiteColor];
    [self.view addSubview:self.contentTableView];
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
