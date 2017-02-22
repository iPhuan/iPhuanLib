//
//  UIView+IPHAdditions.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "UIView+IPHAdditions.h"
#import "IPHViewNibUtils.h"


@implementation UIView (IPHGeometry)

- (CGFloat)left_iph {
    return self.frame.origin.x;
}

- (void)setLeft_iph:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}


- (CGFloat)top_iph {
    return self.frame.origin.y;
}

- (void)setTop_iph:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)right_iph {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight_iph:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)bottom_iph {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom_iph:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)centerX_iph {
    return self.center.x;
}

- (void)setCenterX_iph:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)centerY_iph {
    return self.center.y;
}

- (void)setCenterY_iph:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)width_iph {
    return self.frame.size.width;
}

- (void)setWidth_iph:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height_iph {
    return self.frame.size.height;
}

- (void)setHeight_iph:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGPoint)origin_iph {
    return self.frame.origin;
}

- (void)setOrigin_iph:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)size_iph {
    return self.frame.size;
}

- (void)setSize_iph:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end


@implementation UIView (IPHAdditions)

+ (id)iph_loadFromNib {
    return [IPHViewNibUtils loadViewFromNibNamed:NSStringFromClass([self class])];
}

- (void)iph_removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end


