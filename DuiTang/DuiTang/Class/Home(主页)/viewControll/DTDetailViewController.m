//
//  DTDetailViewController.m
//  DuiTang
//
//  Created by 苏威 on 16/3/9.
//  Copyright © 2016年 Monky. All rights reserved.
//

#import "DTDetailViewController.h"
#import "DTNetHelper.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#include "DTDetail.h"

@interface DTDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation DTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadData];
   
}
-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = self.view.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)loadData
{
    [DTNetHelper getDataWithParam:nil andPath:self.urlStr andComplete:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            DTDetail *detail = [DTDetail mj_objectWithKeyValues:dataDict];
            NSLog(@"%@",detail.sender.username);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
        }
        
        
    }];
    
}
#pragma mark UITableViewDataSource  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"茉莉花";
    return cell;
}


@end
