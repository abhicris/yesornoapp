//
//  PostViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "PostViewController.h"
#import "chameleon.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 124, 320, 128)];
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    _contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    [_contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName:[UIColor flatBlueColor]}];
    _contentTextView.scrollEnabled = NO;
    _contentTextView.backgroundColor = [UIColor flatWhiteColor];
    _contentTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    _contentTextView.textContainer.maximumNumberOfLines = 6;
    _contentTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.view addSubview:_contentTextView];
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, 320, 50)];
    bottomView.backgroundColor = [UIColor flatWhiteColor];
    
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

- (void)sendButtonPressed:(id)sender
{
    
}

- (void)addPhotoButtonPressed:(id)sender
{
    
}

-(void)addAtButtonPressed:(id)sender
{
    
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
