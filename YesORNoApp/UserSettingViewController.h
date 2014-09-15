//
//  UserSettingViewController.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPaperCheckbox.h"

@interface UserSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BFPaperCheckboxDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end
