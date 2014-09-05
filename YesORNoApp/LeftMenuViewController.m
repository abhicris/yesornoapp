//
//  LeftMenuViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-3.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "chameleon.h"
#import "AppMainViewController.h"
#import "FriendsListViewController.h"

@interface LeftMenuViewController ()

@property (nonatomic, strong) UITableView *leftMenuTable;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

- (void)initTableView
{
    self.leftMenuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54*6)/2, self.view.frame.size.width, 6*54) style:UITableViewStylePlain];
    self.leftMenuTable.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.leftMenuTable.delegate = self;
    self.leftMenuTable.dataSource = self;
    self.leftMenuTable.opaque = NO;
    self.leftMenuTable.backgroundView = nil;
    self.leftMenuTable.backgroundColor = [UIColor clearColor];
    self.leftMenuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftMenuTable.bounces = NO;
    
    [self initTableHeaderView];
    
    [self.view addSubview:self.leftMenuTable];
}

- (void)initTableHeaderView
{
    // TODO change data to real data
    // these info should be replaced by user info
    // now use the static info
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"default"];
    avatarView.image = image;
    avatarView.layer.cornerRadius = avatarView.layer.frame.size.width / 2;
    avatarView.layer.masksToBounds = YES;
    avatarView.layer.borderWidth = 2;
    avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:avatarView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 6, 100, 14)];
    nameLabel.text = @"Nicholas Xue";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    [tableHeaderView addSubview:nameLabel];
    
    UILabel *profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 16, 130, 40)];
    profileLabel.text = @"A normal geek and also a very funny handsome guy!";
    profileLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    profileLabel.font =[UIFont fontWithName:@"Roboto-Regular" size:12];
    profileLabel.numberOfLines = 0;
    [tableHeaderView addSubview:profileLabel];
    
    
    self.leftMenuTable.tableHeaderView = tableHeaderView;
}

#pragma mark - UITableview datasource delegate methods
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
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        UIView *selectedCellBackground = [[UIView alloc] init];
        selectedCellBackground.backgroundColor = [UIColor flatRedColor];
        cell.selectedBackgroundView = selectedCellBackground;
    }
    NSArray *titles = @[@"Home", @"Me", @"Friends", @"Settings", @"Logout"];
    NSArray *images = @[@"home-icon", @"user-icon", @"friends-icon", @"setting-icon", @"logout-icon"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[AppMainViewController new]];
            [self.sideMenuViewController setContentViewController:navigationController animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 1:
        {
            NSLog(@"go to user page.....");
            
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 2:
        {
            NSLog(@"go to friends list page...");
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[FriendsListViewController new]];
            [self.sideMenuViewController setContentViewController:navigationController animated:YES];
            
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 3:
        {
            NSLog(@"go to settings page .....");
            
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 4:
        {
            NSLog(@"log out app ......");
            
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
    }
}

@end
