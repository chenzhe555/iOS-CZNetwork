//
//  CZHttpRequest.h
//  CZNetwork
//
//  Created by yunshan on 2019/4/17.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestEnum.h"
#import <AFNetworking/AFNetworking.h>
#import "CZHttpRequestStruct.h"

NS_ASSUME_NONNULL_BEGIN
/**
 @brief 网络请求基类
 */
@interface CZHttpRequest : NSObject

/**
 @brief 当前网络请求Task
 */
@property (nonatomic, strong) NSURLSessionDataTask * task;

/**
 @brief 网络请求地址
 */
@property (nonatomic, copy) NSString * url;

/**
 @brief 网络请求方法 目前只处理GET POST
 */
@property (nonatomic, copy) NSString * httpMethod;

/**
 @brief 公共参数
 */
@property (nonatomic, strong) NSDictionary * commonParams;

/**
 @brief 网络请求参数
 */
@property (nonatomic, strong) NSMutableDictionary * requestParams;

/**
 @brief 请求序列化规则
 @see HttpRequestSerializerType
 */
@property (nonatomic, assign) HttpRequestSerializerType serializeType;

/**
 @brief 请求头
 */
@property (nonatomic, strong) NSMutableDictionary * headerDic;

/**
 @brief Cookie
 */
@property (nonatomic, strong) NSMutableArray<NSHTTPCookie *> * cookies;

/**
 @brief 请求超时时间
 */
@property (nonatomic, assign) CGFloat timeOut;

/**
 @brief 网络请求失败后弹框处理方式, 预占 1.默认无弹框等操作 2.系统Alert框 3.Toast
 */
@property (nonatomic, assign) NSInteger alertType;

/**
 @brief 启动网络请求
 @discussion 根据项目实际情形拼接 start流程
 */
-(void)start;

#pragma mark 网络请求前相关处理

/**
 @brief 对请求参数进行加密
 */
-(void)encryptRequestParams;

/**
 @brief 生成网络任务
 */
-(NSURLSessionDataTask *)generateHttpTask;

/**
 @brief 在网络回调之前的处理。可对同一请求多处调用做预处理操作等等

 @param responseObject 成功/失败结果
 */
-(void)handleHttpRequestBeforeWithResponseObject:(CZHttpResponse *)responseObject;

/**
 @brief 业务自行处理网络请求成功的结果

 @param task 网络请求任务Task
 @param responseObject 返回结果
 */
-(void)handleHttpRequestSuccess:(NSURLSessionDataTask * _Nonnull)task responseObject:(CZHttpResponse *)responseObject;

/**
 @brief 业务自行处理网络请求失败的结果
 
 @param task 网络请求任务Task
 @param error 失败原因
 */
-(void)handleHttpRequestFail:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error responseObject:(CZHttpResponse *)responseObject;

/**
 @brief 业务自行处理取消网络请求的失败()
 
 @param task 网络请求任务Task
 @param error 失败原因
 */
-(void)handleHttpRequestCancel:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error responseObject:(CZHttpResponse *)responseObject;

@end

NS_ASSUME_NONNULL_END
