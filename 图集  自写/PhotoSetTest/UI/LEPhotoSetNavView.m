//
//  LEPhotoSetNavView.m
//  LESports
//
//  Created by 金玉龙 on 15/12/13.
//  Copyright © 2015年 LETV. All rights reserved.
//

#import "LEPhotoSetNavView.h"
#import "Masonry.h"
#define WS(weakSelf) __weak typeof(&*self) weakSelf = self;
@interface LEPhotoSetNavView()

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UILabel *navTitleLabel;

@end
@implementation LEPhotoSetNavView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCompnent];
        [self layoutCompnent];
    }
    return self;
}

- (void)initCompnent{
    [self addSubview:self.navigationBarView];
    [self.navigationBarView addSubview:self.navTitleLabel];
    [self.navigationBarView addSubview:self.backButton];
    [self.navigationBarView addSubview:self.shareButton];
    [self.navigationBarView addSubview:self.collectionButton];
    [self.navigationBarView addSubview:self.downloadButton];
}

- (void)layoutCompnent{
    WS(weakSelf)
    CGSize titleSize = [@"图集详情" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:29]}];
    [_navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.height.equalTo(@44);
    }];
    [_navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.height.equalTo(_navigationBarView);
        make.width.mas_equalTo(titleSize.width);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navigationBarView);
        make.left.equalTo(_navigationBarView).offset(15);
    }];
    [_downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navigationBarView);
        make.left.equalTo(_navTitleLabel.mas_right).offset(5);
        make.width.equalTo(_collectionButton);
    }];
    [_collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navigationBarView);
        make.left.equalTo(_downloadButton.mas_right).offset(5);
        make.width.equalTo(_shareButton);
    }];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navigationBarView);
        make.left.equalTo(_collectionButton.mas_right).offset(5);
        make.right.equalTo(_navigationBarView).offset(-10);
        make.width.equalTo(_downloadButton);
    }];
}

#pragma mark - Getter

-(UIView *)navigationBarView{
    if (_navigationBarView == nil) {
        _navigationBarView = [UIView new];
        _navigationBarView.backgroundColor = [UIColor clearColor];
    }
    return _navigationBarView;
}

-(UILabel *)navTitleLabel{
    if (_navTitleLabel == nil) {
        _navTitleLabel = [UILabel new];
        _navTitleLabel.text = @"新闻图集";
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.textColor = [UIColor whiteColor];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitleLabel;
}

-(UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"back" forState:UIControlStateNormal];
        _backButton.titleLabel.font = kFont(15);
    }
    return _backButton;
}

-(UIButton *)shareButton{
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"share" forState:UIControlStateNormal];
        _shareButton.titleLabel.font = kFont(7);
    }
    return _shareButton;
}

-(UIButton *)downloadButton{
    if (_downloadButton == nil) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadButton setTitle:@"download" forState:UIControlStateNormal];
        _downloadButton.titleLabel.font = kFont(7);
    }
    return _downloadButton;
}

-(UIButton *)collectionButton{
    if (_collectionButton == nil) {
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setTitle:@"collect" forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = kFont(7);
    }
    return _collectionButton;
}
@end
