//
//  ViewController.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertController+IPHAdditions.h"
#import "IPHBaseModelViewController.h"
#import "IPHHorizontalTableViewController.h"
#import "IPHConditionSelectorViewController.h"





@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *demoTitles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iPhuanLib";
    self.demoTitles = @[@"IPHBaseModel",
                        @"IPHHorizontalTableView",
                        @"IPHConditionSelectorView",
                        @"IPHLocationManager"];
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
    
    UIViewController *VC = nil;
    switch (indexPath.row) {
        case 0:{
            VC = [[IPHBaseModelViewController alloc] initWithNibName:@"IPHBaseModelViewController" bundle:nil];
            break;
        }
        case 1:{
            VC = [[IPHHorizontalTableViewController alloc] initWithNibName:@"IPHHorizontalTableViewController" bundle:nil];
            break;
        }
        case 2:{
            VC = [[IPHConditionSelectorViewController alloc] initWithNibName:@"IPHConditionSelectorViewController" bundle:nil];

            break;
        }
        case 3:{
            
            break;
        }
    }
    [self.navigationController pushViewController:VC animated:YES];
}


@end
