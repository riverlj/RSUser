//
//  RSHttp.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSHttp.h"
#import "CodesView.h"

@implementation RSHttp

+ (void)baseRequestWithURL:(NSString *)url
                            params:(id)params
                        httpMethod:(NSString *)httpMethod
                          success:(void (^)(id ))success
                          failure:(void (^)(NSInteger, NSString *))failure
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[NSUserDefaults getValue:@"token"] forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSLog(@"\n请求地址url=%@,\n请求头header=%@, \n请求参数params=%@, \n请求方法httpMethod=%@\n", url, manager.requestSerializer.HTTPRequestHeaders, params,httpMethod);

    //设置超时时间
    manager.requestSerializer.timeoutInterval = APPREQUESTTIMEOUT;
    if([httpMethod isEqualToString:@"GET"]) {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"POST"]) {
        [manager POST:url parameters:params constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"PUT"]) {
        [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"DELETE"]) {
        [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"POSTJSON"]){
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:[NSUserDefaults getValue:@"token"] forHTTPHeaderField:@"token"];
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"PUTJSON"]){
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:[NSUserDefaults getValue:@"token"] forHTTPHeaderField:@"token"];
        [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    }else {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    }
}


+(void) processSuccess:(void (^)(id data)) success
             operation:(AFHTTPRequestOperation *)op
              response:(id)responseObject
               failure:(void (^)(NSInteger code, NSString *errmsg))failure;
{
    NSLog(@"返回结果：%@",responseObject);
    NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
    //如果成功
    if(code == 0) {
        id body = [responseObject valueForKey:@"body"];
        success(body);
    } else {
        NSDictionary *userInfo;
        if([responseObject objectForKey:@"msg"]) {
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[responseObject valueForKey:@"msg"], NSLocalizedDescriptionKey, nil];
        } else {
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[responseObject valueForKey:@"body"], NSLocalizedDescriptionKey, nil];
        }
        NSError *error = [NSError errorWithDomain:@"httpUserError" code:code userInfo:userInfo];
        [self processFailure:failure operation:op error:error];
    }
}

+(void) processFailure:(void (^)(NSInteger code, NSString *errmsg))failure
             operation:(AFHTTPRequestOperation *)op
                 error:(NSError *)error
{
    NSLog(@"错误：/n%@", error);
    [AppConfig setRootViewControllerWithCode:error.code];
    switch (error.code) {
        case 801:{
            CodesView *codeView = [[CodesView alloc]init];
            [codeView show];
        }
        case 500:{
            [[RSToastView shareRSToastView] showToast:@"服务器吃撑了"];
        }
            
        default:
        {
            NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
            failure(error.code, errmsg);
            break;
        }
    }
    

    
}


+(void) requestWithURL:(NSString *)urlstring
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)httpMethod success:(void (^)(id ))success
               failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:REDSCARF_BASE_URL];
    [self baseRequestWithURL:urlstring params:params httpMethod:httpMethod success:success failure:failure constructingBodyWithBlock:nil];
}

+(void)payRequestWithURL:(NSString *)urlstring
                  params:(NSMutableDictionary *)params
              httpMethod:(NSString *)httpMethod
                 success:(void (^)(id ))success
                 failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:REDSCARF_PAY_URL];
    [self baseRequestWithURL:urlstring params:params httpMethod:httpMethod success:success failure:failure constructingBodyWithBlock:nil];
}

+(void)mobileRequestWithURL:(NSString *)urlstring
                  params:(NSMutableDictionary *)params
              httpMethod:(NSString *)httpMethod
                 success:(void (^)(id ))success
                 failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:REDSCARF_MOBILE_URL];
    [self baseRequestWithURL:urlstring params:params httpMethod:httpMethod success:success failure:failure constructingBodyWithBlock:nil];
}



+(void) postDataWithURL:(NSString *)urlstring params:(NSMutableDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id ))success failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:REDSCARF_BASE_URL];
    [self baseRequestWithURL:urlstring params:params httpMethod:@"POST" success:success failure:failure constructingBodyWithBlock:block];
}
@end
