//
//  DetailViewController.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) AVObject *post;
@property (nonatomic, retain) NSDictionary *author;


@end
