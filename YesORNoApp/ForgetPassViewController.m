//
//  ForgetPassViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "chameleon.h"

@interface ForgetPassViewController ()
@property (nonatomic, strong) UILabel *forgetTipLabel;
@property (nonatomic, strong) UITextField *emailField;
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
}

- (void)addForgetTipLabel
{
    self.forgetTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 210, 44)];
    self.forgetTipLabel.text = @"please enter your email address, when you signed up used.";
    self.forgetTipLabel.textColor = [UIColor flatRedColor];
    self.forgetTipLabel.textAlignment = NSTextAlignmentCenter;
    self.forgetTipLabel.numberOfLines = 0;
    self.forgetTipLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    [self.view addSubview:self.forgetTipLabel];
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

- (void)addCancelButton
{
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 190, 100, 20)];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor flatMintColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
}

- (void)addForgetButton
{
    self.forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 128, 230, 44)];
    [self.forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.forgetButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    self.forgetButton.layer.borderWidth = 0;
    self.forgetButton.layer.cornerRadius = 5;
    self.forgetButton.backgroundColor = [UIColor flatMintColor];
    [self.forgetButton addTarget:self action:@selector(forgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetButton];
}


- (void)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)forgetButtonPressed:(id)sender
{
    
}

@end
