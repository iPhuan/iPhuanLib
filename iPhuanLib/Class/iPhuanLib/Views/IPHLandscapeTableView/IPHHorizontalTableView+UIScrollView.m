//
//  IPHHorizontalTableView+UIScrollView.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/22.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHHorizontalTableView+UIScrollView.h"
#import <objc/message.h>

@implementation IPHHorizontalTableView (UIScrollView)

@dynamic bounces, pagingEnabled, scrollEnabled, decelerationRate, tracking, dragging, decelerating;


- (UITableView *)tableView {
    static const char IPHTableView[] = "IPHTableView";
    UITableView *tableView = objc_getAssociatedObject(self, IPHTableView);
    return tableView;
}


#pragma mark - Set and Get

- (CGFloat)contentOffsetX{
    return [self tableView].contentOffset.y;
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX{
    [self tableView].contentOffset = CGPointMake(0, contentOffsetX);
}

- (CGFloat)contentSizeWidth{
    return [self tableView].contentSize.height;
}

- (void)setContentSizeWidth:(CGFloat)contentSizeWidth {
    [self tableView].contentSize = CGSizeMake([self tableView].contentSize.width, contentSizeWidth);
}

- (IPHEdgeInsets)contentInset {
    return IPHEdgeInsetsMake ([self tableView].contentInset.top, [self tableView].contentInset.bottom);
}

- (void)setContentInset:(IPHEdgeInsets)contentInset {
    [self tableView].contentInset = UIEdgeInsetsMake(contentInset.left, 0, contentInset.right, 0);
    self.contentOffsetX = -contentInset.left;
}



#pragma mark - Public

- (void)setContentOffsetX:(CGFloat)contentOffsetX animated:(BOOL)animated {
    [[self tableView] setContentOffset:CGPointMake(0, contentOffsetX) animated:animated];
}
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    [[self tableView] scrollRectToVisible:CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width) animated:animated];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self p_executeDelegate:@selector(horizontalTableViewDidScroll:)];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self p_executeDelegate:@selector(horizontalTableViewWillBeginDragging:)];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalTableViewWillEndDragging:withVelocity:targetContentOffsetX:)]) {
        CGFloat targetContentOffsetX;
        [self.delegate horizontalTableViewWillEndDragging:self withVelocity:velocity targetContentOffsetX:&targetContentOffsetX];
        *targetContentOffset = CGPointMake(0, targetContentOffsetX);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalTableViewDidEndDragging:willDecelerate:)]) {
        [self.delegate horizontalTableViewDidEndDragging:self willDecelerate:decelerate];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self p_executeDelegate:@selector(horizontalTableViewWillBeginDecelerating:)];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self p_executeDelegate:@selector(horizontalTableViewDidEndDecelerating:)];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self p_executeDelegate:@selector(horizontalTableViewDidEndScrollingAnimation:)];
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalTableViewShouldScrollToTop:)]) {
        return [self.delegate horizontalTableViewShouldScrollToTop:self];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self p_executeDelegate:@selector(horizontalTableViewDidScrollToTop:)];
}

- (void)p_executeDelegate:(SEL)selector {
    if (self.delegate && [self.delegate respondsToSelector:selector]) {
        ((void (*)(id, SEL, id))objc_msgSend)(self.delegate, selector, self);
    }
}




@end
