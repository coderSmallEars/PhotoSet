//
//  LEPhotoSetCell.m
//  LESports
//
//  Created by 金玉龙 on 15/12/11.
//  Copyright © 2015年 LETV. All rights reserved.
//
#import "LEPhotoSetCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface LEPhotoSetCell()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation LEPhotoSetCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.717 alpha:1.000];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initComponent];
        [self layoutComponent];
    }
    return  self;
}

- (void)initComponent{
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.tagImageView];
    [self.bgView addSubview:self.leftImageView];
    [self.bgView addSubview:self.middleImageView];
    [self.bgView addSubview:self.rightImageView];
}
//totalHeight  298
- (void)layoutComponent{
    __weak typeof(self)weakSelf = self;
    float bgEdge = 10;
    UIImage *image ;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(bgEdge, bgEdge, 0, bgEdge));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(7);
        make.right.equalTo(_tagImageView.mas_left).offset(-5);
        make.top.equalTo(_bgView).offset(7);
        make.bottom.equalTo(_timeLabel.mas_top).offset(-7);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(7);
        make.bottom.equalTo(_leftImageView.mas_top).offset(-10);
    }];
    [_tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView).offset(-8);
        make.centerY.equalTo(_titleLabel);
        make.size.mas_equalTo(image.size);
    }];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.left.equalTo(_bgView).offset(7);
        make.right.equalTo(_middleImageView.mas_left).offset(-5);
        make.bottom.equalTo(_bgView).offset(-10);
        make.width.equalTo(_middleImageView.mas_width);
        make.height.mas_equalTo(83);
    }];
    [_middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.bottom.equalTo(_leftImageView);
        make.left.equalTo(_leftImageView.mas_right).offset(5);
        make.right.equalTo(_rightImageView.mas_left).offset(-5);
    }];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(_middleImageView);
        make.left.equalTo(_middleImageView.mas_right).offset(5);
        make.right.equalTo(_bgView).offset(-7);
    }];
}

- (void)refreshNewsSelfContent:(News *)newsModel{
    _titleLabel.text = newsModel.setname;
    _timeLabel.text = newsModel.createdate;
    if (newsModel.pics && [newsModel.pics isKindOfClass:[NSArray class]]) {
        for (NSString *picUrl in newsModel.pics) {
            if (picUrl && [picUrl isKindOfClass:[NSString class]]) {
                switch ([newsModel.pics indexOfObject:picUrl]) {
                    case 0:
                        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
                        break;
                    case 1:
                        [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
                        break;
                    case 2:
                        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

#pragma mark - Setter And Getter
-(UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 2;
        _bgView.layer.borderColor = [UIColor blackColor].CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"黑白系科比,如今的独行太孤独.黑白系科比,如今的独行太孤独.黑白系科比,如今的独行太孤独.黑白系科比,如今的独行太孤独.";
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:8];
        _timeLabel.text = @"xx月xx日  xx时xx分";
        _timeLabel.backgroundColor = [UIColor clearColor];
    }
    return _timeLabel;
}

-(UIImageView *)tagImageView{
    if (_tagImageView == nil) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}

-(UIImageView *)leftImageView{
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"224x168"]];
    }
    return _leftImageView;
}

-(UIImageView *)middleImageView{
    if (_middleImageView == nil) {
        _middleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"224x168"]];
    }
    return _middleImageView;
}

-(UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"224x168"]];
    }
    return _rightImageView;
}

- (NSString *)formatterDateString:(NSString *)dateString
                    fromFormatter:(NSString *)fromeStyle
                      toFormatter:(NSString *)toStyle{
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:fromeStyle];
    [dateformatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate *date = [dateformatter dateFromString:dateString];
    
    dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:toStyle];
    [dateformatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *dateStr=[dateformatter stringFromDate:date];
    
    return dateStr;
    
}

@end
