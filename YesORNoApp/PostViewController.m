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
#import "KLCPopup.h"
#import <AFNetworking/AFNetworking.h>

@interface PostViewController ()
@property (nonatomic, strong) AVUser *currentUser;
@property (nonatomic, strong)UITextView *contentTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, weak) KLCPopup *popUp;
@property (nonatomic, strong) MONActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *sendingLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *dimmView;
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
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.contentTextView becomeFirstResponder];
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
        self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, keyboardFrameEnd.origin.y-self.bottomView.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, keyboardFrameEnd.origin.y-self.bottomView.frame.size.height-self.contentTextView.frame.origin.y);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, 518, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, 395);
    } completion:nil];
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

    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 124, 320, 395)];
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName:[UIColor flatBlueColor]}];
    self.contentTextView.scrollEnabled = YES;
    self.contentTextView.backgroundColor = [UIColor flatWhiteColor];
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.contentTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentTextView.textColor = [UIColor flatNavyBlueColorDark];
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
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 518, 320, 50)];
    self.bottomView.backgroundColor = [UIColor flatWhiteColorDark];
    
    UIButton *addPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 18, 20, 18)];
    [addPhotoButton setTitle:@"" forState:UIControlStateNormal];
    [addPhotoButton setBackgroundImage:[UIImage imageNamed:@"post-photo"] forState:UIControlStateNormal];
    [addPhotoButton addTarget:self action:@selector(addPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:addPhotoButton];
    
    UIButton *addAtButton = [[UIButton alloc] initWithFrame:CGRectMake(84, 14, 23, 23)];
    [addAtButton setTitle:@"@" forState:UIControlStateNormal];
    [addAtButton setTitleColor:[UIColor flatNavyBlueColorDark] forState:UIControlStateNormal];
    [addAtButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:23]];
    [addAtButton addTarget:self action:@selector(addAtButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:addAtButton];
    
    UIButton *addAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(153, 18, 14, 20)];
    [addAudioButton setTitle:@"" forState:UIControlStateNormal];
    [addAudioButton setBackgroundImage:[UIImage imageNamed:@"post-audio"] forState:UIControlStateNormal];
    [addAudioButton addTarget:self action:@selector(addAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:addAudioButton];
    
    UIButton *addVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(213, 18, 20, 18)];
    [addVideoButton setTitle:@"" forState:UIControlStateNormal];
    [addVideoButton setBackgroundImage:[UIImage imageNamed:@"post-video"] forState:UIControlStateNormal];
    [addVideoButton addTarget:self action:@selector(addVideoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:addVideoButton];
    
    UIButton *addLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(281, 18, 15, 20)];
    [addLocationButton setTitle:@"" forState:UIControlStateNormal];
    [addLocationButton setBackgroundImage:[UIImage imageNamed:@"post-location"] forState:UIControlStateNormal];
    [addLocationButton addTarget:self action:@selector(addLocationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:addLocationButton];
    
    [self.view addSubview:self.bottomView];
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


- (void)popUpSendProcess
{
    [self.contentTextView resignFirstResponder];
    self.dimmView = [[UIView alloc] initWithFrame:self.view.frame];
    self.dimmView.backgroundColor = [UIColor flatBlackColorDark];
    self.dimmView.layer.opacity = 0.0;

    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(90, 145, 140, 80)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowOpacity = 0.7f;
    self.sendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 49, 80, 15)];
    self.sendingLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.sendingLabel.text = [NSString stringWithFormat:@"sending..."];
    self.sendingLabel.textColor = [UIColor flatBlueColor];
    [self.contentView addSubview:self.sendingLabel];
    
    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.center = CGPointMake(70, 30);
    self.indicatorView.delegate = self;
    
    
    [self.contentView addSubview:self.indicatorView];
    [self.dimmView addSubview:self.contentView];
    
    [self.view addSubview:self.dimmView];
    [self.indicatorView startAnimating];
    POPBasicAnimation *opacityAnimate = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimate.toValue = @(0.7);
    [self.dimmView.layer pop_addAnimation:opacityAnimate forKey:@"opacityAnimate"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 18;
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    [self.contentView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimate"];

}


- (void)sendButtonPressed:(UIButton *)sender
{
    
    [self popUpSendProcess];
    NSMutableDictionary *master = [NSMutableDictionary dictionary];
    [master setObject:self.currentUser.objectId forKey:@"objectId"];
    [master setObject:self.currentUser.username forKey:@"username"];
    [master setObject:[self.currentUser.dictionaryForObject objectForKey:@"avatar"] forKey:@"avatar"];
    
    NSMutableArray *atUsers = [[NSMutableArray alloc] init];
    [atUsers addObject:[NSDictionary dictionaryWithDictionary:master]];
    AVObject *postObject = [AVObject objectWithClassName:@"Question"];
    [postObject setObject:self.contentTextView.text forKey:@"content"];
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"secure"];//0 : public 1:private 2: group   default -- 0
    [postObject setObject:[NSArray array] forKey:@"likeusersid"];
    [postObject setObject:[NSDictionary dictionaryWithDictionary:master] forKey:@"master"];
    [postObject setObject:self.currentUser forKey:@"author"];
    [postObject setObject:[NSDictionary dictionaryWithDictionary:master] forKey:@"touser"];
    [postObject setObject:[NSArray arrayWithArray:atUsers] forKey:@"atusers"];
    [postObject setObject:[NSNumber numberWithInt:1] forKey:@"type"];// text  picture  audio  video
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"likecount"];
    [postObject setObject:[NSNumber numberWithInt:0] forKey:@"commentcount"];
    NSString *imageUrlString = @"http://sdk.img.ly/img/img-123.jpg";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *dataTask = [session downloadTaskWithURL:[NSURL URLWithString:imageUrlString] completionHandler:^(NSURL *url, NSURLResponse *response, NSError *error) {
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [postObject setObject:imageFile forKey:@"attachphoto"];
                [postObject saveInBackground];
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self.indicatorView stopAnimating];
                    [self.dimmView removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } progressBlock:^(NSInteger percentDone) {
            NSLog(@"%@", [NSNumber numberWithInteger:percentDone]);
            self.sendingLabel.text = [NSString stringWithFormat:@"sending %@%%", [NSNumber numberWithInteger:percentDone]];
        }];
    }];
    [dataTask resume];
    
    
}

- (void)selectSecureButtonPressed:(id)sender
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

#pragma mark - MONActivityIndicatorViewDelegate
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    return [UIColor flatPurpleColor];
}
@end
