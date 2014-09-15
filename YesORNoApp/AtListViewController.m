//
//  AtListViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-15.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "AtListViewController.h"
#import "FriendCardTableViewCell.h"
#import "Chameleon.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AtListViewController ()
@property (nonatomic, strong) NSArray *friendList;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AtListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableView datasource delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AVUser *friend = self.friendList[indexPath.row];
    static NSString *cellIndentifier = @"friendcell";
    FriendCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[FriendCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.avatarImageView.image = [UIImage imageNamed:[friend.dictionaryForObject objectForKey:@"avatar"]];
    cell.nameLabel.text = [friend.dictionaryForObject objectForKey:@"username"];
    cell.profileLabel.text = [friend.dictionaryForObject objectForKey:@"profile"];
    return cell;
}
@end
