//
//  UserSetGenderViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-15.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "UserSetGenderViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Chameleon.h"

@interface UserSetGenderViewController ()

@property (nonatomic, strong) NSArray *genderList;
@property (nonatomic, strong) AVUser *currentUser;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UserSetGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.genderList = @[@"secret", @"male", @"female"];
    self.currentUser = [AVUser currentUser];
    NSLog(@"%@", [self.currentUser.dictionaryForObject objectForKey:@"gender"]);
    [self initTableView];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.genderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"gendercell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([self.genderList[indexPath.row] isEqualToString:[NSString stringWithFormat:@"%@", [self.currentUser.dictionaryForObject objectForKey:@"gender"]]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    cell.textLabel.textColor = [UIColor flatNavyBlueColorDark];
    cell.textLabel.text = self.genderList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.currentUser setObject:cell.textLabel.text forKey:@"gender"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
        }
    }];
}

@end
