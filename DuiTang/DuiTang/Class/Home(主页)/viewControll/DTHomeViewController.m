//
//  DTHomeViewController.m
//  DuiTang
//
//  Created by Monky on 16/3/7.
//  Copyright © 2016年 Monky. All rights reserved.
//

#import "DTHomeViewController.h"

#import "DTNetHelper.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "DTSmallTableViewCell.h"
#import "DTBigTableViewCell.h"
#import "DTHeadViewController.h"
#import "DTHomeWebController.h"
#import "DTWaterFlowController.h"


#import "DTHomeModel.h"
#import "DTBigModel.h"
#import "DTModelFrame.h"
#import "DTBigModelFrame.h"
#import "DTBaseFrame.h"

#import "DTWaterModel.h"
#import "DTWaterFrame.h"
@interface DTHomeViewController ()<UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic ,weak)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *headArray;

@end
/**
 *  2
 */


@implementation DTHomeViewController
-(NSMutableArray *)headArray{
    if (_headArray==nil) {
        _headArray=[NSMutableArray array];
    }
    return _headArray;
}


-(NSMutableArray *)dataArray
{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
       self.view.backgroundColor = [UIColor colorWithRed:0.480 green:0.758 blue:1.000 alpha:1.000];
    
    [self setupTableView];
    [self setupHeadView];
    [self setRefresh];
    

    
}
//配置刷新
-(void)setRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

//配置头部的滚动 视图

-(void)setupHeadView
{
    DTHeadViewController *hVc = [[DTHeadViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
   
    [self addChildViewController:hVc];
    self.tableView.tableHeaderView = hVc.view;
    
}
-(void)loadMoreData
{
   // NSLog(@"loadMoreData  loadMoreData");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}
-(void)loadData
{
    [self.headArray removeAllObjects];
    [self.dataArray removeAllObjects];
    NSString * urlStr = homeStr;
    [DTNetHelper getDataWithParam:nil andPath:urlStr andComplete:^(BOOL success, id result) {
        
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *arr = dataDict[@"object_list"];
            NSMutableArray * marr = [NSMutableArray array];
            for (NSDictionary * smallDict in arr) {
                if ([smallDict[@"style"] isEqualToString:@"large"]) {
                    DTBigModel * model = [DTBigModel mj_objectWithKeyValues:smallDict];
                    
                    DTBigModelFrame *bFrame = [[DTBigModelFrame alloc]init];
                    bFrame.model = model;
                    
                    [marr addObject:bFrame];
                }else
                {
                    DTHomeModel *hmodel = [DTHomeModel mj_objectWithKeyValues:smallDict];
                    DTModelFrame *sFrame = [[DTModelFrame alloc]init];
                    sFrame.model = hmodel;
                    [marr addObject:sFrame];
                }
            }
            [self.headArray addObject:marr[0]];
            [self.headArray addObject:marr[1]];
//             [self.headArray addObject:marr[2]];
            
            [marr removeObject:marr[0]];
            [marr removeObject:marr[0]];
//            [marr removeObject:marr[0]];
            DTHeadViewController *hVc = [self.childViewControllers firstObject];
            hVc.modelArray = self.headArray;
            
            
            [self.dataArray addObjectsFromArray:marr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });

        }
        
    }];
    
    
}

/**
 *  将模型转为Frame模型
 */
- (NSArray *)modelFramesWithStatuses:(NSArray *)modelArray
{
    NSMutableArray *frames = [NSMutableArray array];
    for (DTHomeModel *model in modelArray) {
       DTModelFrame *f = [[DTModelFrame alloc] init];
        f.model = model;
        [frames addObject:f];
    }
    return frames;
}
-(void)dealloc
{
    //NSLog(@" home             ");
}
-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];

//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    tableView.backgroundColor = [UIColor grayColor];
    
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = self.dataArray.count==0;
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTBaseFrame *model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:[DTBigModelFrame class]]) {
        
        DTBigTableViewCell *cell = [DTBigTableViewCell bigTableViewCellWithTableView:tableView];
        cell.model=(DTBigModelFrame *)model;
    }

   DTSmallTableViewCell *cell = [DTSmallTableViewCell smallTableViewCellWithTableView:tableView];
    cell.model = (DTModelFrame *)model;
    cell.backgroundColor =[UIColor whiteColor];
    //NSLog(@"%p",cell);
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTModelFrame *model = self.dataArray[indexPath.row];
    
    return model.maxHight ;
}



#pragma mark tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTBaseFrame*modelFrame = self.dataArray[indexPath.row];
    
    if ([modelFrame isKindOfClass:[DTBigModelFrame class]]) {
        DTBigModelFrame *modelF = (DTBigModelFrame *)modelFrame;
        DTBigModel *model = modelF.model;
        
        NSLog(@"big   big");
         NSString *str = [self stringWithSourceString:model.target];
        NSString *netStr = [NSString stringWithFormat:@"%@id=%@%@",bigStr1,str,bigStr2];
        
        DTHomeWebController *webVC = [[DTHomeWebController alloc]init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.urlStr = netStr;
       [self.navigationController pushViewController:webVC animated:YES];
    
        
        
        
    }else {
        DTModelFrame *modelF = (DTModelFrame *)modelFrame;
        DTHomeModel *model = modelF.model;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//从模型的target中截取字符串
    
    
    NSString *str = [self stringWithSourceString:model.target];
    
    
    NSString *waterStr = [NSString stringWithFormat:@"%@id=%@%@",str1,str,str3];
    
    DTWaterFlowController *water = [[DTWaterFlowController alloc]init];
        water.urlStr = waterStr;
        water.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:water animated:YES];
        
        }
    
}

//截取字符串
-(NSString *)stringWithSourceString:(NSString *)string
{
    NSRange range = [string rangeOfString:@"id"];
    NSString *str = [string substringFromIndex:range.location+range.length+1];
    
    NSLog(@"%@",str);
    return str;
}

@end
