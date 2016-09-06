//
//  RSJSWebViewController.m
//  RSUser
//
//  Created by 李江 on 16/5/6.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSJSWebViewController.h"
#import "LoginViewController.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "XHCustomShareView.h"

@interface RSJSWebViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TSWebViewDelegate>

@end


@implementation RSJSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
    ctx[@"RS_APP"] = self;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString *parseURLstr = [[NSString alloc] initWithString:request.URL.absoluteString];
//    NSURL *parseURL = [[NSURL alloc] initWithString:[parseURLstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    RSRoute *route = [RSRoute routeWithURL:parseURL];
//    if ([route.scheme isEqualToString:@"rsuser"]) {
//        [route parseURL:parseURL FromTarget:self];
//        return NO;
//    }else {
//        return  YES;
//    }

    NSURL *url = request.URL;
    NSString *urlstr = url.absoluteString;
    NSDictionary *dic = [urlstr parseUrl];
    
    NSString *protocol = nil;
    NSString *classname = nil;
    NSString *actionname = nil;
    NSDictionary *params = nil;
    
    if (dic) {
        NSString *path = [dic valueForKey:@"path"];
        NSArray *pathArray = [path componentsSeparatedByString:@"/"];
        if (pathArray.count == 2) {
            classname = pathArray[0];
            actionname = pathArray[1];
        }
        protocol = [dic valueForKey:@"protocol"];
        params = [dic valueForKey:@"params"];
    }
    
    if ([protocol isEqualToString:@"rsuser"] && [classname isEqualToString:@"webview"]) {
        
        NSString *actionString = [NSString stringWithFormat:@"%@:", actionname];
        SEL action = NSSelectorFromString([NSString stringWithFormat:@"%@",actionString]);
        id target = self;
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action withObject:params];
        
        return NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
}

- (void)backUp
{
    NSString *documentLocation = [self.bannerView stringByEvaluatingJavaScriptFromString:@"document.location.hash"];
    
    if ([documentLocation isEqualToString:@"#/static/myAccount"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.bannerView.canGoBack) {
        [self.bannerView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark RS_APP

- (void)loginByNative {
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) closeWebView
{
    NSString *documentLocation = [self.bannerView stringByEvaluatingJavaScriptFromString:@"document.location.hash"];
    
    if ([documentLocation isEqualToString:@"#/static/myAccount"]) {
        [self cyl_popSelectTabBarChildViewControllerAtIndex:0];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)getTokenFromNative{
    return [NSUserDefaults getValue:@"token"];
}

-(void)setNativeTokenInWeb:(NSString *)token{
    [NSUserDefaults setValue:token forKey:@"token"];
    [AppConfig checkToken];
}

- (void)setNavTitle:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
       self.navigationItem.title = title; 
    });
}

- (void)showLoadingByNative {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RSToastView shareRSToastView] showHUD:@""];
    });
}

- (void)hiddenLoadingByNative{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RSToastView shareRSToastView] hidHUD];
    });
}

#pragma mark 相册
- (void)takePhoneByNative
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
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage]; //修改后的图片
    NSString *Str = [self image2DataUrl:image];
    
    NSDictionary *dic = @{
                          @"imgdata" : Str
                          };

    [[RSToastView shareRSToastView] showHUD:@""];
    [RSHttp requestWithURL:@"/user/settingheadimg" params:dic httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSToastView] hidHUD];
        [picker dismissViewControllerAnimated:YES completion:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bannerView reload];
        });
        
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
        [picker dismissViewControllerAnimated:YES completion:nil];

    }];
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
        imageData = UIImageJPEGRepresentation(image, 0.5f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@",mimeType , [imageData base64EncodedStringWithOptions:0]];
}

- (void)share:(NSDictionary *)params {
    
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
    [requestParams setValue:[params valueForKey:@"campaign"] forKey:@"campaign"];
    
    [RSHttp mobileRequestWithURL:@"/mobile/index/campaignconfig" params:requestParams httpMethod:@"GET" success:^(NSDictionary *data) {
        NSString *title = [data valueForKey:@"title"];
        NSString *context = [data valueForKey:@"desc"];
        NSString *clickUrl = [data valueForKey:@"link"];
        NSString *imageUrl = [data valueForKey:@"imgurl"];
        NSArray *array = [params allKeys];
        clickUrl = [clickUrl stringByAppendingString:@"?"];
        for (int i=0; i<array.count; i++) {
            NSString *key = array[i];
            NSString *value = [params valueForKey:key];
            if ([key isEqualToString:@"campaign"]) {
                continue;
            }else {
               clickUrl = [clickUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, value]];
            }
        }
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@",clickUrl];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",clickUrl];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = context;
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=  context;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                XHCustomShareView *shareView = [XHCustomShareView shareViewWithPresentedViewController:self items:@[UMShareToWechatSession,UMShareToWechatTimeline] title:nil image:image urlResource:nil];
                shareView.tag = 9876;
                [[UIApplication sharedApplication].keyWindow addSubview:shareView];
            });
        });
        
        
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView]showToast:errmsg];
    }];

    
}


@end
