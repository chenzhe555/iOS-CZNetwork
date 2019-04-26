//
//  CZHttpRequestStruct.h
//  CZNetwork
//
//  Created by yunshan on 2019/4/24.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 @brief 预占type: 0.请求成功 1.网络请求失败 2.取消网络导致的失败 , 业务再根据情况自行添加失败类型
 */
@property (nonatomic, assign) NSInteger failType;

/**
 @brief failType 对应的失败结构体
 */
@property (nonatomic, strong) NSError * error;
@end

NS_ASSUME_NONNULL_END
