//
//  MainViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "MainViewController.h"
#import "Chameleon.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface MainViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *haveAccountTipLabel;
@property (nonatomic, strong) UILabel *bottomRightLabel;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatNavyBlueColorDark];
    
    [self initTitleLabel];
    [self initSubTitleLabel];
    [self initSignUpButton];
    [self initHaveAccountLabel];
    [self initLoginButton];
    [self initBottomRightLabel];
}

#pragma mark - initViews

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)initTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), 64)];
    self.titleLabel.text = @"Yes OR No?";
    self.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
}

- (void)initSubTitleLabel
{
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, CGRectGetWidth(self.view.bounds), 44)];
    self.subTitleLabel.text = @"Yo, ya have to be honest!";
    self.subTitleLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subTitleLabel];
}

- (void)initSignUpButton
{
    self.signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 200, 200, 44)];
    self.signUpButton.backgroundColor = [UIColor flatMintColorDark];
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpButton.layer.cornerRadius = 5;
    self.signUpButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    self.signUpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.signUpButton addTarget:self action:@selector(signUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
}

- (void)initHaveAccountLabel
{
    self.haveAccountTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 264, CGRectGetWidth(self.view.bounds), 44)];
    self.haveAccountTipLabel.text = @"Already have an account?";
    self.haveAccountTipLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    self.haveAccountTipLabel.backgroundColor = [UIColor clearColor];
    self.haveAccountTipLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.haveAccountTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.haveAccountTipLabel];
}

- (void)initLoginButton
{
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 318, 200, 44)];
    self.loginButton.backgroundColor = [UIColor clearColor];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 5;
    [[self.loginButton layer] setBorderWidth:1.0f];
    [[self.loginButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    self.loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
}

- (void)initBottomRightLabel
{
    self.bottomRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.view.frame.size.height - 74, CGRectGetWidth(self.view.bounds)-50, 44)];
    self.bottomRightLabel.text = @"This app was built by Nicholas, and all just for fun! Contact me on twitter - @Normal_Geek_Xue.";
    self.bottomRightLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    self.bottomRightLabel.backgroundColor = [UIColor clearColor];
    self.bottomRightLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.bottomRightLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomRightLabel.numberOfLines = 0;
    [self.view addSubview:self.bottomRightLabel];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}



- (void)signUpButtonPressed:(UIButton *)sender
{
    SignUpViewController *signupViewController = [SignUpViewController new];
    signupViewController.transitioningDelegate = self;
    signupViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:signupViewController
                       animated:YES
                     completion:NULL];
}
- (void)loginButtonPressed:(UIButton *)sender
{
    LoginViewController *loginViewController = [LoginViewController new];
    loginViewController.transitioningDelegate = self;
    loginViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:loginViewController
                                            animated:YES
                                          completion:NULL];
}
@end
