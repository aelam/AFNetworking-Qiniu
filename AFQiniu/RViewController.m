//
//  RViewController.m
//  AFQiniu
//
//  Created by Ryan Wang on 13-12-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RViewController.h"
//#import "AFQiniuClient.h"
#import <AFQiniuClient/AFQiniuClient.h>
//#import <JSONKit/JSONKit.h>

@interface RViewController ()
@property (nonatomic, strong)AFQiniuClient *client;
@property (nonatomic, strong) NSString *hash;
@property (nonatomic, strong) NSString *key;
@end

@implementation RViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)upload:(id)sender {
    self.client = [AFQiniuClient clientWithAppKey:QiniuAccessKey secret:QiniuSecretKey scope:QiniuBucketName];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
    
    AFHTTPRequestOperation *operation = [self.client uploadFile:path fileName:@"1.jpg" extra:nil];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        
        self.progressLabel.text = [NSString stringWithFormat:@"%lld / %lld", totalBytesWritten, totalBytesExpectedToWrite];
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [responseObject objectFromJSONData];
//        self.hash = dic[@"hash"];
//        self.key = dic[@"key"];
        
//        self.hashLabel.text = self.hash;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (IBAction)download:(id)sender {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
