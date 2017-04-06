//
//  IPHHorizontalTableViewController.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/3/30.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHHorizontalTableViewController.h"
#import "IPHHorizontalTableView+UIScrollView.h"
#import "IPHHorizontalTableViewCell.h"


static NSString * const kIPHHorizontalTableViewCellIdentifier = @"IPHHorizontalTableViewCell";


@interface IPHHorizontalTableViewController () <IPHHorizontalTableViewDelegate, IPHHorizontalTableViewDataSource>
@property (weak, nonatomic) IBOutlet IPHHorizontalTableView *horizontalTableView;

@end

@implementation IPHHorizontalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IPHHorizontalTableViewDemo";

    UINib *nib = [UINib nibWithNibName:kIPHHorizontalTableViewCellIdentifier bundle:nil];
    [_horizontalTableView registerNib:nib forCellReuseIdentifier:kIPHHorizontalTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IPHHorizontalTableViewDataSource

- (NSInteger)numberOfRowsInHorizontalTableView:(IPHHorizontalTableView *)tableView{
    _horizontalTableView.contentInset = IPHEdgeInsetsMake(5, 5);
    
    return 10;
}

- (UITableViewCell *)horizontalTableView:(IPHHorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IPHHorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIPHHorizontalTableViewCellIdentifier forIndexPath:indexPath];
    cell.indexLabel.text = [@(indexPath.row) stringValue];
    
    return cell;
}


#pragma mark - IPHHorizontalTableViewDelegate

- (CGFloat)horizontalTableView:(IPHHorizontalTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}

- (void)horizontalTableView:(IPHHorizontalTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_horizontalTableView scrollToRowAtIndexPath:indexPath atScrollPosition:IPHHorizontalTableViewScrollPositionMiddle animated:YES];
}



@end
