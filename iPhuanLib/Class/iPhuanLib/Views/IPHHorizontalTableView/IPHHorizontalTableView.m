//
//  IPHHorizontalTableView.m
//  iPhuanLib
//
//  Created by iPhuan on 13-1-5.
//  Modified by iPhuan on 2017/2/22.
//  Copyright (c) 2013年 iPhuan. All rights reserved.
//


#import "IPHHorizontalTableView.h"
#import <objc/message.h>

static const CGFloat kIPHDefaultCellWidth = 80;
const char IPHTableView[] = "IPHTableView";

@interface IPHHorizontalTableView () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>{
    UITableView *_tableView;
}

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincomplete-implementation"

@implementation IPHHorizontalTableView

@dynamic backgroundView, visibleCells, indexPathsForVisibleRows, allowsSelection, allowsMultipleSelection, indexPathForSelectedRow, indexPathsForSelectedRows, tableHeaderView, tableFooterView;


- (instancetype)init{
    self = [super init];
    if (self) {
        [self p_setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_setup];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_tableView.superview == nil) {
        _tableView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
        _tableView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        [self addSubview:_tableView];
        
        // 需在此时设置才能生效
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
}

- (void)p_setup{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.directionalLockEnabled = YES;
    
    objc_setAssociatedObject(self, IPHTableView, _tableView, OBJC_ASSOCIATION_RETAIN);
}


- (void)dealloc{
    objc_removeAssociatedObjects(self);
}


// 为没有实现的方法添加Target
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _tableView;
}

#pragma mark - Set and Get

- (CGFloat)rowWidth{
    return _tableView.rowHeight;
}

- (void)setRowWidth:(CGFloat)rowWidth{
    _tableView.rowHeight = rowWidth;
}


- (void)setTableHeaderView:(UIView *)tableHeaderView {
    tableHeaderView.transform = CGAffineTransformMakeRotation(M_PI/2);
    tableHeaderView.frame = CGRectMake(0, 0, tableHeaderView.frame.size.width, tableHeaderView.frame.size.height);
    _tableView.tableHeaderView = tableHeaderView;
}

- (void)setTableFooterView:(UIView *)tableFooterView {
    tableFooterView.transform = CGAffineTransformMakeRotation(M_PI/2);
    tableFooterView.frame = CGRectMake(0, 0, tableFooterView.frame.size.width, tableFooterView.frame.size.height);
    _tableView.tableFooterView = tableFooterView;
}

#pragma mark - Public

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [_tableView rectForRowAtIndexPath:indexPath];
    return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
}

- (nullable NSArray<NSIndexPath *> *)indexPathsForRowsInRect:(CGRect)rect {
    return [_tableView indexPathsForRowsInRect:CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width)];
}

#pragma mark - Private

- (BOOL)p_delegateRespondsToSelector:(SEL)selector {
    return (_delegate && [_delegate respondsToSelector:selector]);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfRowsInHorizontalTableView:)]) {
        return [_dataSource numberOfRowsInHorizontalTableView:self];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(horizontalTableView:cellForRowAtIndexPath:)]) {
        cell = [_dataSource horizontalTableView:self cellForRowAtIndexPath:indexPath];
    } else {
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:widthForRowAtIndexPath:)]) {
        return [_delegate horizontalTableView:self widthForRowAtIndexPath:indexPath];
    }
    
    if (_tableView.rowHeight > 0) {
        return _tableView.rowHeight;
    }
    
    return kIPHDefaultCellWidth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:didSelectRowAtIndexPath:)]) {
         [_delegate horizontalTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:didDeselectRowAtIndexPath:)]) {
         [_delegate horizontalTableView:self didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:willDisplayCell:forRowAtIndexPath:)]) {
        [_delegate horizontalTableView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [_delegate horizontalTableView:self didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:shouldHighlightRowAtIndexPath:)]) {
        return [_delegate horizontalTableView:self shouldHighlightRowAtIndexPath:indexPath];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:didHighlightRowAtIndexPath:)]) {
        [_delegate horizontalTableView:self didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:didUnhighlightRowAtIndexPath:)]) {
        [_delegate horizontalTableView:self didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:willSelectRowAtIndexPath:)]) {
        return [_delegate horizontalTableView:self willSelectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self p_delegateRespondsToSelector:@selector(horizontalTableView:willDeselectRowAtIndexPath:)]) {
        return [_delegate horizontalTableView:self willDeselectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

@end

#pragma clang diagnostic pop

