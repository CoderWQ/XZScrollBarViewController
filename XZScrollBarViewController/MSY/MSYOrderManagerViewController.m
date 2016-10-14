//
//  MSYOrderManagerViewController.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/8.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "MSYOrderManagerViewController.h"
#import "AFNetWorking.h"
#import "XZTopic.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MSYRefreshHeaderView.h"
#import "MSYRefreshFooterView.h"
#import "XZTopicViewCell.h"
#import "XZVoiceCell.h"

@interface MSYOrderManagerViewController ()
/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray<XZTopic *> *topics;

/** 下拉刷新的提示文字 */
@property (nonatomic, weak) UILabel *label;
/** maxtime : 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;

/** 任务管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation MSYOrderManagerViewController

- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
 
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
 
    [self setupRefresh];
    
    
    // 要么分开弄
    [self.tableView registerClass:[XZVoiceCell class] forCellReuseIdentifier:@"XZVoiceCell"];
    // 要么就一个cell
    
    
}

- (void)setupRefresh
{
  

    
    self.tableView.mj_header = [MSYRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MSYRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
}

#pragma mark - 数据加载
- (void)loadNewTopics{
    
//
//    for (NSURLSessionTask *task in  self.manager.tasks) {
//        [task cancel];
//    }
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

 //
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // 存储maxtime(方便用来加载下一页数据)
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数组
        self.topics = [XZTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == NSURLErrorCancelled) {
            // 取消了任务
        }else{
            // 是其他错误
        }
//        XZLOG(@"请求失败 - %@", error);

        
        
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}
// 一个请求任务被取消了(cancel), 会自动调用AFN请求的failure这个block

-(void)loadMoreTopics{
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"maxtime"] = self.maxtime;
    
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 存储这页对应的maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数组
        NSArray<XZTopic *> *moreTopics = [XZTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        
        
        
        
        
 //        XZLOG(@"%@",);
//        XZLOG(@"请求失败 - %@", error);
        
          // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.topics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.确定重用标示:
    static NSString *ID = @"cell";
    
    // 2.从缓存池中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = XZRandomColor;
    }
    
    // 4.显示数据
    XZTopic *topic = self.topics[indexPath.row];
    cell.textLabel.text = topic.name;
    cell.detailTextLabel.text = topic.text;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    return cell;
    
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentInset.top == 149) return;
//
//    if (scrollView.contentOffset.y <= - 149.0) {
//        self.label.text = @"松开立即刷新";
//    } else {
//        self.label.text = @"下拉可以刷新";
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (scrollView.contentOffset.y <= - 149.0) { // 进入下拉刷新状态
//        self.label.text = @"正在刷新";
//        [UIView animateWithDuration:0.5 animations:^{
//            UIEdgeInsets inset = scrollView.contentInset;
//            inset.top = 149;
//            scrollView.contentInset = inset;
//        }];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.5 animations:^{
//                UIEdgeInsets inset = scrollView.contentInset;
//                inset.top = 99;
//                scrollView.contentInset = inset;
//            }];
//        });
//    }
//}
@end
