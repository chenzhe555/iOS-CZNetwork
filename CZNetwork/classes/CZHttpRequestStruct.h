//
//  CZHttpRequestStruct.h
//  CZNetwork
//
//  Created by yunshan on 2019/4/24.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HttpResponseType) {
    HttpResponseTypeRequestSuccess = 1, // 没有失败，请求成功
    HttpResponseTypeRequestSuccessWithFailInfo, //请求成功但是服务器返回失败信息
    HttpResponseTypeRequestFail, // 请求失败
    HttpResponseTypeRequestFailWithCancel, // 取消请求导致的失败
};

NS_ASSUME_NONNULL_BEGIN

@interface CZHttpResponse : NSObject

/**
 @brief 服务器返回的数据
 */
@property (nonatomic, strong) id object;

/**
 @brief 请求的唯一标识ID
 */
@property (nonatomic, assign) NSUInteger identifierID;

/**
 @brief 网络请求地址
 */
@property (nonatomic, copy) NSString * requestUrl;

/**
 @brief 预占type: 1.没有失败，请求成功 2.请求成功但是服务器返回失败信息 3.请求失败 4.取消请求导致的失败, 业务再根据情况自行添加失败类型
 */
@property (nonatomic, assign) HttpResponseType failType;

/**
 @brief failType 对应的失败结构体
 */
@property (nonatomic, strong) NSError * error;
@end

NS_ASSUME_NONNULL_END
