//
//  AFQiniuClient.m
//  AFQiniuClient
//
//  Created by Ryan Wang on 13-12-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "AFQiniuClient.h"
#import "QiniuPutPolicy.h"

#define kQiniuUpHost @"http://up.qiniu.com"

@interface AFQiniuClient ()

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) QiniuPutPolicy *policy;
@end

@implementation AFQiniuClient

@synthesize token;

+ (instancetype)clientWithAppKey:(NSString *)appKey secret:(NSString *)secret scope:(NSString *)bucket {
    QiniuPutPolicy *policy = [QiniuPutPolicy new];
    policy.scope = bucket;
    
    NSString *token = [policy makeToken:appKey secretKey:secret];
    
    return [self clientWithToken:token];
}


+ (instancetype)clientWithToken:(NSString *)token {
    AFQiniuClient *client = [[self alloc] initWithBaseURL:[NSURL URLWithString:kQiniuUpHost]];
    client.token = token;
    return client;
}


- (AFHTTPRequestOperation *)uploadFile:(NSString *)filePath
                fileName:(NSString *)name
              extra:(QiniuPutExtra *)extra
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:token forKey:@"token"];
    
    NSString *mimeType = nil;
    if (extra) {
        mimeType = extra.mimeType;
        if (extra.checkCrc == 1) {
            [parameters setObject:[NSString stringWithFormat:@"%u", (unsigned int)extra.crc32] forKey:@"crc32"];
        }
        
        [parameters addEntriesFromDictionary:extra.params];
    }

    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:@"/" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        NSError *error = nil;
        // the name must be `file` 
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:name mimeType:@"image/*" error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error);
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
    
}


@end
