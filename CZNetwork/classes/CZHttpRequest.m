//
//  CZHttpRequest.m
//  CZNetwork
//
//  Created by yunshan on 2019/4/17.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import "CZHttpRequest.h"

#define CZHttpRequestMethodCallException @"CZHttpRequestMethodCallException"

@implementation CZHttpRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serializeType = HttpRequestSerializerType1;
        self.httpMethod = @"POST";
        self.timeOut = 15;
        self.headerDic = [NSMutableDictionary dictionary];
        self.cookies = [NSMutableArray array];
        self.alertType = 1;
    }
    return self;
}

-(void)start
{
    if (self.url.length <= 0) return;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

    // 生成请求参数
    [self joinRequestParams];
    
    // 对参数进行加密
    [self encryptRequestParams];
    
    // 处理属性值对应的操作
    [self handleProperties:manager];
    
    // 获取网络请求Task
    self.task = [self generateHttpTask:manager];
}

-(void)joinRequestParams
{
    if (!self.requestParams) self.requestParams = [NSMutableDictionary dictionary];
    if (!self.commonParams) [self.requestParams addEntriesFromDictionary:self.commonParams];
}

-(void)encryptRequestParams
{
    
}


-(void)handleProperties:(AFHTTPSessionManager *)manager
{
    // 设置请求的序列化规则
    [self modifyRequestSerializer:manager];
    
    // 设置请求头
    [self joinHttpRequestHeader:manager];
    
    // 添加Cookies
    [self joinHttpRequestCookies];
    
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = self.timeOut;
}

- (void)modifyRequestSerializer:(AFHTTPSessionManager *)manager
{
    switch (self.serializeType) {
        case HttpRequestSerializerType1:
        {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case HttpRequestSerializerType2:
        {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        case HttpRequestSerializerType3:
        {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case HttpRequestSerializerType4:
        {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        default:
            break;
    }
}

-(void)joinHttpRequestHeader:(AFHTTPSessionManager *)manager
{
    for (NSString * key in self.headerDic.allKeys) {
        [manager.requestSerializer setValue:key forHTTPHeaderField:self.headerDic[key]];
    }
}

-(void)joinHttpRequestCookies
{
    for (NSHTTPCookie * cookie in self.cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

-(NSURLSessionDataTask *)generateHttpTask:(AFHTTPSessionManager *)manager
{
    if ([self.httpMethod isEqualToString:@"POST"]) {
        return [manager POST:self.url parameters:self.requestParams progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleHttpRequestSuccess:task response:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleHttpRequestFail:task error:error];
        }];
    } else if ([self.httpMethod isEqualToString:@"GET"]) {
        return [manager GET:self.url parameters:self.requestParams progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleHttpRequestSuccess:task response:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleHttpRequestFail:task error:error];
        }];
    } else {
        @throw [NSException exceptionWithName:@"CZHttpMethodFail" reason:@"暂不支持 POST GET 之外其它请求方式" userInfo:nil];
    }
}

-(void)printHttpRequestInfo:(BOOL)isRequest task:(NSURLSessionDataTask *)task
{
#ifdef DEBUG
    NSLog(@"\n<%@(%@)/tag:%lu>\n%@\n",isRequest ? @"请求参数" : @"返回参数", self.url, task.taskIdentifier, self.requestParams);
    if (!isRequest && [task.response isKindOfClass:[NSHTTPURLResponse class]]) NSLog(@"\n返回头信息:\n%@\n",((NSHTTPURLResponse *)task.response).allHeaderFields);
    else if (isRequest) NSLog(@"\n请求头信息:\n%@\n",task.currentRequest.allHTTPHeaderFields);
#endif
}


-(void)handleHttpRequestBeforeWithResponseObject:(CZHttpResponse *)responseObject
{
    @throw [NSException exceptionWithName:CZHttpRequestMethodCallException reason:@"请实现 handleHttpRequestBeforeWithResponseObject 方法" userInfo:nil];
}

/**
 @brief 处理网络请求成功情况
 */
-(void)handleHttpRequestSuccess:(NSURLSessionDataTask *)task response:(id)response
{
    CZHttpResponse * httpResponse = [[CZHttpResponse alloc] init];
    httpResponse.identifierID = task.taskIdentifier;
    httpResponse.requestUrl = task.currentRequest.URL.absoluteString;
    httpResponse.object = response;
    [self handleHttpRequestBeforeWithResponseObject:httpResponse];
    [self handleHttpRequestSuccess:task responseObject:httpResponse];
}

-(void)handleHttpRequestSuccess:(NSURLSessionDataTask *)task responseObject:(CZHttpResponse *)responseObject
{
    @throw [NSException exceptionWithName:CZHttpRequestMethodCallException reason:@"请实现 handleHttpRequestSuccess:responseObject 方法" userInfo:nil];
}

/**
 @brief 处理网络请求失败情况
 */
-(void)handleHttpRequestFail:(NSURLSessionDataTask *)task error:(NSError *)error
{
    CZHttpResponse * httpResponse = [[CZHttpResponse alloc] init];
    httpResponse.identifierID = task.taskIdentifier;
    httpResponse.requestUrl = task.currentRequest.URL.absoluteString;
    httpResponse.failType = 1;
    if (task.response) {
        // 处理网络请求状态码，后续完善状态码对应信息
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        if (statusCode == 404) {
            httpResponse.error = [NSError errorWithDomain:error.domain code:statusCode userInfo:@{
                                                                                         @"text": [NSString stringWithFormat:@"请求地址不存在: %@", httpResponse.requestUrl]
                                                                                         }];
        } else {
            httpResponse.error = [NSError errorWithDomain:error.domain code:statusCode userInfo:@{
                                                                                                        @"text": error.userInfo[@"NSLocalizedDescription"]
                                                                                                        }];
        }
    } else {
        httpResponse.error = [NSError errorWithDomain:error.domain code:error.code userInfo:@{
                                                                                                    @"text": error.userInfo[@"NSLocalizedDescription"]
                                                                                                    }];
    }
    
    // 目前只处理请求正常返回/取消请求的情况
    [self handleHttpRequestBeforeWithResponseObject:httpResponse];
    if (error.code == -999) {
        httpResponse.failType = 2;
        [self handleHttpRequestCancel:task error:error responseObject:httpResponse];
    } else {
        [self handleHttpRequestFail:task error:error responseObject:httpResponse];
    }
}

- (void)handleHttpRequestCancel:(NSURLSessionDataTask *)task error:(NSError *)error responseObject:(CZHttpResponse *)responseObject
{
    @throw [NSException exceptionWithName:CZHttpRequestMethodCallException reason:@"请实现 handleHttpRequestCancel:error:responseObject 方法" userInfo:nil];
}

-(void)handleHttpRequestFail:(NSURLSessionDataTask *)task error:(NSError *)error responseObject:(CZHttpResponse *)responseObject
{
    @throw [NSException exceptionWithName:CZHttpRequestMethodCallException reason:@"请实现 handleHttpRequestSuccess:error:responseObject 方法" userInfo:nil];
}
@end

