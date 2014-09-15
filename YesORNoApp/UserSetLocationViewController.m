//
//  UserSetLocationViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-15.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "UserSetLocationViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Chameleon.h"

@interface UserSetLocationViewController ()
@property (nonatomic, strong) NSArray *locationsList;
@property (nonatomic, strong) AVUser *currentUser;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UserSetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationsList = @[@"其他", @"北京", @"上海", @"澳门", @"香港"];
    self.currentUser = [AVUser currentUser];
    [self initTableView];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locationsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"locationcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if ([self.locationsList[indexPath.row] isEqualToString:[NSString stringWithFormat:@"%@", [self.currentUser.dictionaryForObject objectForKey:@"location"]]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    cell.textLabel.textColor = [UIColor flatNavyBlueColorDark];
    cell.textLabel.text = self.locationsList[indexPath.row];
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.currentUser setObject:cell.textLabel.text forKey:@"location"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
        }
    }];
}

@end
