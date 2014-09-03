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
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
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

- (void)addEmailField
{
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, 230, 44)];
    self.emailField.textColor = [UIColor flatNavyBlueColorDark];
    self.emailField.placeholder = @"Email Address";
    self.emailField.font = [UIFont fontWithName:@"Avenir" size:14];
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
    self.passwordField.font = [UIFont fontWithName:@"Avenir" size:14];
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
    self.signUpButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
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
