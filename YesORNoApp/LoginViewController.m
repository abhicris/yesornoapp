//
//  LoginViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "LoginViewController.h"
#import "Chameleon.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "ForgetPassViewController.h"
#import "AppMainViewController.h"
#import "LeftMenuViewController.h"
#import "RESideMenu/RESideMenu.h"

@interface LoginViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *forgetPassButton;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 5.f;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUsernameTextField];
    [self addPasswordTextField];
    [self addForgetPassButton];
    [self addLoginButton];
}



- (void)addUsernameTextField
{
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 44)];
    self.usernameField.textColor = [UIColor flatNavyBlueColorDark];
    self.usernameField.placeholder = @"Username";
    self.usernameField.font = [UIFont fontWithName:@"Avenir" size:14];
    self.usernameField.backgroundColor = [UIColor flatWhiteColor];
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    self.usernameField.layer.borderWidth = 0;
    self.usernameField.layer.cornerRadius = 4;
    [self.view addSubview:self.usernameField];
}

- (void)addPasswordTextField
{
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, 230, 44)];
    self.passwordField.textColor = [UIColor flatNavyBlueColorDark];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:@"Avenir" size:14];
    self.passwordField.backgroundColor = [UIColor flatWhiteColor];
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.layer.borderWidth = 0;
    self.passwordField.layer.cornerRadius = 4;
    [self.view addSubview:self.passwordField];
}

- (void)addForgetPassButton
{
    self.forgetPassButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 128, 100, 20)];
    [self.forgetPassButton setTitle:@"Forget Password?" forState:UIControlStateNormal];
    [self.forgetPassButton setTitleColor:[UIColor flatMintColor] forState:UIControlStateNormal];
    self.forgetPassButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    [self.forgetPassButton addTarget:self action:@selector(forgetPassButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPassButton];
}

- (void)addLoginButton
{
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 158, 230, 44)];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    self.loginButton.layer.borderWidth = 0;
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.backgroundColor = [UIColor flatMintColor];
    [self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
}


-(void)forgetPassButtonPressed:(id)sender
{
    ForgetPassViewController *forgetpassViewController = [ForgetPassViewController new];
    forgetpassViewController.transitioningDelegate = self;
    forgetpassViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:forgetpassViewController animated:YES completion:NULL];
}

- (void)loginButtonPressed:(id)sender
{
    //ToDo check login data
    //Now no check, directly to app index
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[AppMainViewController alloc] init]];
    LeftMenuViewController *leftMenuController = [[LeftMenuViewController alloc] init];
    
    RESideMenu *sideMenuController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuController rightMenuViewController:nil];
    sideMenuController.backgroundImage = [UIImage imageNamed:@"MenuBackground"];
    sideMenuController.menuPreferredStatusBarStyle = 1;
    //sideMenuController.delegate = self;
    sideMenuController.contentViewShadowColor = [UIColor flatNavyBlueColorDark];
    sideMenuController.contentViewShadowOpacity = 0.9;
    sideMenuController.contentViewShadowRadius = 8;
    sideMenuController.contentViewShadowEnabled = YES;
    sideMenuController.contentViewShadowOffset = CGSizeMake(0, 0);
    [self presentViewController:sideMenuController animated:YES completion:NULL];
    
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

@end
