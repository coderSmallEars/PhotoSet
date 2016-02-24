//
//  LEPhotoSetCell.h
//  LESports
//
//  Created by 金玉龙 on 15/12/11.
//  Copyright © 2015年 LETV. All rights reserved.
//
//  图集Cell

#import <UIKit/UIKit.h>
#import "News.h"
@interface LEPhotoSetCell : UITableViewCell

- (void)refreshNewsSelfContent:(News *)newsModel;

@end
