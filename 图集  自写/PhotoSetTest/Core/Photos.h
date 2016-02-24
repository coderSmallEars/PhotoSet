//
//  Photos.h
//  PhotoSetTest
//
//  Created by 金玉龙 on 15/12/13.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photos : NSObject

@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *note;

+ (Photos*) photoWithDictionary:(NSDictionary*)dic;
@end
