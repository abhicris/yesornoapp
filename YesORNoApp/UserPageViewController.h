//
//  UserPageViewController.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) AVUser *user;
@end
