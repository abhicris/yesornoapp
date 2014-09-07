//
//  UserSettingViewController.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-6.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "UserSettingViewController.h"
#import "chameleon.h"
#import "SettingTableViewCell.h"

@interface UserSettingViewController ()
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
}


- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingcell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *titles = @[@"Avatar",@"Gender",@"Location",@"Profile",@"QRCode"];
    NSArray *infos = @[@"", @"Male", @"China", @"A normal geek and also a very handsome funny guy!", @""];
    NSArray *images = @[@"default2", @"", @"", @"", @""];
    cell.titleLabel.text = titles[indexPath.row];
    cell.infoLabel.text = infos[indexPath.row];
    if (indexPath.row == 4) {
        UIImageView *qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        qrcodeView.contentMode = UIViewContentModeScaleAspectFill;
        qrcodeView.image = [UIImage imageNamed:@"qrcode-icon"];
        [cell.itemImageView addSubview:qrcodeView];
    }
    cell.itemImageView.image = [UIImage imageNamed:images[indexPath.row]];
    return cell;
}


@end
