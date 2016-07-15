//
//  ProfileViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-22.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "ProfileViewController.h"
#import "BandleCellPhoneViewController.h"
#import "ProfileModel.h"
#import "SchoolModel.h"
#import "UserInfoModel.h"
#import "ProfileCell.h"
#import "HeadviewCell.h"
#import "RSJSWebViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ProfileViewController()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UserInfoModel *userInfoModel;
}
@end


@implementation ProfileViewController
{
    NSArray *items;
    UIImage *oldImg1;
    UIImage *oldImg2;
    UIView *statusBarView;
}

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    
    items = @[
        @{
            @"title" : @"管理收货地址",
            @"imgUrl" : @"icon_map",
            @"url" : @"addresses",
        },
        @{
            @"title" : @"我的优惠券",
            @"imgUrl" : @"icon_coupon",
            @"url" : @"coupon",
        },
        @{
            @"title" : @"联系我们",
            @"imgUrl" : @"icon_phone",
            @"url" : @"contactUs",
        },
    ];
    
    self.models = [[NSMutableArray alloc]init];
    userInfoModel = [[UserInfoModel alloc]init];
    userInfoModel.cellHeight = 145;
    userInfoModel.title = @"绑定手机";
    userInfoModel.cellClassName = @"HeadviewCell";
    userInfoModel.url = @"RSUser://RSJSWeb";
    [self.models addObject:userInfoModel];
    
    for(NSDictionary *dict in items) {
        ProfileModel *model = [ProfileModel new];
        model.title = [dict valueForKey:@"title"];
        model.url = [dict valueForKey:@"url"];
        model.imgUrl = [dict valueForKey:@"imgUrl"];
        [self.models addObject:model];
    }
    
    [self.tableView reloadData];
    
    RSButton *settingBtn = [RSButton buttonWithFrame:CGRectMake(0, 0, 30, 44) ImageName:@"icon_setting" Text:nil TextColor:RS_Clear_Clor];
    
    @weakify(self)
    [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        UIViewController *vc = [RSRoute getViewControllerByPath:@"RSUser://setting"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initDataSorce];
    self.tableView.y = 63;

    self.navigationController.navigationBar.backgroundColor = RS_Theme_Color;
    oldImg1 = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    oldImg2 = [self.navigationController.navigationBar shadowImage];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor = RS_Theme_Color;
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    if(![AppConfig getAPPDelegate].schoolModel) {
        [SchoolModel getSchoolMsg:^(SchoolModel *schoolModel) {
            [AppConfig getAPPDelegate].schoolModel = schoolModel;
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1000, [UIScreen mainScreen].bounds.size.width, 1001)];
    imageView.alpha = 1.0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.backgroundColor = RS_Theme_Color;
    [self.tableView addSubview:imageView];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:oldImg1 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:oldImg2];
    self.navigationController.navigationBar.backgroundColor = RS_Theme_Color;
    
    [statusBarView removeFromSuperview];
}

#pragma mark 初始化数据
- (void)initDataSorce
{
    __weak ProfileViewController *selfB = self;
    [UserInfoModel getUserInfo:^(UserInfoModel *userInfoModelparam) {
        userInfoModel=userInfoModelparam;
        userInfoModel.cellHeight = 145;
        userInfoModel.title = @"绑定手机";
        userInfoModel.cellClassName = @"HeadviewCell";
        userInfoModel.url = @"RSUser://RSJSWeb";
        
        [selfB.models removeObjectAtIndex:0];
        [selfB.models insertObject:userInfoModel atIndex:0];
        [selfB.tableView reloadData];
    }];

}

#pragma mark tableView delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileModel *model = (ProfileModel *)[self getModelByIndexPath:indexPath];
    if([model.url isEqualToString:@"contactUs"]) {
        NSString *phone = [AppConfig getAPPDelegate].schoolModel.contactMobile;
        if (phone.length == 0) {
            [[RSToastView shareRSToastView] showToast:@"号码获取失败,请稍后尝试"];
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone]]];
        return;
    }

    UIViewController *vc = [RSRoute getViewControllerByPath:model.url];
    if ([vc isKindOfClass:[RSJSWebViewController class]])
    {
//        NSString* urlStr = [NSString URLencode:APP_REGISTER_URL stringEncoding:NSUTF8StringEncoding];
//        UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://RSJSWeb?urlString=%@&isEncodeURL=1",urlStr]];
//        [self.navigationController pushViewController:vc animated:YES];
        [self takePhone];
        return;
    }
    if(vc) {
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)takePhone
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机", @"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%zd", buttonIndex);
    if (buttonIndex == 0) {
        //访问相机
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限 做一个友好的提示
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机\n设置>隐私>相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            return ;
        } else {
            //调用相机
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        
        
    }
    if (buttonIndex == 1) {
        //访问相册
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限 做一个友好的提示
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相册\n设置>隐私>照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            return ;
        } else {
            //打开相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    if (buttonIndex == 2) {
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    NSLog(@"%@", info);
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage]; //修改后的图片
    
//    NSString *result = [self.ehrWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getBase64('%@')",Str]];
    
    NSString *Str = [self image2DataUrl:image];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL) imageHasAlpha: (UIImage *) image {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *) image2DataUrl: (UIImage *) image {
    NSData *imageData = nil;
    NSString *mimeType = nil;
    if([self imageHasAlpha:image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    }else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@",mimeType , [imageData base64EncodedStringWithOptions:0]];
}

@end;