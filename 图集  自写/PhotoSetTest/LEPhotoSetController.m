//
//  LEPhotoSetController.m
//  LESports
//
//  Created by 金玉龙 on 15/12/11.
//  Copyright © 2015年 LETV. All rights reserved.
//

#import "LEPhotoSetController.h"
#import "LEPhotoView.h"
#import "LEPhotoSetNavView.h"
#import "News.h"
#import "PhotoSet.h"
#import "Photos.h"

@interface LEPhotoSetController()<UIScrollViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) LEPhotoSetNavView *navigationView;
@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, strong) UITextView *photoTextView;
@property (nonatomic, strong) UILabel *photoTitleLabel;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) LEPhotoView *currentPhotoView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGR;
@property (nonatomic, strong) News *news;

@property (nonatomic, assign) BOOL isLoginState;
@property (nonatomic, assign) BOOL isHiddenCompnents;
@property (nonatomic, copy) NSString *currentCommentId;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *photoViewArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) PhotoSet *photoSet;

@end

@implementation LEPhotoSetController

- (id)initWithNewsId:(NSString *)setId
{
    if (self = [super init]) {
        self.setId = setId;
    }
    return self;
}
#pragma mark - Life Cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:self.isHiddenCompnents withAnimation:YES];
    [UIApplication sharedApplication].statusBarHidden = self.isHiddenCompnents;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self initCompnent];
    [self layoutCompnent];
    [self requestData];

    self.isHiddenCompnents = NO;
}

-(void)dealloc{
    NSLog(@"LEPhotoSetController Dealloc");
}

#pragma  mark - Private Method
//初始化控件
- (void)initCompnent{
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.photoScrollView];
    [self.photoScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];//当划返手势失效时执行scrollView的滑动手势
    [self.view addSubview:self.photoTitleLabel];
    [self.view addSubview:self.pageLabel];
    [self.view addSubview:self.photoTextView];
}
//约束图集控件
- (void)layoutCompnent{
    WS(weakSelf)
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(@64);
    }];
    [_photoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(_navigationView.mas_bottom);
    }];
    CGSize titleSize = [@"标题" sizeWithAttributes:@{NSFontAttributeName : kFont(10) }];
    [_photoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(5);
        make.top.equalTo(_photoScrollView.mas_bottom).offset(10);
        make.right.equalTo(_pageLabel.mas_left).offset(-50);
        make.height.mas_equalTo(titleSize.height);
    }];
    [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerY.height.equalTo(_photoTitleLabel);
        make.left.equalTo(_photoTitleLabel.mas_right).offset(50);
        make.right.equalTo(weakSelf.view);
        make.width.mas_equalTo(50);
    }];
    [_photoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photoTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(100);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-10);
    }];
}
//加载图集
- (void)loadPhotoSet{
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    [self.photoScrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_photoScrollView);
        make.height.equalTo(_photoScrollView);
    }];
//    创建PhotoView
    if ([self.photosArray isKindOfClass:[NSArray class]] && self.photosArray.count >0) {
        self.photoScrollView.contentSize = CGSizeMake( kScreenWidth * self.photosArray.count,self.photoScrollView.frame.size.width);
        for (Photos *photoModel in self.photosArray) {
            LEPhotoView *photoView = [LEPhotoView new];
            photoView.delegate = self;
            [self.singleTapGR requireGestureRecognizerToFail:photoView.doubleTapGR];
            [contentView addSubview:photoView];
            [self.photoViewArray addObject:photoView];
        }
    }
//    约束每个PhotoView
    if (self.photoViewArray.count >0) {
        LEPhotoView *lastPhotoView = nil;
        for (LEPhotoView *photoView in self.photoViewArray) {
            [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(contentView);
                make.width.equalTo(_photoScrollView.mas_width);
            }];
            if (lastPhotoView == nil) {
                [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(contentView);
                }];
            }else{
                [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastPhotoView.mas_right);
                }];
            }
            lastPhotoView = photoView;
        }
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastPhotoView.mas_right);
        }];
    }
    [self.photoScrollView layoutIfNeeded];
    
    self.currentIndex = 0;
    [self initFirstPhotoView];
    [self preUpdatePhotoViewImage];
    [self updatePageNum];
}
//initPhotoView
- (void)initFirstPhotoView{
    if ([self.photosArray isKindOfClass:[NSArray class]] && self.photosArray.count >0){
        Photos *photoModel  = self.photosArray[0];
        LEPhotoView *photoView = self.photoViewArray[0];
        
        [photoView updateImageViewWithimageUrlStr:photoModel.imgurl];
        self.currentPhotoView = photoView;
        self.photoTextView.text = photoModel.note;
        self.photoTitleLabel.text = self.photoSet.setname;
    }
}

//根据当前浏览页计算页码
- (void)updatePageNum{
    NSString *totalNum = [NSString stringWithFormat:@"%ld",(unsigned long)self.photosArray.count];
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)self.currentIndex +1];
    NSString *pageStr = [pageNum stringByAppendingString:[@"/" stringByAppendingString:totalNum]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:pageStr];

    [string setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName :[UIColor grayColor]} range:NSMakeRange(0, pageNum.length)];
    [string setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(pageNum.length, totalNum.length + 1)];
    self.pageLabel.attributedText = string;
}
//预加载图集图片View中的图片,只有在需要时加载
- (void)preUpdatePhotoViewImage{
    NSInteger preIndex = self.currentIndex +1;
    if (self.photoViewArray && self.photoViewArray.count > preIndex && self.photosArray.count > preIndex) {
        LEPhotoView *photoView = (LEPhotoView*)self.photoViewArray[preIndex];//下一张
        Photos *photoModel = self.photosArray[preIndex];
        [photoView updateImageViewWithimageUrlStr:photoModel.imgurl];
    }
}
//重置当前屏幕PhotoView两边的PhotoView的缩放比例
- (void)resetPhotoViewZoomScale{
    for (LEPhotoView *photoView in self.photoViewArray) {
        if ([self.currentPhotoView isEqual:photoView]) {
            NSInteger preIndex = [self.photoViewArray indexOfObject:photoView] + 1;
            if (self.photoViewArray && self.photoViewArray.count > preIndex) {
                LEPhotoView *photoView = (LEPhotoView*)self.photoViewArray[preIndex];//当前
                if (photoView.isZoomed) {
                    [photoView resetZoomScale];
                }
            }
            NSInteger lastIndex = [self.photoViewArray indexOfObject:photoView] - 1;//上一张
            if (self.photoViewArray && self.photoViewArray.count > lastIndex &&  lastIndex >= 0) {
                LEPhotoView *photoView = (LEPhotoView*)self.photoViewArray[lastIndex];
                if (photoView.isZoomed) {
                    [photoView resetZoomScale];
                }
            }
        }
    }
}
//设置划返手势
- (void)enablePopGesture{
    if (self.currentIndex == 0) {//只有在第一张图片允许手势pop
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)requestData
{
    WS(weakSelf)
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.photoScrollView animated:YES];
    NSString *preUrlStr = @"http://c.3g.163.com/photo/api/set/0003/";
    NSString *urlStr = [preUrlStr stringByAppendingString:[self.setId stringByAppendingString:@".json"]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",urlStr);
        if (data != nil) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
                [hud setHidden:YES];
                self.photoSet = [PhotoSet photoSetWithDictionary:dataDic];
                self.photosArray = self.photoSet.photosArray;
            }
        }
        //        NSLog(@"%@",self.dataArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf loadPhotoSet];
        });
    }];
    [task resume];
}
#pragma mark - Action
//分享
- (void)shareClick{

}
//返回
- (void)popController{
    [self.navigationController popViewControllerAnimated:YES];
}
//收藏
- (void)collectionClick{
    
}
//下载
- (void)downloadClick{
    if (self.currentIndex  < self.photoViewArray.count) {
        LEPhotoView *photoView = self.photoViewArray[_currentIndex];
        UIImageWriteToSavedPhotosAlbum(photoView.photoView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
//保存相册回调方法
-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if(!error){
//        保存成功
    }else{
        if (error.code == -3310) {
            //请在在设置中允许保存至相册"
        }else{
            //保存失败,请重试
        }
    }
}
//单击进入浏览模式,隐藏多余控件
- (void)hideCompnent{
    WS(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:!weakSelf.isHiddenCompnents withAnimation:YES];
        [weakSelf.navigationView setAlpha:weakSelf.isHiddenCompnents];
        [weakSelf.photoTitleLabel setAlpha:weakSelf.isHiddenCompnents];
        [weakSelf.pageLabel setAlpha:weakSelf.isHiddenCompnents];
        [weakSelf.photoTextView setAlpha:weakSelf.isHiddenCompnents];
    }];
    self.isHiddenCompnents = !_isHiddenCompnents;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentIndex = (int)(self.photoScrollView.contentOffset.x + 10)/ kScreenWidth;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updatePageNum];
    [self enablePopGesture];
    [self.photoTextView setContentOffset:CGPointMake(0,0) animated:NO];

    if (self.photoViewArray && self.currentIndex < self.photoViewArray.count) {
        self.currentPhotoView = self.photoViewArray[self.currentIndex];
        Photos *model =self.photosArray[self.currentIndex];
        self.photoTextView.text = model.note;
        self.photoTitleLabel.text = self.photoSet.setname;
    }
}

//缩放view
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[LEPhotoView class]]) {
        LEPhotoView *photoView = (LEPhotoView*)scrollView;
        return photoView.photoView;
    }
    else return nil;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[LEPhotoView class]]) {
        LEPhotoView *photoView = (LEPhotoView*)scrollView;
        if(photoView.zoomScale != 1){
            photoView.isZoomed = YES;
        }else{
            photoView.isZoomed = NO;
        }
    }
}

#pragma mark - Setter And Getter
-(UIView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [LEPhotoSetNavView new];
        _navigationView.backgroundColor = [UIColor clearColor];
        [_navigationView.backButton addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView.shareButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView.collectionButton addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView.downloadButton addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationView;
}

-(UIScrollView *)photoScrollView{
    if (_photoScrollView == nil) {
        _photoScrollView = [[UIScrollView alloc] init];
        _photoScrollView.delegate = self;
        _photoScrollView.pagingEnabled = YES;
        _photoScrollView.bounces = NO;
        _photoScrollView.bouncesZoom = YES;
        _photoScrollView.showsVerticalScrollIndicator = NO;
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.backgroundColor = [UIColor clearColor];
        
        self.singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCompnent)];
        self.singleTapGR.numberOfTapsRequired = 1;
        [_photoScrollView addGestureRecognizer:self.singleTapGR];
    }
    return _photoScrollView;
}

-(UILabel *)photoTitleLabel{
    if (_photoTitleLabel == nil) {
        _photoTitleLabel = [UILabel new];
        _photoTitleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        _photoTitleLabel.backgroundColor = [UIColor clearColor];
        _photoTitleLabel.textColor = [UIColor whiteColor];
        _photoTitleLabel.font = kFont(10);
        _photoTitleLabel.text = @"数据加载中......";
    }
    return _photoTitleLabel;
}

-(UILabel *)pageLabel{
    if (_pageLabel == nil) {
        _pageLabel = [UILabel new];
        _pageLabel.backgroundColor = [UIColor clearColor];
        _pageLabel.lineBreakMode = NSLineBreakByClipping;
    }
    return _pageLabel;
}

-(UITextView *)photoTextView{
    if (_photoTextView == nil) {
        _photoTextView = [UITextView new];
        _photoTextView.backgroundColor = [UIColor clearColor];
        _photoTextView.textColor = [UIColor whiteColor];
        _photoTextView.editable = NO;
        _photoTextView.selectable = NO;
        _photoTextView.text = @"数据加载中......";
    }
    return _photoTextView;
}

-(NSMutableArray *)photosArray{
    if (_photosArray == nil) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

-(NSMutableArray *)photoViewArray{
    if (_photoViewArray == nil) {
        _photoViewArray = [[NSMutableArray alloc] init];
    }
    return _photoViewArray;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self preUpdatePhotoViewImage];
    }
}

- (void)setCurrentPhotoView:(LEPhotoView *)currentPhotoView{
    if (_currentPhotoView != currentPhotoView) {
        _currentPhotoView = currentPhotoView;
        [self resetPhotoViewZoomScale];
    }
}
#pragma mark - UIViewControllerRotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
