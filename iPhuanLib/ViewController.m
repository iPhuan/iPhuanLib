//
//  ViewController.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertController+IPHAdditions.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *demoTitles;
@property (nonatomic, strong) NSArray *pushViewControllerNames;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iPhuanLib";
    self.demoTitles = @[@"IPHBaseModel",
                        @"IPHHorizontalTableView",
                        @"IPHConditionSelectorView",
                        @"IPHLocationManager"];
    
    self.pushViewControllerNames = @[@"IPHBaseModelViewController",
                                     @"IPHHorizontalTableViewController",
                                     @"IPHConditionSelectorViewController",
                                     @"IPHLocationManagerViewController"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demoTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iPhuanLibDemoCell" forIndexPath:indexPath];
    cell.textLabel.text = _demoTitles[indexPath.row];
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *viewControllerName = _pushViewControllerNames[indexPath.row];
    UIViewController *VC = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
    VC.title = [viewControllerName stringByReplacingOccurrencesOfString:@"ViewController" withString:@"Demo"];
    [self.navigationController pushViewController:VC animated:YES];
}


@end
