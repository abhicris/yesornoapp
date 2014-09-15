//
//  UserSetProfileViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-15.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "UserSetProfileViewController.h"
#import "Chameleon.h"
#import <AVOSCloud/AVOSCloud.h>



@interface UserSetProfileViewController ()
@property (nonatomic) UITextView *textView;
@property (nonatomic, strong) AVUser *currentUser;
@end

@implementation UserSetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentUser = [AVUser currentUser];
    [self addRightDoneButton];
    [self initTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)addRightDoneButton
{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"done-icon"] forState:UIControlStateNormal];
    [doneButton setTitle:@"" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}
- (void)initTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.textView setLinkTextAttributes:@{NSForegroundColorAttributeName:[UIColor flatBlueColor]}];
    self.textView.scrollEnabled = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.textView.textContainer.maximumNumberOfLines = 2;
    self.textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.textView.textColor = [UIColor flatNavyBlueColorDark];
    self.textView.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    self.textView.text = [NSString stringWithFormat:@"%@", [self.currentUser.dictionaryForObject objectForKey:@"profile"]];
    
    [self.view addSubview:self.textView];
}

- (void)doneButtonPressed:(id)sender
{
    [self.currentUser setObject:self.textView.text forKey:@"profile"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
        }
    }];
}

@end
