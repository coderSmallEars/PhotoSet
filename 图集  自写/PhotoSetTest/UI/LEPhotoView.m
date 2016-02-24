//
//  LEPhotoView.m
//  LESports
//
//  Created by 金玉龙 on 15/12/11.
//  Copyright © 2015年 LETV. All rights reserved.
//

#import "LEPhotoView.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface LEPhotoView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGRect superViewFrame;
@property (nonatomic, assign) float imageScale;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@end

@implementation LEPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCompnent];
        self.backgroundColor = [UIColor blackColor];
        self.scrollEnabled = YES;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = NO;
        self.zoomScale = 1;
        self.isZoomed = NO;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)layoutSubviews{
    self.superViewFrame = self.frame;
}

- (void)initCompnent{
    [self addSubview:self.photoView];
}
//加载图片
- (void)updateImageViewWithimageUrlStr:(NSString*)imageUrlStr{
    if (self.imageUrlStr != imageUrlStr) {
        self.imageUrlStr = imageUrlStr;
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        WS(weakSelf)
        if (self.imageUrlStr && [self.imageUrlStr isKindOfClass:[NSString class]]) {
            [self.photoView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                weakSelf.progressHUD.hidden = YES;
                if (image && [image isKindOfClass:[UIImage class]]) {
                    CGSize size = image.size;
                    weakSelf.imageScale = size.height/size.width;
                    [weakSelf updatePhotoViewWithFrame:weakSelf.superViewFrame scale:weakSelf.imageScale];
                }
            }];
        }
    }
}
//还原缩放比例
-(void)resetZoomScale{
    [self setZoomScale:1 animated:YES];
    self.isZoomed = NO;
}
//缩放手势
- (void)zoomGesture{
    if (self.zoomScale == 1) {
        [self setZoomScale:2 animated:YES];
        _isZoomed = YES;
    }else{
        [self resetZoomScale];
    }
}
//约束
- (void)updatePhotoViewWithFrame:(CGRect)frame scale:(float)scale{
    float imageViewHeight = kScreenWidth *scale;
    float orginY = (frame.size.height - imageViewHeight) /2;
    self.photoView.frame = CGRectMake(0, orginY, kScreenWidth, imageViewHeight);
}

-(UIImageView *)photoView{
    if (_photoView == nil) {
        _photoView = [[UIImageView alloc] init];
        _photoView.backgroundColor = [UIColor clearColor];
        [_photoView sizeToFit];
        [self addGestureRecognizer:self.doubleTapGR];
    }
    return _photoView;
}

- (void)setSuperViewFrame:(CGRect)superViewFrame{
    if (![NSStringFromCGRect(_superViewFrame) isEqualToString:NSStringFromCGRect(superViewFrame)]){
        _superViewFrame = superViewFrame;
//        [self updatePhotoViewWithFrame:_superViewFrame scale:1];
    }
}

-(UITapGestureRecognizer *)doubleTapGR{
    if (_doubleTapGR == nil) {
        _doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomGesture)];
        _doubleTapGR.numberOfTapsRequired = 2;
        _doubleTapGR.delegate = self;
    }
    return _doubleTapGR;
}

@end
