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
#import "VBFPopFlatButton.h"
#import <POP/POP.h>
#import "MONActivityIndicatorView.h"
#import "Validator.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LoginViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *forgetPassButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) MONActivityIndicatorView *indicatorView;
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
    [self addErrorLabel];
    [self addIndicatorView];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    [self registerForKeyboardNotifications];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.usernameField becomeFirstResponder];
}


- (void)addIndicatorView
{
    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.center = CGPointMake(self.view.center.x -30, 80);
    self.indicatorView.delegate = self;
    [self.view addSubview:self.indicatorView];
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
        self.view.frame = CGRectMake(self.view.frame.origin.x, 60, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    return YES;
}


-(void)addErrorLabel
{
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.errorLabel.textColor = [UIColor flatRedColor];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.text = @"No Errors!..........................................";
    [self.view insertSubview:self.errorLabel belowSubview:self.loginButton];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.loginButton
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.loginButton
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
    
    
    
    self.errorLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.0f);
}

- (void)addUsernameTextField
{
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 44)];
    self.usernameField.textColor = [UIColor flatNavyBlueColorDark];
    self.usernameField.placeholder = @"Username";
    self.usernameField.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
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
    self.passwordField.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
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
    self.forgetPassButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    [self.forgetPassButton addTarget:self action:@selector(forgetPassButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPassButton];
}

- (void)addLoginButton
{
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 158, 230, 44)];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
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

- (void)loginButtonPressed:(UIButton *)sender
{
    //ToDo check login data
    //Now no check, directly to app index
    [self hideLabel];
    [self.indicatorView startAnimating];
    sender.userInteractionEnabled = NO;
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indicatorView stopAnimating];
        
        [AVUser logInWithUsernameInBackground:[self.usernameField.text stringByTrimmingCharactersInSet:whiteSpace] password:[self.passwordField.text stringByTrimmingCharactersInSet:whiteSpace] block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[AppMainViewController alloc] init]];
                LeftMenuViewController *leftMenuController = [[LeftMenuViewController alloc] init];
                
                RESideMenu *sideMenuController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuController rightMenuViewController:nil];
                sideMenuController.backgroundImage = [UIImage imageNamed:@"MenuBackground"];
                sideMenuController.menuPreferredStatusBarStyle = 1;
                sideMenuController.contentViewShadowColor = [UIColor flatNavyBlueColorDark];
                sideMenuController.contentViewShadowOpacity = 0.9;
                sideMenuController.contentViewShadowRadius = 8;
                sideMenuController.contentViewShadowEnabled = YES;
                sideMenuController.contentViewShadowOffset = CGSizeMake(0, 0);
                [self presentViewController:sideMenuController animated:YES completion:NULL];
            } else {
                if (error != nil) {
                    self.errorLabel.text = [error.userInfo objectForKey:@"error"];
                    [self shakeButton];
                    [self showErrorLabel];
                    return;
                }
            }
        }];
    });
    

    
}

- (void)shakeButton
{
    POPSpringAnimation *shakeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shakeAnimation.velocity = @2000;
    shakeAnimation.springBounciness = 20;
    [shakeAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished){
        self.loginButton.userInteractionEnabled = YES;
    }];
    [self.loginButton.layer pop_addAnimation:shakeAnimation forKey:@"shake-it"];
}

-(void)showErrorLabel
{
    self.errorLabel.layer.opacity = 1.0f;
    
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.loginButton.layer.position.y + self.loginButton.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"labelPosition"];
}

- (void)hideLabel
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.loginButton.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

#pragma mark - MONActivityIndicatorViewDelegate
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    return [UIColor flatPurpleColor];
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
