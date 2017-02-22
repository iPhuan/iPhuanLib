//
//  HorizontalTableView.h
//  iPhuanLib
//
//  Created by iPhuan on 13-1-5.
//  Modified by iPhuan on 2017/2/22.
//  Copyright (c) 2013年 iPhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IPHHorizontalTableView;
@protocol IPHScrollViewDelegate;
@protocol IPHHorizontalTableViewDataSource;

@protocol IPHHorizontalTableViewDelegate <NSObject, IPHScrollViewDelegate>

@optional


- (void)horizontalTableView:(IPHHorizontalTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)horizontalTableView:(IPHHorizontalTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)horizontalTableView:(IPHHorizontalTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath;// 返回cell的宽度，对应于tableView:tableView的heightForRowAtIndexPath:方法


- (void)horizontalTableView:(IPHHorizontalTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)horizontalTableView:(IPHHorizontalTableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;


- (BOOL)horizontalTableView:(IPHHorizontalTableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)horizontalTableView:(IPHHorizontalTableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)horizontalTableView:(IPHHorizontalTableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;


- (nullable NSIndexPath *)horizontalTableView:(IPHHorizontalTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSIndexPath *)horizontalTableView:(IPHHorizontalTableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end



typedef NS_ENUM(NSInteger, IPHHorizontalTableViewScrollPosition) {
    IPHHorizontalTableViewScrollPositionNone = UITableViewScrollPositionNone,
    IPHHorizontalTableViewScrollPositionLeft = UITableViewScrollPositionTop,
    IPHHorizontalTableViewScrollPositionMiddle = UITableViewScrollPositionMiddle,
    IPHHorizontalTableViewScrollPositionRight = UITableViewScrollPositionBottom
};

@interface IPHHorizontalTableView : UIView

@property (nonatomic, weak, nullable) IBOutlet id <IPHHorizontalTableViewDelegate> delegate;
@property (nonatomic, weak, nullable) IBOutlet id <IPHHorizontalTableViewDataSource> dataSource;
@property (nonatomic) CGFloat cellWidth; // cell的宽度，对应于UITableView的rowHeight
@property (nonatomic, strong, nullable) UIView *backgroundView;

- (void)reloadData;

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath; // 返回横向显示的rect
- (nullable NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;
- (nullable NSArray<NSIndexPath *> *)indexPathsForRowsInRect:(CGRect)rect; // rect为基于横向的rect
- (nullable __kindof UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, readonly) NSArray<__kindof UITableViewCell *> *visibleCells;
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleRows;


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(IPHHorizontalTableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToNearestSelectedRowAtScrollPosition:(IPHHorizontalTableViewScrollPosition)scrollPosition animated:(BOOL)animated;


@property (nonatomic) BOOL allowsSelection;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic, readonly, nullable) NSIndexPath *indexPathForSelectedRow;
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForSelectedRows;

- (void)selectRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(IPHHorizontalTableViewScrollPosition)scrollPosition;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;


@property (nonatomic) UITableViewCellSeparatorStyle separatorStyle; // 默认为UITableViewCellSeparatorStyleNone
@property (nonatomic, strong, nullable) UIColor *separatorColor;
@property (nonatomic, strong, nullable) UIView *tableHeaderView; // 位于左边的headerView
@property (nonatomic, strong, nullable) UIView *tableFooterView; // 位于右边的footerView


- (nullable __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;


@end


@protocol IPHHorizontalTableViewDataSource<NSObject>

@required

- (NSInteger)numberOfRowsInHorizontalTableView:(IPHHorizontalTableView *)tableView;
- (UITableViewCell *)horizontalTableView:(IPHHorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END


