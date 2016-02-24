//
//  MainViewController.m
//  PhotoSetTest
//
//  Created by 金玉龙 on 15/12/13.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import "MainViewController.h"
#import "LEPhotoSetCell.h"
#import "LEPhotoSetController.h"
#import "News.h"
#import "Masonry.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong)  NSMutableArray *dataArray;
@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad{
    self.title = @"图集";
    self.view.backgroundColor = [UIColor colorWithWhite:0.717 alpha:1.000];
    self.listTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
    __weak typeof(self)weakSelf = self;
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    self.dataArray = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)loadData{
    WS(weakSelf)
    NSString *urlStr = @"http://c.3g.163.com/photo/api/related/0096/84445.json";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",urlStr);
        if (data != nil) {
            NSArray *arrayData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (arrayData && [arrayData isKindOfClass:[NSArray class]] && arrayData.count) {
                for (int i = 0; i<arrayData.count; i++) {
                    NSDictionary *dataDic = arrayData[i];
                    if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
//                        NSLog(@"%@",dataDic);
                        News *new = [[News alloc] init];
                        [new setValuesForKeysWithDictionary:dataDic];
                        [weakSelf.dataArray addObject:new];
                    }
                }
                
            }
        }
//        NSLog(@"%@",self.dataArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.listTableView reloadData];
        });
    }];
    [task resume];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    LEPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[LEPhotoSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell refreshNewsSelfContent:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 149;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    News *news = self.dataArray [indexPath.row];
    LEPhotoSetController *psCtrl = [[LEPhotoSetController alloc] initWithNewsId:toString(news.setid) ];//    psCtrl.newsModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:psCtrl animated:YES];
}

@end
