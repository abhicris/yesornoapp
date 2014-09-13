//
//  ForgetPassViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "chameleon.h"
#import "LoginViewController.h"
#import "Validator.h"
#import <POP/POP.h>
#import <AVOSCloud/AVOSCloud.h>
#import "KLCPopup.h"



@interface ForgetPassViewController ()
@property (nonatomic, strong) UILabel *forgetTipLabel;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) MONActivityIndicatorView *indicatorView;
@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addForgetTipLabel];
    [self addEmailField];
    [self addCancelButton];
    [self addForgetButton];
    [self addErrorLabel];
    [self addIndicatorView];
    
    self.emailField.delegate = self;
    [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.emailField becomeFirstResponder];
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


-(void)addIndicatorView
{
    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.center = CGPointMake(self.view.center.x -30, 80);
    self.indicatorView.delegate = self;
    [self.view addSubview:self.indicatorView];
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
    [self.view insertSubview:self.errorLabel belowSubview:self.forgetButton];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.forgetButton
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.forgetButton
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
    
    
    
    self.errorLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.0f);
}

- (void)addForgetTipLabel
{
    self.forgetTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 210, 44)];
    self.forgetTipLabel.text = @"please enter your email address, when you signed up used.";
    self.forgetTipLabel.textColor = [UIColor flatRedColor];
    self.forgetTipLabel.textAlignment = NSTextAlignmentCenter;
    self.forgetTipLabel.numberOfLines = 0;
    self.forgetTipLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    [self.view addSubview:self.forgetTipLabel];
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

- (void)addCancelButton
{
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 190, 100, 20)];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor flatMintColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
}

- (void)addForgetButton
{
    self.forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 128, 230, 44)];
    [self.forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.forgetButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    self.forgetButton.layer.borderWidth = 0;
    self.forgetButton.layer.cornerRadius = 5;
    self.forgetButton.backgroundColor = [UIColor flatMintColor];
    [self.forgetButton addTarget:self action:@selector(forgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetButton];
}


- (void)forgetButtonPressed:(UIButton *)sender
{
    [self.emailField resignFirstResponder];
    [self hideLabel];
    [self.indicatorView startAnimating];
    self.forgetButton.userInteractionEnabled = NO;
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indicatorView stopAnimating];
        
        if (![Validator emailValidate:[self.emailField.text stringByTrimmingCharactersInSet:whiteSpace]]) {
            self.errorLabel.text = @"Not correct email address!";
            [self shakeButton];
            [self showErrorLabel];
            return;
        } else {
            [AVUser requestPasswordResetForEmailInBackground:[self.emailField.text stringByTrimmingCharactersInSet:whiteSpace] block:^(BOOL successed, NSError *error) {
                if (successed) {
                    //tip email has been sent
                    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(35, 100, 250, 200)];
                    popView.backgroundColor = [UIColor whiteColor];
                    popView.layer.cornerRadius = 5;
                    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 230, 76)];
                    messageLabel.numberOfLines = 0;
                    messageLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
                    messageLabel.textColor = [UIColor flatMintColor];
                    messageLabel.text = @"我们已向你的邮箱中发了一封邮件，请及时点击邮件中连接，找回密码。";
                    [messageLabel sizeToFit];
                    messageLabel.textAlignment = NSTextAlignmentCenter;
                    [popView addSubview:messageLabel];
                    KLCPopup *popUP = [KLCPopup popupWithContentView:popView showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
                    [popUP show];
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

- (void)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)shakeButton
{
    POPSpringAnimation *shakeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shakeAnimation.velocity = @2000;
    shakeAnimation.springBounciness = 20;
    [shakeAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished){
        self.forgetButton.userInteractionEnabled = YES;
    }];
    [self.forgetButton.layer pop_addAnimation:shakeAnimation forKey:@"shake-it"];
}

-(void)showErrorLabel
{
    self.errorLabel.layer.opacity = 1.0f;
    
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.forgetButton.layer.position.y + self.forgetButton.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"labelPosition"];
}

- (void)hideLabel
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.forgetButton.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}


#pragma mark - MONActivityIndicatorViewDelegate
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    return [UIColor flatPurpleColor];
}

@end
