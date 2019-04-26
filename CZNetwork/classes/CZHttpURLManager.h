//
//  CZHttpURLManager.h
//  CZNetwork
//
//  Created by yunshan on 2019/4/25.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZHttpURLManager : NSObject
/**
 @brief 网络地址
 */
@property (nonatomic, strong) NSDictionary * urlsDic;

/**
 @brief 获取当前实例
 */
+(instancetype)shareManager;

/**
 @brief 更新网络请求地址字典
 */
-(void)updateUrlsDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
