//
//  RViewController.h
//  AFQiniu
//
//  Created by Ryan Wang on 13-12-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiniuConfig.h"

@interface RViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *uploadButton;
@property (nonatomic, strong) IBOutlet UIButton *downloadButton;
@property (nonatomic, strong) IBOutlet UILabel *hashLabel;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;

@end
