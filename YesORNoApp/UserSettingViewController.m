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
#import <AVOSCloud/AVOSCloud.h>
#import "KLCPopup.h"
#import "BFPaperCheckbox.h"
#import "UserSetGenderViewController.h"
#import "UserSetLocationViewController.h"
#import "UserSetProfileViewController.h"


@interface UserSettingViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *currentUserInfo;
@property (nonatomic) KLCPopup *popUp;
@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
    AVUser *currentUser = [AVUser currentUser];
    self.currentUserInfo = currentUser.dictionaryForObject;
    
    static NSString *cellIdentifier = @"settingcell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *titles = @[@"Avatar",@"Gender",@"Location",@"Profile",@"QRCode"];
    
    NSArray *infos = @[@"", [self.currentUserInfo objectForKey:@"gender"], [self.currentUserInfo objectForKey:@"location"], [self.currentUserInfo objectForKey:@"profile"], @""];
    
    cell.titleLabel.text = titles[indexPath.row];
    cell.infoLabel.text = infos[indexPath.row];
    if (indexPath.row == 4) {
        UIImageView *qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        qrcodeView.contentMode = UIViewContentModeScaleAspectFill;
        qrcodeView.image = [UIImage imageNamed:@"qrcode-icon"];
        [cell.itemImageView addSubview:qrcodeView];
    }
    if (indexPath.row == 0) {
        cell.itemImageView.image = [UIImage imageNamed:[self.currentUserInfo objectForKey:@"avatar"]];
    }
    return cell;
}

#pragma mark - UITabelView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UIView *setAvatarView = [[UIView alloc] initWithFrame:CGRectMake(45, 110, 230, 200)];
            setAvatarView.layer.cornerRadius = 5;
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 70)];
            topView.backgroundColor = [UIColor flatBlueColor];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 130, 34)];
            titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
            titleLabel.text = @"Choose from";
            titleLabel.textColor = [UIColor flatNavyBlueColorDark];
            [titleLabel sizeToFit];
            [topView addSubview:titleLabel];
            
            UIView *item1View = [[UIView alloc] initWithFrame:CGRectMake(0, 67, 230, 65)];
            item1View.backgroundColor = [UIColor flatWhiteColor];
            
            UIView *item2View = [[UIView alloc] initWithFrame:CGRectMake(0, 135, 230, 65)];
            item2View.backgroundColor = [UIColor flatWhiteColor];
            
            UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 22, 100, 21)];
            cameraLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
            cameraLabel.textColor = [UIColor flatNavyBlueColorDark];
            cameraLabel.text = @"Take a photo";
            [item1View addSubview:cameraLabel];
            BFPaperCheckbox *cameraCheckbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(160, 7, 25*2, 25*2)];
            cameraCheckbox.tag = 1001;
            cameraCheckbox.delegate = self;
            [item1View addSubview:cameraCheckbox];
            
            UILabel *albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 22, 100, 21)];
            albumLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
            albumLabel.textColor = [UIColor flatNavyBlueColorDark];
            albumLabel.text = @"From album";
            [item2View addSubview:albumLabel];
            BFPaperCheckbox *albumCheckbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(160, 7, 25*2, 25*2)];
            albumCheckbox.tag = 1002;
            albumCheckbox.delegate = self;
            [item2View addSubview:albumCheckbox];
            
            [setAvatarView addSubview:item1View];
            [setAvatarView addSubview:item2View];
            [setAvatarView addSubview:topView];
            self.popUp = [KLCPopup popupWithContentView:setAvatarView showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
            [self.popUp show];
            break;
        }
        case 1:
        {
            [self.navigationController pushViewController:[UserSetGenderViewController new] animated:YES];
            break;
        }
        case 2:
        {
            [self.navigationController pushViewController:[UserSetLocationViewController new] animated:YES];
            break;
        }
        case 3:
        {
            [self.navigationController pushViewController:[UserSetProfileViewController new] animated:YES];
            break;
        }
    }
}

#pragma mark - BFPaperCheckbox delegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
{
    [self.popUp dismiss:YES];
    if (checkbox.tag == 1001) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            [self presentViewController:pickerController animated:YES completion:NULL];
        } else {
            NSLog(@"NO camera available");
        }
    }
    if (checkbox.tag == 1002) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            [self presentViewController:pickerController animated:YES completion:NULL];
        } else {
            NSLog(@"NO album available");
        }
    }
}
@end
