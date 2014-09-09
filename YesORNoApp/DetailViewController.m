//
//  DetailViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DetailViewController.h"
#import "chameleon.h"


@interface DetailViewController ()

@property (nonatomic, strong)UITableView *detailTableView;


@property (nonatomic)NSInteger type;


@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UILabel *likeCount;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UIButton *addCommentButton;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = [[_itemInfo objectForKey:@"type"] integerValue];
    
    
    
    [self initDetailTableView];
    [self initAvatarImageView];
    [self initNameLabel];
    [self initTimeLabel];
    [self initContentLabel];
    
    
    [self.view addSubview:self.detailTableView];
}

- (void)initDetailTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    
}


-(void)initAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60, 60)];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.height / 2;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.borderWidth = 2;
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.image = [UIImage imageNamed:[_authorInfo objectForKey:@"avatar"]];
    [self.detailTableView.tableHeaderView addSubview:avatarImageView];
    
}

- (void)initNameLabel
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 13, 230, 21)];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    nameLabel.textColor = [UIColor flatNavyBlueColorDark];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [_authorInfo objectForKey:@"name"];
    
    [self.detailTableView.tableHeaderView addSubview:nameLabel];
    
}

- (void)initTimeLabel
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 37, 230, 21)];
    timeLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    timeLabel.textColor = [UIColor flatNavyBlueColorDark];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = @"6小时前";
    [self.detailTableView.tableHeaderView addSubview:timeLabel];
}

-(void)initContentLabel
{
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 76, 304, 1000)];
    contentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor flatNavyBlueColorDark];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = [_itemInfo objectForKey:@"content"];
    [contentLabel sizeToFit];
    [self.detailTableView.tableHeaderView addSubview:contentLabel];
    
    switch (self.type) {
        case 0:
        {
           self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(8, contentLabel.frame.origin.y + contentLabel.frame.size.height + 15, 14, 13)];

            self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(30, contentLabel.frame.origin.y + contentLabel.frame.size.height + 10, 14, 12)];

            
            self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(72, contentLabel.frame.origin.y + contentLabel.frame.size.height + 10, 14, 12)];

            
            self.addCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(252, contentLabel.frame.origin.y + contentLabel.frame.size.height + 10, 60, 20)];
            
            [self initBottomControls];

            break;
        }
        case 1:
        {
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(8, contentLabel.frame.origin.y + contentLabel.frame.size.height + 15, 304, 160)];
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.backgroundColor = [UIColor clearColor];
            photoView.image = [UIImage imageNamed:[_itemInfo objectForKey:@"attachurl"]];
            [self.detailTableView.tableHeaderView addSubview:photoView];
            
            self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(8, photoView.frame.origin.y + photoView.frame.size.height + 15, 14, 13)];
            
            self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(30, photoView.frame.origin.y + photoView.frame.size.height + 10, 14, 12)];
            
            
            self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(72, photoView.frame.origin.y + photoView.frame.size.height + 10, 14, 12)];
            
            
            self.addCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(252, photoView.frame.origin.y + photoView.frame.size.height + 10, 60, 20)];
            
            [self initBottomControls];
            
            break;
        }
    }
    
}

- (void)initBottomControls
{
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
    [self.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailTableView.tableHeaderView addSubview:self.likeButton];
    
    self.likeCount.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.likeCount.textColor = [UIColor flatNavyBlueColorDark];
    self.likeCount.backgroundColor = [UIColor clearColor];
    self.likeCount.text = [_itemInfo objectForKey:@"likecount"];
    [self.detailTableView.tableHeaderView addSubview:self.likeCount];
    
    [self.shareButton setTitle:@"" forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share2-icon"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailTableView.tableHeaderView addSubview:self.shareButton];
    
    self.addCommentButton.backgroundColor = [UIColor flatRedColor];
    [self.addCommentButton setTitle:@"+comment" forState:UIControlStateNormal];
    self.addCommentButton.layer.cornerRadius = 4;
    self.addCommentButton.layer.masksToBounds = YES;
    self.addCommentButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    [self.addCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.addCommentButton addTarget:self action:@selector(addCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailTableView.tableHeaderView addSubview:self.addCommentButton];
}



-(void)likeButtonPressed:(id)sender
{
    
}

- (void)shareButtonPressed:(id)sender
{
    
}

- (void)addCommentButtonPressed:(id)sender
{
    
}

@end
