//
//  NSTimer+IPHBlockSupport.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (IPHBlockSupport)

+ (NSTimer *)iph_scheduledTimerWithTimeInterval:(NSTimeInterval)ti usingBlock:(void(^)())block repeats:(BOOL)yesOrNo;

@end
