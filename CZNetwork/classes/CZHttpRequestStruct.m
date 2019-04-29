//
//  CZHttpRequestStruct.m
//  CZNetwork
//
//  Created by yunshan on 2019/4/24.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import "CZHttpRequestStruct.h"

@implementation CZHttpResponse
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.failType = HttpResponseTypeRequestSuccess;
    }
    return self;
}
@end
