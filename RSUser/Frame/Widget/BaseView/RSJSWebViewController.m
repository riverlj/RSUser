//
//  RSJSWebViewController.m
//  RSUser
//
//  Created by 李江 on 16/5/6.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSJSWebViewController.h"

@interface RSJSWebViewController ()

@end


@implementation RSJSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"RS_APP"] = self;
    
}

- (void)backUp
{
    if (self.bannerView.canGoBack) {
        [self.bannerView goBack];
    }else{
        [super backUp];
    }
}

-(void) closeWebView
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
