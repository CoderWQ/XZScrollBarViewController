//
//  JRTTViewController.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/11.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "JRTTViewController.h"
#import "ChildTableViewController.h"
@interface JRTTViewController ()

@end

@implementation JRTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"今日头条";
    
    [self setupChildViewController];
    
    

    
     

}


- (void)setupChildViewController{
    
    ChildTableViewController *childVc1 = [[ChildTableViewController alloc] init];
    childVc1.title = @"大家好";
    [self addChildViewController:childVc1];
    
    ChildTableViewController *childVc2 = [[ChildTableViewController alloc] init];
    childVc2.title = @"我";
    [self addChildViewController:childVc2];
    
    ChildTableViewController *childVc3 = [[ChildTableViewController alloc] init];
    childVc3.title = @"是";
    [self addChildViewController:childVc3];
    
    ChildTableViewController *childVc4 = [[ChildTableViewController alloc] init];
    childVc4.title = @"徐不同";
    [self addChildViewController:childVc4];
    
 
}

@end
