//
//  News.h
//  PhotoSetTest
//
//  Created by 金玉龙 on 15/12/13.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, copy) NSString *setname;
@property (nonatomic, copy) NSString *createdate;
@property (nonatomic, strong) NSNumber *imgsum;
@property (nonatomic, strong) NSArray *pics;
@property (nonatomic, strong) NSNumber *setid;

@end

