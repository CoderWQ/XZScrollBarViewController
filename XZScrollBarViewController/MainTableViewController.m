//
//  MainTableViewController.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/8.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainViewController.h"
@interface MainTableViewController ()

@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"下拉样式滚动条的Demo";
    
    NSArray *dataArray  = [NSArray arrayWithObjects:@"马上游",@"网易新闻",@"腾讯视频",@"xxx",@"等等等等", nil];
    self.dataArray = dataArray;
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierId = @"test";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierId];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
    
        MainViewController *mainVc = [[MainViewController alloc] init];
        [self.navigationController pushViewController:mainVc animated:YES];
//    }
}


@end
