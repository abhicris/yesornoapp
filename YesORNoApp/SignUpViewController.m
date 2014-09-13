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
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
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
    
    self.usernameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    [self registerForKeyboardNotifications];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.usernameField becomeFirstResponder];
}

#pragma mark - UITextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.usernameField) {
        self.usernameField.text = textField.text;
    }
    if (textField == self.emailField) {
        self.emailField.text = textField.text;
    }
    if (self.passwordField == textField) {
        self.passwordField.text = textField.text;
    }
    [textField resignFirstResponder];
}

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

- (void)addEmailField
{
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, 230, 44)];
    self.emailField.textColor = [UIColor flatNavyBlueColorDark];
    self.emailField.placeholder = @"Email Address";
    self.emailField.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    self.emailField.backgroundColor = [UIColor flatWhiteColor];
    self.emailField.textAlignment = NSTextAlignmentCenter;
    self.emailField.layer.borderWidth = 0;
    self.emailField.layer.cornerRadius = 4;
    [self.view addSubview:self.emailField];
}

- (void)addPasswordTextField
{
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 118, 230, 44)];
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
    [self textFieldDidEndEditing:self.usernameField];
    [self textFieldDidEndEditing:self.emailField];
    [self textFieldDidEndEditing:self.passwordField];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    [self hideLabel];
    [self.indicatorView startAnimating];
    sender.userInteractionEnabled = NO;
    //add some validation to textfiled texts
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indicatorView stopAnimating];
        if(![Validator lengthShouldFit:[self.usernameField.text stringByTrimmingCharactersInSet:whitespace] length:6]) {
            self.errorLabel.text = @"Username's length at least 6!";
            [self shakeButton];
            [self showErrorLabel];
            return;
        } else if (![Validator emailValidate:[self.emailField.text stringByTrimmingCharactersInSet:whitespace]]) {
            self.errorLabel.text = @"Sorry, not correct email address!";
            [self shakeButton];
            [self showErrorLabel];
            return;
        } else if (![Validator lengthShouldFit:[self.passwordField.text stringByTrimmingCharactersInSet:whitespace] length:6]) {
            self.errorLabel.text = @"Password's length at least 6";
            [self shakeButton];
            [self showErrorLabel];
            return;
        } else {
            //sign up new user based on avos cloud
            AVUser *user = [AVUser user];
            user.username = [self.usernameField.text stringByTrimmingCharactersInSet:whitespace];
            user.password = [self.passwordField.text stringByTrimmingCharactersInSet:whitespace];
            user.email = [self.emailField.text stringByTrimmingCharactersInSet:whitespace];
            
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
                    self.errorLabel.text = [error.userInfo objectForKey:@"error"];
                    [self shakeButton];
                    [self showErrorLabel];
                    return;
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
