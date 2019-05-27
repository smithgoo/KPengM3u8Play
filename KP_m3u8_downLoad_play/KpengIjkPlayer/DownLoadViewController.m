//
//  DownLoadViewController.m
//  KpengIjkPlayer
//
//  Created by 王朋 on 2019/5/9.
//  Copyright © 2019 王朋. All rights reserved.
//

#import "DownLoadViewController.h"
#import "DownLoadTableViewCell.h"
#import "KPm3u8DownLoad.h"
#define url1  @"https://hao.czybjz.com/20190116/dVt1wUdJ/index.m3u8"
#define url2 @"https://youku.com-okzy.com/20190511/288_9ca64f9f/index.m3u8"
#define url3 @"https://youku.com-okzy.com/20190511/288_9ca64f9f/index.m3u8"

@interface DownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic,strong) NSArray *urlArr;
@property (nonatomic,strong) NSArray *modelArr;

@end

@implementation DownLoadViewController
- (IBAction)dissMIss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableVIew.delegate =self;
    _tableVIew.dataSource =self;
    // Do any additional setup after loading the view from its nib.
    _urlArr =@[url1,url2,url3];
    
    DownLoadModel *dw =[DownLoadModel new];
    dw.title =@"1";
    dw.m3u8Url =url1;
    DownLoadModel *dw1 =[DownLoadModel new];
    dw1.title =@"2";
    dw1.m3u8Url =url2;
    DownLoadModel *dw2 =[DownLoadModel new];
    dw2.title =@"3";
    dw2.m3u8Url =url3;
    _modelArr =@[dw,dw1,dw2];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return  _urlArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownLoadTableViewCell *cell =[[NSBundle mainBundle] loadNibNamed:@"DownLoadTableViewCell" owner:self options:nil].lastObject;
    [cell bdingModel:_modelArr[indexPath.row]];
    return cell;
    
}




@end
