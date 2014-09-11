//
//  SignUpViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "SignUpViewController.h"
#import "chameleon.h"
#import <AVOSCloud/AVOSCloud.h>
#import "VBFPopFlatButton.h"
#import "Validator.h"
#import <POP/POP.h>
#import "MONActivityIndicatorView.h"
#import "LeftMenuViewController.h"
#import "RESideMenu/RESideMenu.h"
#import "AppMainViewController.h"

@interface SignUpViewController ()

@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong)UILabel *errorLabel;
@property (nonatomic, strong)MONActivityIndicatorView *indicatorView;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 5.f;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addUsernameTextField];
    [self addEmailField];
    [self addPasswordTextField];
    [self addSignUpButton];
    [self addErrorLabel];
    [self addIndicatorView];
    
    _usernameField.delegate = self;
    _emailField.delegate = self;
    _passwordField.delegate = self;
    [self registerForKeyboardNotifications];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_usernameField becomeFirstResponder];
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    return YES;
}


-(void)addIndicatorView
{
    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.center = CGPointMake(self.view.center.x -30, 80);
    self.indicatorView.delegate = self;
    [self.view addSubview:self.indicatorView];
}


- (void)addUsernameTextField
{
    _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 44)];
    _usernameField.textColor = [UIColor flatNavyBlueColorDark];
    _usernameField.placeholder = @"Username";
    _usernameField.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    _usernameField.backgroundColor = [UIColor flatWhiteColor];
    _usernameField.textAlignment = NSTextAlignmentCenter;
    _usernameField.layer.borderWidth = 0;
    _usernameField.layer.cornerRadius = 4;
    [self.view addSubview:_usernameField];
}

- (void)addEmailField
{
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, 230, 44)];
    _emailField.textColor = [UIColor flatNavyBlueColorDark];
    _emailField.placeholder = @"Email Address";
    _emailField.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    _emailField.backgroundColor = [UIColor flatWhiteColor];
    _emailField.textAlignment = NSTextAlignmentCenter;
    _emailField.layer.borderWidth = 0;
    _emailField.layer.cornerRadius = 4;
    [self.view addSubview:_emailField];
}

- (void)addPasswordTextField
{
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 118, 230, 44)];
    _passwordField.textColor = [UIColor flatNavyBlueColorDark];
    _passwordField.placeholder = @"Password";
    _passwordField.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    _passwordField.backgroundColor = [UIColor flatWhiteColor];
    _passwordField.textAlignment = NSTextAlignmentCenter;
    _passwordField.secureTextEntry = YES;
    _passwordField.layer.borderWidth = 0;
    _passwordField.layer.cornerRadius = 4;
    [self.view addSubview:_passwordField];
}

- (void)addSignUpButton
{
    self.signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 172, 230, 44)];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    self.signUpButton.layer.borderWidth = 0;
    self.signUpButton.layer.cornerRadius = 5;
    self.signUpButton.backgroundColor = [UIColor flatMintColor];
    [self.signUpButton addTarget:self action:@selector(signUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
}

-(void)addErrorLabel
{
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    self.errorLabel.textColor = [UIColor flatRedColor];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.text = @"No Errors!..........................................";
    [self.view insertSubview:self.errorLabel belowSubview:self.signUpButton];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.signUpButton
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.signUpButton
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
    
    
    
    self.errorLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.0f);
}

- (void)signUpButtonPressed:(UIButton *)sender
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    [self hideLabel];
    [self.indicatorView startAnimating];
    sender.userInteractionEnabled = NO;
    //add some validation to textfiled texts
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indicatorView stopAnimating];
        __block NSString *errorString = @"";
        if(![Validator lengthShouldFit:[_usernameField.text stringByTrimmingCharactersInSet:whitespace] length:6]) {
            errorString = @"Username's length at least 6!";
        } else if (![Validator emailValidate:[_emailField.text stringByTrimmingCharactersInSet:whitespace]]) {
            errorString = @"Sorry, not correct email address!";
        } else if (![Validator lengthShouldFit:[_passwordField.text stringByTrimmingCharactersInSet:whitespace] length:6]) {
            errorString = @"Password's length at least 6";
        }
        if (![errorString isEqualToString:@""]) {
            self.errorLabel.text = errorString;
            [self shakeButton];
            [self showErrorLabel];
        } else {
            //sign up new user based on avos cloud
            AVUser *user = [AVUser user];
            user.username = [_usernameField.text stringByTrimmingCharactersInSet:whitespace];
            user.password = [_passwordField.text stringByTrimmingCharactersInSet:whitespace];
            user.email = [_emailField.text stringByTrimmingCharactersInSet:whitespace];
            [user signUpInBackgroundWithBlock:^(BOOL succeeed, NSError *error) {

                if (succeeed) {
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
                    NSLog(@"error=================: %@", error);
                    errorString = [NSString stringWithFormat:@"%@", error];
                    [self shakeButton];
                    [self showErrorLabel];
                }
            }];
        }
    });
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

- (void)shakeButton
{
    POPSpringAnimation *shakeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shakeAnimation.velocity = @2000;
    shakeAnimation.springBounciness = 20;
    [shakeAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished){
        self.signUpButton.userInteractionEnabled = YES;
    }];
    [self.signUpButton.layer pop_addAnimation:shakeAnimation forKey:@"shake-it"];
}

-(void)showErrorLabel
{
    self.errorLabel.layer.opacity = 1.0f;
    
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.signUpButton.layer.position.y + self.signUpButton.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"labelPosition"];
}

- (void)hideLabel
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.signUpButton.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}


#pragma mark - MONActivityIndicatorViewDelegate
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    return [UIColor flatPurpleColor];
}


@end
