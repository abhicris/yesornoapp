//
//  PostViewController.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-7.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong)UIImageView *avatarImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UITextView *contentTextView;
@property (nonatomic, strong)UIButton *addPhotoButton;
@property (nonatomic, strong)UIButton *addAtButton;
@property (nonatomic, strong)UIButton *addAudioButton;
@property (nonatomic, strong)UIButton *addVideoButton;
@property (nonatomic, strong)UIButton *addLocationButton;


@end
