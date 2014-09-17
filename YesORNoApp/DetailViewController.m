//
//  DetailViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DetailViewController.h"
#import "chameleon.h"
#import "CommentTableViewCell.h"
#import "DateFormatter.h"
#import <AVOSCloud/AVOSCloud.h>
#import <POP/POP.h>

@interface DetailViewController ()

@property (nonatomic, strong)UITableView *detailTableView;


@property (nonatomic)NSInteger type;

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UILabel *likeCount;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UIButton *addCommentButton;

@property (nonatomic, strong)NSArray *commentList;
@property (nonatomic) AVUser *currentUser;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = [[_post.dictionaryForObject objectForKey:@"type"] integerValue];
    self.currentUser = [AVUser currentUser];
//    self.commentList = [_itemInfo objectForKey:@"comments"];
    
    [self initDetailTableView];
    [self initAvatarImageView];
    [self initNameLabel];
    [self initTimeLabel];
    [self initContentLabel];
    
    self.topView.frame = CGRectMake(0, 0, 320, self.likeButton.frame.origin.y + self.likeButton.frame.size.height+30);
    self.topView.backgroundColor = [UIColor flatWhiteColor];
    self.detailTableView.tableHeaderView = self.topView;
    [self.view addSubview:self.detailTableView];
}

- (void)initDetailTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
    self.detailTableView.separatorColor = [UIColor flatWhiteColor];
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)initAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60, 60)];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.height / 2;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.borderWidth = 2;
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.image = [UIImage imageNamed:[_author objectForKey:@"avatar"]];
    [self.topView addSubview:avatarImageView];
    
}

- (void)initNameLabel
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 13, 230, 21)];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    nameLabel.textColor = [UIColor flatNavyBlueColorDark];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [_author objectForKey:@"username"];
    
    [self.topView addSubview:nameLabel];
    
}

- (void)initTimeLabel
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 37, 230, 21)];
    timeLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    timeLabel.textColor = [UIColor flatNavyBlueColorDark];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = [DateFormatter friendlyDate:_post.createdAt];
    [self.topView addSubview:timeLabel];
}

-(void)initContentLabel
{
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 76, 304, 1000)];
    contentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor flatNavyBlueColorDark];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = [_post.dictionaryForObject objectForKey:@"content"];
    [contentLabel sizeToFit];
    [self.topView addSubview:contentLabel];
    
    switch (self.type) {
        case 0:
        {
           self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(8, contentLabel.frame.origin.y + contentLabel.frame.size.height + 15, 14, 13)];

            self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(34, contentLabel.frame.origin.y + contentLabel.frame.size.height + 10, 34, 20)];

            
            self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(110, contentLabel.frame.origin.y + contentLabel.frame.size.height + 15, 14, 12)];

            
            self.addCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(240, contentLabel.frame.origin.y + contentLabel.frame.size.height + 10, 70, 30)];
            
            [self initBottomControls];
            
            break;
        }
        case 1:
        {
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(8, contentLabel.frame.origin.y + contentLabel.frame.size.height + 15, 304, 160)];
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
            photoView.backgroundColor = [UIColor clearColor];
            
            NSDictionary *imageFileInfo = [_post.dictionaryForObject objectForKey:@"attachphoto"];
            NSURL *imageUrl = [NSURL URLWithString:[imageFileInfo objectForKey:@"url"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            photoView.image = [UIImage imageWithData:imageData];
            
            [self.topView addSubview:photoView];
            
            self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(8, photoView.frame.origin.y + photoView.frame.size.height + 15, 14, 13)];
            
            self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(34, photoView.frame.origin.y + photoView.frame.size.height + 10, 34, 20)];
            
            
            self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(110, photoView.frame.origin.y + photoView.frame.size.height + 15, 14, 12)];
            
            
            self.addCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(240, photoView.frame.origin.y + photoView.frame.size.height + 10, 70, 30)];
            
            [self initBottomControls];
            
            break;
        }
    }
    
}

- (void)initBottomControls
{
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    NSArray *likeusersId = [_post.dictionaryForObject objectForKey:@"likeusersid"];
    if ([likeusersId containsObject:self.currentUser.objectId]) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
    }
    [self.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.likeButton];
    
    self.likeCount.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.likeCount.textColor = [UIColor flatNavyBlueColorDark];
    self.likeCount.backgroundColor = [UIColor clearColor];
    self.likeCount.text = [NSString stringWithFormat:@"%@", [_post.dictionaryForObject objectForKey:@"likecount"]];
    [self.topView addSubview:self.likeCount];
    
    [self.shareButton setTitle:@"" forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share2-icon"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.shareButton];
    
    self.addCommentButton.backgroundColor = [UIColor flatRedColor];
    [self.addCommentButton setTitle:@"+comment" forState:UIControlStateNormal];
    self.addCommentButton.layer.cornerRadius = 4;
    self.addCommentButton.layer.masksToBounds = YES;
    self.addCommentButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    [self.addCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.addCommentButton addTarget:self action:@selector(addCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.addCommentButton];
}




#pragma mark - UITableView datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentcell";
    NSDictionary *commentInfo = self.commentList[indexPath.row];
    NSDictionary *author = [commentInfo objectForKey:@"author"];
//    NSDictionary *touser = [commentInfo objectForKey:@"touser"];
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.avatarImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [author objectForKey:@"avatar"]]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", [author objectForKey:@"name"]];
    cell.contentLabel.frame = CGRectMake(56, 37, 250, 1000);
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", [commentInfo objectForKey:@"content"]];
    [cell.contentLabel sizeToFit];
    
    cell.timeIconview.frame = CGRectMake(56, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + 4, 14, 14);
    cell.timeLabel.frame = CGRectMake(78, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height+2, 64, 21);
    cell.replyButton.frame = CGRectMake(150, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + 4, 14, 12);
    cell.replyLabel.frame = CGRectMake(172, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height+2, 64, 21);
    cell.timeLabel.text = @"4分钟前";
    [cell.replyButton addTarget:self action:@selector(replyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //TODO now fake data
    return  cell;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commentInfo = self.commentList[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@", [commentInfo objectForKey:@"content"]];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:12]} context:nil];
    return rect.size.height + 68;
}


-(void)likeButtonPressed:(UIButton *)sender
{
    int likecount = [[_post.dictionaryForObject objectForKey:@"likecount"] intValue];
    NSMutableArray *likeUsersId = [_post.dictionaryForObject objectForKey:@"likeusersid"];
    if (likeUsersId) {
        if ([likeUsersId containsObject:self.currentUser.objectId]) {
            likecount = likecount - 1;
            [_post removeObject:self.currentUser.objectId forKey:@"likeusersid"];
            [sender setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            
        } else {
            likecount = likecount + 1;
            [_post addObject:self.currentUser.objectId forKey:@"likeusersid"];
            [sender setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
        }
    } else {
        likecount = likecount + 1;
        [_post addObject:self.currentUser.objectId forKey:@"likeusersid"];
        [sender setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
    }
    self.likeCount.text = [NSString stringWithFormat:@"%d", likecount];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.6f, 0.6f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 20;
    [sender.layer pop_addAnimation:scaleAnimation forKey:@"scaleanimation"];
    [_post setObject:[NSNumber numberWithInt:likecount] forKey:@"likecount"];
    [_post saveInBackground];
}

- (void)shareButtonPressed:(id)sender
{
    
}

- (void)addCommentButtonPressed:(id)sender
{
    
}

 - (void)replyButtonPressed:(id)sender
{
                                      
}
@end
