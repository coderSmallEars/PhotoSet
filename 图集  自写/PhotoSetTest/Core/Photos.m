//
//  Photos.m
//  PhotoSetTest
//
//  Created by 金玉龙 on 15/12/13.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import "Photos.h"

@implementation Photos

+ (Photos*) photoWithDictionary:(NSDictionary*)dic{
    Photos *photo = [[Photos alloc] init];
    photo.imgurl = toString(dic[@"imgurl"]);
    photo.note = toString(dic[@"note"]);
    return photo;
}
@end
