//
//  LEPhotoView.h
//  LESports
//
//  Created by 金玉龙 on 15/12/11.
//  Copyright © 2015年 LETV. All rights reserved.
//
//  单个图片view

#import <UIKit/UIKit.h>

@interface LEPhotoView : UIScrollView

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, copy) NSString *imageUrlStr;
@property (nonatomic, assign) BOOL isZoomed;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGR;
/**
 *  更新视图
 *
 *  @param resetZoomScale urlString
 */
- (void)updateImageViewWithimageUrlStr:(NSString*)imageUrlStr;
/**
 *  还原缩放比例
 */
- (void)resetZoomScale;

@end
