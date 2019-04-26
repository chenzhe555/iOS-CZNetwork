//
//  CZHttpURLManager.m
//  CZNetwork
//
//  Created by yunshan on 2019/4/25.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import "CZHttpURLManager.h"

@implementation CZHttpURLManager
+(instancetype)shareManager
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self class] new];
    });
    return manager;
}

-(void)updateUrlsDic:(NSDictionary *)dic
{
    self.urlsDic = dic;
}
@end
