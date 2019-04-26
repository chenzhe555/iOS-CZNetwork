//
//  HttpRequestEnum.h
//  CZNetwork
//
//  Created by yunshan on 2019/4/17.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HttpRequestSerializerType) {
    HttpRequestSerializerType1 = 200,               //request-json,response-json
    HttpRequestSerializerType2,                     //request-json,response-http
    HttpRequestSerializerType3,                     //request-http,response-json
    HttpRequestSerializerType4                      //request-http,response-http
};

