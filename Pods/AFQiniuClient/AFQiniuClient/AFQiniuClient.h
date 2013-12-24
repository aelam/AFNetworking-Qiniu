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

@interface AFQiniuClient : AFHTTPClient

/**
 * @token uploadToken
 * You can get from your server
 */
+ (instancetype)clientWithToken:(NSString *)token;

/**
 * @appKey appKey
 * @secret appSecret
 * @scope  your bucket name case-sensitive
 * calculate uploadToken on client-side
 */
+ (instancetype)clientWithAppKey:(NSString *)appKey secret:(NSString *)secret scope:(NSString *)bucket;

/**
 * @file supports NSDate and NSString(filePath)
 * @extra specific mimeType or magic args
 * default mimeType is nil, qiniu will detect it
 */
- (AFHTTPRequestOperation *)uploadFile:(id)file
                              fileName:(NSString *)name
                                 extra:(QiniuPutExtra *)extra;

@end
