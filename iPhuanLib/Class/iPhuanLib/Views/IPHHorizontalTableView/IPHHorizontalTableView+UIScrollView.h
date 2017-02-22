//
//  IPHHorizontalTableView+UIScrollView.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/22.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHHorizontalTableView.h"

typedef struct IPHEdgeInsets {
    CGFloat left, right;
} IPHEdgeInsets;

UIKIT_STATIC_INLINE IPHEdgeInsets IPHEdgeInsetsMake(CGFloat left, CGFloat right) {
    IPHEdgeInsets insets = {left, right};
    return insets;
}

@interface IPHHorizontalTableView (UIScrollView)

@property (nonatomic) CGFloat contentOffsetX; // 设置横向的contentOffset
@property (nonatomic) CGFloat contentSizeWidth; // 设置横向滚动的contentSize
@property (nonatomic) IPHEdgeInsets contentInset; // 设置横向的左右和右边的contentInset
@property (nonatomic) BOOL bounces;
@property (nonatomic, getter = isPagingEnabled) BOOL pagingEnabled;
@property (nonatomic, getter = isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic) CGFloat decelerationRate;
@property (nonatomic, readonly, getter = isTracking) BOOL tracking;
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;


- (void)setContentOffsetX:(CGFloat)contentOffsetX animated:(BOOL)animated;
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;


@end

@protocol IPHScrollViewDelegate<NSObject>

@optional

- (void)horizontalTableViewDidScroll:(IPHHorizontalTableView *)tableView;
- (void)horizontalTableViewWillBeginDragging:(IPHHorizontalTableView *)tableView;
- (void)horizontalTableViewWillEndDragging:(IPHHorizontalTableView *)tableView withVelocity:(CGPoint)velocity targetContentOffsetX:(inout CGFloat *)targetContentOffsetX;
- (void)horizontalTableViewDidEndDragging:(IPHHorizontalTableView *)tableView willDecelerate:(BOOL)decelerate;
- (void)horizontalTableViewWillBeginDecelerating:(IPHHorizontalTableView *)tableView;
- (void)horizontalTableViewDidEndDecelerating:(IPHHorizontalTableView *)tableView;
- (void)horizontalTableViewDidEndScrollingAnimation:(IPHHorizontalTableView *)tableView;
- (BOOL)horizontalTableViewShouldScrollToTop:(IPHHorizontalTableView *)tableView;
- (void)horizontalTableViewDidScrollToTop:(IPHHorizontalTableView *)tableView;

@end
