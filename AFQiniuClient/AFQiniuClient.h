//
//  AFQiniuClient.h
//  AFQiniuClient
//
//  Created by Ryan Wang on 13-12-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "QiniuPutExtra.h"

//#define AK @"yGZ5pDMaYFfQrHjzcbkOkmmpeJydOOfLPf7UanoI"
//#define SK @"zm76rQUtvpbq5Fu14MYOARPvnx5nQlfaHrFPjwkE"
//#define BASE_URL @"http://cpod.qiniu.com"

@interface AFQiniuClient : AFHTTPClient

+ (instancetype)clientWithToken:(NSString *)token;

+ (instancetype)clientWithAppKey:(NSString *)token secret:(NSString *)secret scope:(NSString *)bucket;

- (AFHTTPRequestOperation *)uploadFile:(NSString *)filePath
                              fileName:(NSString *)name
                                 extra:(QiniuPutExtra *)extra;

@end
