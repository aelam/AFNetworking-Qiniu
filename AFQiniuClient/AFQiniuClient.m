//
//  AFQiniuClient.m
//  AFQiniuClient
//
//  Created by Ryan Wang on 13-12-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "AFQiniuClient.h"
#import "QiniuPutPolicy.h"

#ifdef HAVE_MAGIC_KIT
#import <MagicKit/MagicKit.h>
#endif

#if TARGET_OS_IPHONE
    #import <MobileCoreServices/MobileCoreServices.h>
#else
    #import <SystemConfiguration/SystemConfiguration.h>
#endif

#define kQiniuUpHost @"http://up.qiniu.com"


#ifndef HAVE_MAGIC_KIT
#define HAVE_MAGIC_KIT
#endif

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


- (AFHTTPRequestOperation *)uploadFile:(id)file
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
    
    if (mimeType == nil) {
        mimeType = [[self class] mimeTypeForFile:file];
    }

    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:@"/" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        NSError *error = nil;
        // the name must be `file`
        if ([file isKindOfClass:[NSData class]]) {
            [formData appendPartWithFileData:file name:@"file" fileName:name mimeType:mimeType];
        } else if ([file isKindOfClass:[NSString class]]) {
            NSURL *fileURL = [NSURL fileURLWithPath:file];
            if (fileURL) {
                [formData appendPartWithFileURL:fileURL name:@"file" fileName:name mimeType:mimeType error:&error];
            } else {
                [[NSException exceptionWithName:@"NotImage" reason:@"Not a file path" userInfo:nil] raise];
            }
        } else {
            [[NSException exceptionWithName:@"NotSupportType" reason:@"Not a supported type of file" userInfo:nil] raise];
        }
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

+ (NSString *)mimeTypeForFile:(id)file {
#ifdef HAVE_MAGIC_KIT
    GEMagicResult *result;
    
    if ([file isKindOfClass:[NSData class]]) {
        result = [GEMagicKit magicForData:file];
        return result.mimeType;
    } else if ([file isKindOfClass:[NSString class]]) {
        
        NSURL *fileURL = [NSURL fileURLWithPath:file];
        if (fileURL) {
            result = [GEMagicKit magicForFileAtURL:fileURL];
            return result.mimeType;
        } else {
            return @"application/octet-stream";
        }
    } else {
        return @"application/octet-stream";
    }
#else
    return @"application/octet-stream";
#endif
}

@end
