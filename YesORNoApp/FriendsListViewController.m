//
//  FriendsListViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-5.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "FriendsListViewController.h"
#import "chameleon.h"
#import "VBFPopFlatButton.h"
#import "FriendCardTableViewCell.h"
#import "AppMainViewController.h"


@interface FriendsListViewController ()
@property (nonatomic, strong) VBFPopFlatButton *leftBackButton;
@property (nonatomic, strong) UIButton *rightSearchButton;
@property (nonatomic, strong) UITableView *contentTableView;
@end

@implementation FriendsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatRedColor]];
    [self initLeftBackButton];
    [self initRightSearchButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightSearchButton];
    
    [self initTableView];
    
}

- (void)initLeftBackButton
{
    self.leftBackButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonMenuType buttonStyle:buttonPlainStyle];
    self.leftBackButton.tintColor = [UIColor whiteColor];
    self.leftBackButton.lineThickness = 2;

    [self.leftBackButton addTarget:self action:@selector(leftBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initRightSearchButton
{
    self.rightSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [self.rightSearchButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightSearchButton setBackgroundImage:[UIImage imageNamed:@"ring-icon"] forState:UIControlStateNormal];
    [self.rightSearchButton addTarget:self action:@selector(rightSearchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTableView
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-44) style:UITableViewStylePlain];
    self.contentTableView.backgroundColor = [UIColor clearColor];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.view addSubview:self.contentTableView];
}

-(void)leftBackButtonPressed:(id)sender
{
    NSLog(@"fucking back");
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)rightSearchButtonPressed:(id)sender
{
    
}

#pragma mark - UITableView Datasource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"friendcell";
    FriendCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FriendCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *selectedCellBackground = [[UIView alloc] init];
        selectedCellBackground.backgroundColor = [UIColor flatWhiteColor];
        cell.selectedBackgroundView = selectedCellBackground;
    }
    NSArray *friendsName = @[@"Nicholas", @"Sophia", @"Michelle", @"Tiffany", @"James"];
    NSArray *profiles = @[@"if you change screen orientation you can see it hidden off-screen in the bottom", @"if you change screen orientation you", @"if you change screen orientation you can see it hidden off-screen in the bottom", @"if you change screen orientation you", @"if you change screen orientation you"];
    NSArray *avatarNames = @[@"default", @"default", @"default2", @"default", @"default2"];
    cell.nameLabel.text = friendsName[indexPath.row];
    cell.profileLabel.text = profiles[indexPath.row];
    cell.avatarImageView.image = [UIImage imageNamed:avatarNames[indexPath.row]];
    [cell.addOrCancelButton setBackgroundImage:[UIImage imageNamed:@"check-active"] forState:UIControlStateNormal];
    [cell.addOrCancelButton addTarget:self action:@selector(addOrCancelButtonPressd:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(void)addOrCancelButtonPressd:(id)sender
{
    
}


@end
