//
//  DetailViewController.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong)NSDictionary *itemInfo;
@property (nonatomic, strong)NSDictionary *authorInfo;


@end
