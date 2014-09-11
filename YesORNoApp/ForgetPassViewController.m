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

@interface ForgetPassViewController ()
@property (nonatomic, strong) UILabel *forgetTipLabel;

@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UIButton *cancelButton;
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
    
    _emailField.delegate = self;
    [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_emailField becomeFirstResponder];
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


- (void)forgetButtonPressed:(id)sender
{
    
}

- (void)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
