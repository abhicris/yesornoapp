//
//  UserPageViewController.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSArray *userPosts;
@property (nonatomic, strong)NSMutableDictionary *userInfo;
@end
