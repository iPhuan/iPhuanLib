//
//  IPHViewNibUtils.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHViewNibUtils.h"
#import <UIKit/UINibLoading.h>


@implementation IPHViewNibUtils

+ (id)loadViewFromNibNamed:(NSString *)name {
    return [[self class] loadViewFromNibNamed:name owner:self];
}

+ (id)loadViewFromNibNamed:(NSString *)name owner:(id)owner {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:name owner:owner options:nil];
    if (array && array.count > 0) {
        return array[0];
    }else {
        return nil;
    }
}

@end
