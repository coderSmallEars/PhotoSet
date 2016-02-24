//
//  LEPhotoSetController.h
//  LESports
//
//  Created by 金玉龙 on 15/12/11.
//  Copyright © 2015年 LETV. All rights reserved.
//
//  图集Ctrl

#import <UIKit/UIKit.h>

@interface LEPhotoSetController : UIViewController

@property (nonatomic, strong) NSString *setId;

- (id)initWithNewsId:(NSString *)setId;

@end
