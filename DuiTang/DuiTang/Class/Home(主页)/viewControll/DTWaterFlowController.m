//
//  DTWaterFlowController.m
//  DuiTang
//
//  Created by 苏威 on 16/3/8.
//  Copyright © 2016年 Monky. All rights reserved.
//

#import "DTWaterFlowController.h"
#import "XMGWaterflowLayout.h"
#import "DTNetHelper.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "DTWaterFrame.h"
#import "DTWaterModel.h"
#import "DTWaterFlowCell.h"
#import "DTPhoto.h"

#import "DTDetailViewController.h"

@interface DTWaterFlowController ()<UICollectionViewDataSource,XMGWaterflowLayoutDelegate,UICollectionViewDelegate>
@property (nonatomic ,weak)UICollectionView *coll;
@property (nonatomic ,strong)NSMutableArray *modelArray;
@end

@implementation DTWaterFlowController
-(NSMutableArray *)modelArray{
    if (_modelArray==nil) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupColltionView];
    // Do any additional setup after loading the view.
    [self setupRefresh];
}

-(void)setupRefresh
{
    self.coll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.coll.mj_header beginRefreshing];
}

-(void)setupColltionView

{
    //配置collectionview
    XMGWaterflowLayout *layout = [[XMGWaterflowLayout alloc]init];
    layout.delegate = self;
   
    UICollectionView *coll = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    //coll.frame = self.view.frame;
    [self.view addSubview:coll];
   // coll.pagingEnabled = YES;
    coll.showsHorizontalScrollIndicator = NO;
    self.coll = coll;
    coll.backgroundColor = DTGlobalBg;
    coll.dataSource = self;
    coll.delegate = self ;
    
    
}


-(void)loadData
{
    [self.modelArray removeAllObjects];
    [DTNetHelper getDataWithParam:nil andPath:self.urlStr andComplete:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *arr = dataDict[@"object_list"];
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *smallDict in arr ) {
                DTWaterModel *model = [DTWaterModel mj_objectWithKeyValues:smallDict];
                DTWaterFrame *frameModel = [[DTWaterFrame alloc]init];
                frameModel.model = model;
                [marr addObject:frameModel];
                
            }
            [self.modelArray addObjectsFromArray:marr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.coll reloadData];
                [self.coll.mj_header endRefreshing];
            });
        }
        
        
    }];

    
}


#pragma  mark XMGWaterflowLayoutDelegate

-(CGFloat)waterflowLayout:(XMGWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth

{
    DTWaterFrame *model = self.modelArray [index];
        return model.maxHight;
}

- (CGFloat)columnCountInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout
{
    return maxColum;
    
}




#pragma mark datasourcedelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    DTWaterFrame *model = self.modelArray[indexPath.item];
    DTWaterFlowCell *cell = [DTWaterFlowCell waterFlowCellWithNibWithCollnectionView:collectionView andIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = model;
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DTWaterFrame *modelF = self.modelArray[indexPath.item];
    DTWaterModel *model = modelF.model;
    DTDetailViewController * detailVc = [[DTDetailViewController alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@id=%@%@",detailStr1,model.cid,detailStr2];
    
    detailVc.urlStr = urlStr;
    detailVc.hidesBottomBarWhenPushed = YES;
    NSLog(@"%@",urlStr);
    [self.navigationController pushViewController:detailVc animated:YES];
    
}
@end
