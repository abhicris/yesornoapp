//
//  SignUpViewController.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MONActivityIndicatorView.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate, MONActivityIndicatorViewDelegate>
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@end
