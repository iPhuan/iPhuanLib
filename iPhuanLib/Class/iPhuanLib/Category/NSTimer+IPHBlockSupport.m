//
//  NSTimer+IPHBlockSupport.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "NSTimer+IPHBlockSupport.h"

@implementation NSTimer (IPHBlockSupport)

+ (NSTimer *)iph_scheduledTimerWithTimeInterval:(NSTimeInterval)ti usingBlock:(void(^)())block repeats:(BOOL)yesOrNo{
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(p_blockInvoke:) userInfo:[block copy] repeats:yesOrNo];
}


+ (void)p_blockInvoke:(NSTimer *)timer {
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}



@end
