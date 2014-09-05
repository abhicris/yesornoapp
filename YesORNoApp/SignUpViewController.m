//
//  SignUpViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "SignUpViewController.h"
#import "chameleon.h"

@interface SignUpViewController ()

@property (nonatomic, strong) UIButton *signUpButton;
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
    
    
    _usernameField.delegate = self;
    _emailField.delegate = self;
    _passwordField.delegate = self;
}

#pragma mark - UITextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    return YES;
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

- (void)signUpButtonPressed:(id)sender
{
    
}

@end
