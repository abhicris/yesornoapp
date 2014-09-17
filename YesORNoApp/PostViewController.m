//
//  PostViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "PostViewController.h"
#import "chameleon.h"
#import "AtListViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <POP/POP.h>

@interface PostViewController ()
@property (nonatomic, strong) AVUser *currentUser;
@property (nonatomic, strong)UITextView *contentTextView;
@property (nonatomic) UILabel *placeHolderLabel;
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentUser = [AVUser currentUser];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [sendButton setTitle:@"" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send-icon"] forState:UIControlStateNormal];
    
    [sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    [self initAvatarImageView];
    [self initNameLabel];
    [self initTextView];
    [self initBottomView];
    [self addSecureButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.contentTextView becomeFirstResponder];
}

-(void)initAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 75, 40, 40)];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.height /2;
    avatarImageView.backgroundColor = [UIColor clearColor];
    avatarImageView.layer.masksToBounds = YES;
    
    //fake data
    avatarImageView.image = [UIImage imageNamed:[self.currentUser.dictionaryForObject objectForKey:@"avatar"]];
    
    
    
    [self.view addSubview:avatarImageView];
}

- (void)initNameLabel
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 75, 233, 21)];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    nameLabel.text = self.currentUser.username;
    nameLabel.textColor = [UIColor flatNavyBlueColorDark];
    nameLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:nameLabel];
}

- (void)addSecureButton
{
    UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 100, 20, 15)];
    toLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    toLabel.textColor = [UIColor flatNavyBlueColorDark];
    toLabel.text = @"To: ";
    [self.view addSubview:toLabel];
    UIButton *selectSecureButton = [[UIButton alloc] initWithFrame:CGRectMake(99, 94, 65, 27)];
    [selectSecureButton setTitle:@"Your circles" forState:UIControlStateNormal];
    [selectSecureButton setTitleColor:[UIColor flatBlueColor] forState:UIControlStateNormal];
    selectSecureButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    [selectSecureButton addTarget:self action:@selector(selectSecureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:selectSecureButton];
}

- (void)initTextView
{

    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 124, 320, 135)];
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName:[UIColor flatBlueColor]}];
    self.contentTextView.scrollEnabled = NO;
    self.contentTextView.backgroundColor = [UIColor flatWhiteColor];
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.contentTextView.textContainer.maximumNumberOfLines = 6;
    self.contentTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentTextView.textColor = [UIColor flatNavyBlueColorDark];
//    self.contentTextView.text = @"share what's new...";
    self.contentTextView.delegate = self;
    
    
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 150, 15)];
    self.placeHolderLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.placeHolderLabel.textColor = [UIColor flatWhiteColorDark];
    self.placeHolderLabel.text = @"share what's new...";
    
    [self.contentTextView addSubview:self.placeHolderLabel];
    [self.view addSubview:self.contentTextView];
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, 320, 50)];
    bottomView.backgroundColor = [UIColor flatWhiteColorDark];
    
    UIButton *addPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 18, 20, 18)];
    [addPhotoButton setTitle:@"" forState:UIControlStateNormal];
    [addPhotoButton setBackgroundImage:[UIImage imageNamed:@"post-photo"] forState:UIControlStateNormal];
    [addPhotoButton addTarget:self action:@selector(addPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addPhotoButton];
    
    UIButton *addAtButton = [[UIButton alloc] initWithFrame:CGRectMake(84, 14, 23, 23)];
    [addAtButton setTitle:@"@" forState:UIControlStateNormal];
    [addAtButton setTitleColor:[UIColor flatNavyBlueColorDark] forState:UIControlStateNormal];
    [addAtButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:23]];
    [addAtButton addTarget:self action:@selector(addAtButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addAtButton];
    
    UIButton *addAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(153, 18, 14, 20)];
    [addAudioButton setTitle:@"" forState:UIControlStateNormal];
    [addAudioButton setBackgroundImage:[UIImage imageNamed:@"post-audio"] forState:UIControlStateNormal];
    [addAudioButton addTarget:self action:@selector(addAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addAudioButton];
    
    UIButton *addVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(213, 18, 20, 18)];
    [addVideoButton setTitle:@"" forState:UIControlStateNormal];
    [addVideoButton setBackgroundImage:[UIImage imageNamed:@"post-video"] forState:UIControlStateNormal];
    [addVideoButton addTarget:self action:@selector(addVideoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addVideoButton];
    
    UIButton *addLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(281, 18, 15, 20)];
    [addLocationButton setTitle:@"" forState:UIControlStateNormal];
    [addLocationButton setBackgroundImage:[UIImage imageNamed:@"post-location"] forState:UIControlStateNormal];
    [addLocationButton addTarget:self action:@selector(addLocationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addLocationButton];
    
    [self.view addSubview:bottomView];
}



#pragma  mark - UITextView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView hasText]) {
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
    }
}

- (void)sendButtonPressed:(UIButton *)sender
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    [sender.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimate"];
    
    NSMutableDictionary *master = [NSMutableDictionary dictionary];
    [master setObject:self.currentUser.objectId forKey:@"objectId"];
    [master setObject:self.currentUser.username forKey:@"username"];
    [master setObject:[self.currentUser.dictionaryForObject objectForKey:@"avatar"] forKey:@"avatar"];
    
    NSMutableArray *atUsers = [[NSMutableArray alloc] init];
    [atUsers addObject:[NSDictionary dictionaryWithDictionary:master]];
    AVObject *postObject = [AVObject objectWithClassName:@"Question"];
    [postObject setObject:_contentTextView.text forKey:@"content"];
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"secure"];//0 : public 1:private 2: group   default -- 0
    [postObject setObject:[NSArray array] forKey:@"likeusersid"];
    

    
    
    [postObject setObject:[NSDictionary dictionaryWithDictionary:master] forKey:@"master"];
    [postObject setObject:[NSDictionary dictionaryWithDictionary:master] forKey:@"touser"];
    [postObject setObject:[NSArray arrayWithArray:atUsers] forKey:@"atusers"];
    [postObject setObject:[NSNumber numberWithInt:1] forKey:@"type"];// text  picture  audio  video
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"likecount"];
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"commentcount"];
    NSString *imageUrl = @"http://sdk.img.ly/img/img-1.jpg";
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [postObject setObject:imageFile forKey:@"attachphoto"];
            
            [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    
                }
            }];
        }
    } progressBlock:^(NSInteger percentDone) {
        NSLog(@"%ld", (long)percentDone);
    }];
}

- (void)selectSecureButtonPressed:(UIButton *)sender
{
    
}


- (void)addPhotoButtonPressed:(id)sender
{
    
}

-(void)addAtButtonPressed:(id)sender
{
    [self.navigationController pushViewController:[AtListViewController new] animated:YES];
}

- (void)addAudioButtonPressed:(id)sender
{
    
}

-(void)addVideoButtonPressed:(id)sender
{
    
}

-(void)addLocationButtonPressed:(id)sender
{
    
}
@end
