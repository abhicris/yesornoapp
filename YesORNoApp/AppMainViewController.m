//
//  AppMainViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "AppMainViewController.h"
#import "VBFPopFlatButton.h"
#import "chameleon.h"

@interface AppMainViewController ()
@property (nonatomic, strong) VBFPopFlatButton *leftMenuButton;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation AppMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.view.backgroundColor = [UIColor flatSkyBlueColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    [self initLeftMenuButton];
    [self initRightMenuButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftMenuButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

- (void)initLeftMenuButton
{
    self.leftMenuButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonMenuType buttonStyle:buttonPlainStyle];
    self.leftMenuButton.lineThickness = 2;
    self.leftMenuButton.tintColor = [UIColor whiteColor];
    [self.leftMenuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initRightMenuButton
{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"ring-icon"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(notificationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)notificationButtonPressed:(id)sender
{
    NSLog(@"notifications to see!");
}

@end
