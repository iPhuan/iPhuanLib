//
//  UIView+IPHAdditions.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (IPHGeometry)

@property (nonatomic) CGFloat left_iph;
@property (nonatomic) CGFloat top_iph;
@property (nonatomic) CGFloat right_iph;
@property (nonatomic) CGFloat bottom_iph;

@property (nonatomic) CGFloat width_iph;
@property (nonatomic) CGFloat height_iph;

@property (nonatomic) CGFloat centerX_iph;
@property (nonatomic) CGFloat centerY_iph;

@property (nonatomic) CGPoint origin_iph;
@property (nonatomic) CGSize size_iph;

@end


@interface UIView (IPHAdditions)

// 从默认xib文件中加载初始化
+ (id)iph_loadFromNib;

- (void)iph_removeAllSubviews;

@end


