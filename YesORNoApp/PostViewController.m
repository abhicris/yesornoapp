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

@interface PostViewController ()
@property (nonatomic, strong) AVUser *currentUser;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_contentTextView becomeFirstResponder];
}

-(void)initAvatarImageView
{
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 75, 40, 40)];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.cornerRadius = _avatarImageView.layer.frame.size.height /2;
    _avatarImageView.backgroundColor = [UIColor clearColor];
    _avatarImageView.layer.masksToBounds = YES;
    
    //fake data
    _avatarImageView.image = [UIImage imageNamed:@"default"];
    
    
    
    [self.view addSubview:_avatarImageView];
}

- (void)initNameLabel
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 84, 233, 21)];
    _nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    _nameLabel.text = @"Nicholas Xue";
    _nameLabel.textColor = [UIColor flatNavyBlueColorDark];
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_nameLabel];
}

- (void)initTextView
{
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 124, 320, 135)];
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    _contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    [_contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName:[UIColor flatBlueColor]}];
    _contentTextView.scrollEnabled = NO;
    _contentTextView.backgroundColor = [UIColor flatWhiteColor];
    _contentTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    _contentTextView.textContainer.maximumNumberOfLines = 6;
    _contentTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentTextView.textColor = [UIColor flatWhiteColorDark];
    _contentTextView.text = @"share what's new...";
    _contentTextView.delegate = self;
    [self.view addSubview:_contentTextView];
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, 320, 50)];
    bottomView.backgroundColor = [UIColor flatWhiteColorDark];
    
    _addPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 18, 20, 18)];
    [_addPhotoButton setTitle:@"" forState:UIControlStateNormal];
    [_addPhotoButton setBackgroundImage:[UIImage imageNamed:@"post-photo"] forState:UIControlStateNormal];
    [_addPhotoButton addTarget:self action:@selector(addPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_addPhotoButton];
    
    _addAtButton = [[UIButton alloc] initWithFrame:CGRectMake(84, 14, 23, 23)];
    [_addAtButton setTitle:@"@" forState:UIControlStateNormal];
    [_addAtButton setTitleColor:[UIColor flatNavyBlueColorDark] forState:UIControlStateNormal];
    [_addAtButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:23]];
    [_addPhotoButton addTarget:self action:@selector(addAtButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_addAtButton];
    
    _addAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(153, 18, 14, 20)];
    [_addAudioButton setTitle:@"" forState:UIControlStateNormal];
    [_addAudioButton setBackgroundImage:[UIImage imageNamed:@"post-audio"] forState:UIControlStateNormal];
    [_addAudioButton addTarget:self action:@selector(addAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_addAudioButton];
    
    _addVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(213, 18, 20, 18)];
    [_addVideoButton setTitle:@"" forState:UIControlStateNormal];
    [_addVideoButton setBackgroundImage:[UIImage imageNamed:@"post-video"] forState:UIControlStateNormal];
    [_addVideoButton addTarget:self action:@selector(addVideoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_addVideoButton];
    
    _addLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(281, 18, 15, 20)];
    [_addLocationButton setTitle:@"" forState:UIControlStateNormal];
    [_addLocationButton setBackgroundImage:[UIImage imageNamed:@"post-location"] forState:UIControlStateNormal];
    [_addLocationButton addTarget:self action:@selector(addLocationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_addLocationButton];
    
    [self.view addSubview:bottomView];
}



#pragma  mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor flatNavyBlueColorDark];
    if ([textView.text isEqualToString:@"share what's new..."]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [UIColor flatWhiteColorDark];
        textView.text = @"share what's new...";
    }
}



- (void)sendButtonPressed:(id)sender
{
    NSMutableArray *atUsers = [[NSMutableArray alloc] init];
    [atUsers addObject:self.currentUser.dictionaryForObject];
    AVObject *postObject = [AVObject objectWithClassName:@"Question"];
    [postObject setObject:_contentTextView.text forKey:@"content"];
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"secure"];//0 : public 1:private 2: group   default -- 0
    [postObject setObject:[self.currentUser dictionaryForObject] forKey:@"master"];
    [postObject setObject:[self.currentUser dictionaryForObject] forKey:@"touser"];
    [postObject setObject:[NSArray arrayWithArray:atUsers] forKey:@"atusers"];
    [postObject setObject:[NSNumber numberWithInt:1] forKey:@"type"];// text  picture  audio  video
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"likecount"];
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"commentcount"];
    NSString *imageUrl = @"https://avatars2.githubusercontent.com/u/3580943?v=2&s=460";
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
