//
//  PhotoSet.h
//  PhotoSetTest
//
//  Created by 金玉龙 on 15/12/13.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos.h"
@interface PhotoSet : NSObject

@property (nonatomic, copy) NSString *setname;
@property (nonatomic, strong) NSNumber *imgsum;
@property (nonatomic, strong) NSMutableArray *photosArray;

+ (PhotoSet*)photoSetWithDictionary:(NSDictionary*)dic;
@end
