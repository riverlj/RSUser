//
//  RSHttp.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSHttp.h"

@implementation RSHttp

+ (void)baseRequestWithURL:(NSString *)url
                            params:(id)params
                        httpMethod:(NSString *)httpMethod
                          success:(void (^)(id ))success
                          failure:(void (^)(NSInteger, NSString *))failure
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    NSLog(@"url=%@, params=%@, httpMethod=%@", url, params,httpMethod);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setValue:[NSUserDefaults getValue:@"token"] forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"pYNVLfIqjV/4ObhP3mTgxzE3OWFiNjQ3YmQ0ODI3NzBjOWEwMDdkYjE5MGI2MDM4YmI3NTdlYjg1OGQ3NjIzODY5NTBmZWFmMjY4MWE0ZDUPVolk6OE0wmXaxEsdpXpdVLf6raAQDGiqjqNaraUfEW4n76/QTn218pktkYdNeyfnHF7jY7r3SRF9qGUwve9oVISTysiuxuQColn72+katy7YTw1amxF1Bkd34N3ulcJG7jpH5PxbZuiYdIJcG2zG" forHTTPHeaderField:@"token"];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = APPREQUESTTIMEOUT;
    if([httpMethod isEqualToString:@"GET"]) {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"url==%@, params=%@",url, params);
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
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"PUTJSON"]){
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
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
    NSLog(@"------------%@",responseObject);
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
    [AppConfig setRootViewControllerWithCode:error.code];
    
    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    failure(error.code, errmsg);
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
