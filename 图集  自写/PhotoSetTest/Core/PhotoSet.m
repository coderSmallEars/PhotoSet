//
//  PhotoSet.m
//  PhotoSetTest
//
//  Created by 金玉龙 on 15/12/13.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import "PhotoSet.h"

@implementation PhotoSet

+ (PhotoSet*)photoSetWithDictionary:(NSDictionary*)dic{
    PhotoSet *photoSet = [[PhotoSet alloc] init];
    photoSet.setname = toString(dic[@"setname"]);
    photoSet.imgsum = dic[@"imgsum"];
    if (dic[@"photos"] && [dic[@"photos"] isKindOfClass:[NSArray class] ]) {
        photoSet.photosArray = [[NSMutableArray alloc] init];
        for (NSDictionary *photoDic in dic[@"photos"]) {
            if (photoDic && [photoDic isKindOfClass:[NSDictionary class]]) {
                [photoSet.photosArray addObject:[Photos photoWithDictionary:photoDic]];
            }
        }
    }
    return photoSet;
}

@end
