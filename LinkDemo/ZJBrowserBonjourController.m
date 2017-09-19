//
//  ZJBrowserBonjourController.m
//  LinkDemo
//
//  Created by 智鉴科技 on 2017/9/19.
//  Copyright © 2017年 com.bjzhijian.www. All rights reserved.
//

#import "ZJBrowserBonjourController.h"
#import "ZJBrowserBonjour.h"
#import "MJRefresh.h"
@interface ZJBrowserBonjourController ()<ZJBrowserBonjourDelegate>
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) ZJBrowserBonjour *bonjsour;
@end

@implementation ZJBrowserBonjourController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 80;
    
    self.bonjsour = [[ZJBrowserBonjour alloc] initWithDelegate:self];
    [self configRefresh];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)configRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}
-(void)refreshData
{
    [self.dataSourceArray removeAllObjects];
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationRight];
    [self.bonjsour startSearchForService];
}
#pragma mark - ZJBrowserBonjourDelegate
- (void)browserBonjour:(ZJBrowserBonjour *)browserBonjour
     didResolveAddress:(ZJBrowserDevice *)servicesData
{
    [self.tableView.mj_header endRefreshing];
    if (servicesData) {
        BOOL compareResult = YES;
        for (ZJBrowserDevice *temp in self.dataSourceArray) {
            if ([temp.deviceAddress isEqualToString:servicesData.deviceAddress])
            {
                compareResult = NO;
                break;
            }
        }
        if (compareResult)
        {
            [self.dataSourceArray addObject:servicesData];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSourceArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}
- (void)browserBonjour:(ZJBrowserBonjour *)browserBonjour
      didRemoveService:(ZJBrowserDevice *)servicesData
{
    
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
#pragma UITableViewDataSoure
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ID";
    ZJBrowserDevice *model = self.dataSourceArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = model.deviceAddress;
    cell.detailTextLabel.text = model.deviceName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataSourceArray;
}
@end
