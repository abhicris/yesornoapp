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
#import <SDWebImage/UIImageView+WebCache.h>



#define ORDER_BY @"createdAt"


@interface DetailViewController ()

@property (nonatomic, strong)UITableView *detailTableView;


@property (nonatomic)NSInteger type;

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UILabel *likeCount;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UIButton *addCommentButton;
@property (nonatomic, strong)NSMutableArray *commentList;
@property (nonatomic) AVUser *currentUser;
@property (nonatomic) AVUser *author;

@property (nonatomic) AVUser *commentToUser;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *postCommentButton;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = [[_post.dictionaryForObject objectForKey:@"type"] integerValue];
    self.currentUser = [AVUser currentUser];
    self.commentList = [NSMutableArray array];
    self.author = [_post objectForKey:@"author"];
    
    [self initDetailTableView];
    [self initAvatarImageView];
    [self initNameLabel];
    [self initTimeLabel];
    [self initContentLabel];
    
    self.topView.frame = CGRectMake(0, 0, 320, self.likeButton.frame.origin.y + self.likeButton.frame.size.height+30);
    self.topView.backgroundColor = [UIColor whiteColor];
    self.detailTableView.tableHeaderView = self.topView;
    [self.view addSubview:self.detailTableView];
    
    [self addCommentView];
    [self registerForKeyboardNotifications];
    
    [self loadNewComments];
}


- (void)initDetailTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.view.frame.size.height - 40) style:UITableViewStylePlain];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
    self.detailTableView.separatorColor = [UIColor flatWhiteColor];
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.commentView.frame = CGRectMake(self.commentView.frame.origin.x, keyboardFrameEnd.origin.y-self.commentView.frame.size.height, self.commentView.frame.size.width, self.commentView.frame.size.height);
        
        self.detailTableView.frame = CGRectMake(self.detailTableView.frame.origin.x, self.detailTableView.frame.origin.y, self.detailTableView.frame.size.width, self.commentView.frame.origin.y);
        
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.commentView.frame = CGRectMake(self.commentView.frame.origin.x, 528, self.commentView.frame.size.width, self.commentView.frame.size.height);
        
        self.detailTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.view.frame.size.height - 40);
    } completion:nil];
}


-(void)loadNewComments
{
    AVQuery *commentsQuery = [AVQuery queryWithClassName:@"Comment"];
    [commentsQuery includeKey:@"author"];
    [commentsQuery includeKey:@"touser"];
    [commentsQuery whereKey:@"post" equalTo:_post];
    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (error == nil) {
            NSMutableArray *newComments = [NSMutableArray array];
            NSArray *commentIds = [self.commentList valueForKeyPath:@"objectId"];
            if (comments.count) {
                for (AVObject *comment in comments) {
                    if (![commentIds containsObject:comment.objectId]) {
                        [newComments addObject:comment];
                    }
                }
                long offset = self.commentList.count;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(offset, newComments.count)];
                [self.commentList insertObjects:newComments atIndexes:indexSet];
                [self.commentList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:ORDER_BY ascending:NO]]];
                
                [self.detailTableView reloadData];
            }
        } else {
            NSLog(@"Comment Query Error: %@", error);
        }
    }];
}


#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.text = @"";
    self.commentToUser = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)addCommentView
{
    self.commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 528, 320, 40)];
    self.commentView.backgroundColor = [UIColor flatWhiteColor];
    [self.view addSubview:self.commentView];
    
    self.commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 5, 264, 30)];
    self.commentTextField.delegate = self;
    [self.commentTextField setPlaceholder:@"Add comment"];
    self.commentTextField.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.commentTextField.textColor = [UIColor flatNavyBlueColorDark];
    self.commentTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.commentTextField.backgroundColor = [UIColor whiteColor];
    [self.commentView addSubview:self.commentTextField];
    
    self.postCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 11, 16, 16)];
    [self.postCommentButton setTitle:@"" forState:UIControlStateNormal];
    [self.postCommentButton setBackgroundImage:[UIImage imageNamed:@"send-icon"] forState:UIControlStateNormal];
    [self.postCommentButton addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:self.postCommentButton];
}

- (void)postCommentButtonPressed:(UIButton *)sender
{
    AVObject *comment = [AVObject objectWithClassName:@"Comment"];
    [comment setObject:_post forKey:@"post"];
    [comment setObject:self.currentUser forKey:@"author"];
    if (!self.commentToUser) {
        self.commentToUser = self.author;
    }
    [comment setObject:self.commentToUser forKey:@"touser"];
    [comment setObject:self.commentTextField.text forKey:@"content"];
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.commentTextField.text = @"";
            [self.commentTextField resignFirstResponder];
            [self loadNewComments];
        } else {
            NSLog(@"Post Comment Error: %@", error);
        }
    }];
    
}


-(void)initAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60, 60)];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.height / 2;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.borderWidth = 2;
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.image = [UIImage imageNamed:[self.author.dictionaryForObject objectForKey:@"avatar"]];
    [self.topView addSubview:avatarImageView];
    
}

- (void)initNameLabel
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 13, 230, 21)];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    nameLabel.textColor = [UIColor flatNavyBlueColorDark];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [self.author objectForKey:@"username"];
    
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
            NSDictionary *imageFileInfo = [_post.dictionaryForObject objectForKey:@"attachinfo"];
            NSURL *imageUrl = [NSURL URLWithString:[imageFileInfo objectForKey:@"url"]];
            

            
            __block UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(8, contentLabel.frame.origin.y + contentLabel.frame.size.height + 15, 304, 100)];
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.backgroundColor = [UIColor clearColor];
            
            
            [photoView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"test"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGImageRef imageRef = [image CGImage];
                CGFloat imageHeight = CGImageGetHeight(imageRef);
                CGFloat imageWith = CGImageGetWidth(imageRef);
                CGFloat ratio = imageWith / 304;
                CGFloat realHeight = imageHeight / ratio;
                CGRect frame = photoView.frame;
                frame.size = CGSizeMake(304, realHeight);
                photoView.frame = frame;
            }];
            
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
    AVQuery *likesQuery = [AVQuery queryWithClassName:@"PostLike"];
    [likesQuery whereKey:@"post" equalTo:_post];
    [likesQuery includeKey:@"author"];
    [likesQuery findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (error == nil) {
            if (likes.count) {
                NSArray *likeUsers = [likes valueForKeyPath:@"author"];
                if ([likeUsers containsObject:self.currentUser]) {
                    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
                } else {
                    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
                }
            } else {
                [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
            }
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    
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
    AVObject *commentInfo = self.commentList[indexPath.row];
    AVUser *author = [commentInfo objectForKey:@"author"];
    AVUser *touser = [commentInfo objectForKey:@"touser"];
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.avatarImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [author.dictionaryForObject objectForKey:@"avatar"]]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", author.username];
    cell.contentLabel.frame = CGRectMake(56, 37, 250, 1000);
    cell.contentLabel.text = [NSString stringWithFormat:@"reply to: %@ %@", touser.username, [commentInfo.dictionaryForObject objectForKey:@"content"]];
    [cell.contentLabel sizeToFit];
    
    cell.timeIconview.frame = CGRectMake(56, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + 4, 14, 14);
    cell.timeLabel.frame = CGRectMake(78, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height+2, 64, 21);
    cell.replyButton.frame = CGRectMake(150, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + 4, 14, 12);
    cell.replyLabel.frame = CGRectMake(172, cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height+2, 64, 21);
    cell.timeLabel.text = [DateFormatter friendlyDate:[commentInfo objectForKey:@"createdAt"]];
    [cell.replyButton addTarget:self action:@selector(replyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    __block int likecount = [[_post.dictionaryForObject objectForKey:@"likecount"] intValue];
    AVQuery *likeQuery = [AVQuery queryWithClassName:@"PostLike"];
    [likeQuery whereKey:@"post" equalTo:_post];
    [likeQuery includeKey:@"author"];
    
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (error == nil) {
            if (likes.count) {
                BOOL hasLiked = NO;
                for (AVObject *like in likes) {
                    AVUser *author = [like objectForKey:@"author"];
                    if (author.objectId != self.currentUser.objectId) {
                        continue;
                    } else {
                        likecount = likecount - 1;
                        [like deleteInBackground];
                        self.likeCount.text = [NSString stringWithFormat:@"%d", likecount];
                        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like2-icon"] forState:UIControlStateNormal];
                        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.6f, 0.6f)];
                        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
                        scaleAnimation.springBounciness = 20;
                        [self.likeButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleanimation"];
                        [_post setObject:[NSNumber numberWithInt:likecount] forKey:@"likecount"];
                        [_post saveInBackground];
                    }
                }
                if (!hasLiked) {
                    likecount = likecount + 1;
                    AVObject *like = [AVObject objectWithClassName:@"PostLike"];
                    [like setObject:_post forKey:@"post"];
                    [like setObject:self.currentUser forKey:@"author"];
                    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            self.likeCount.text = [NSString stringWithFormat:@"%d", likecount];
                            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
                            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                            scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.6f, 0.6f)];
                            scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
                            scaleAnimation.springBounciness = 20;
                            [self.likeButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleanimation"];
                            [_post setObject:[NSNumber numberWithInt:likecount] forKey:@"likecount"];
                            [_post saveInBackground];
                        }
                    }];
                    
                }
            } else {
                likecount = likecount + 1;
                AVObject *like = [AVObject objectWithClassName:@"PostLike"];
                [like setObject:_post forKey:@"post"];
                [like setObject:self.currentUser forKey:@"author"];
                [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        self.likeCount.text = [NSString stringWithFormat:@"%d", likecount];
                        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like-active-icon"] forState:UIControlStateNormal];
                        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.6f, 0.6f)];
                        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
                        scaleAnimation.springBounciness = 20;
                        [self.likeButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleanimation"];
                        [_post setObject:[NSNumber numberWithInt:likecount] forKey:@"likecount"];
                        [_post saveInBackground];
                    }
                }];
            }
        } else {
            NSLog(@"Like Query Error: %@", error);
        }
    }];

    
}

- (void)shareButtonPressed:(id)sender
{
    
}

- (void)addCommentButtonPressed:(id)sender
{
    
}

 - (void)replyButtonPressed:(UIButton *)sender
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[sender superview];
    NSIndexPath *indexPath = [self.detailTableView indexPathForCell:cell];
    AVObject *comment = self.commentList[indexPath.row];
    AVUser *author = [comment objectForKey:@"author"];
    self.commentToUser = author;
//    self.commentTextField.text = author.username;
    [self.commentTextField becomeFirstResponder];
}
@end
