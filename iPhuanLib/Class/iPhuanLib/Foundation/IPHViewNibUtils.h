//
//  IPHViewNibUtils.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPHViewNibUtils : NSObject

// the view must not have any connecting to the file owner
+ (nullable id)loadViewFromNibNamed:(NSString *)xibName;
+ (nullable id)loadViewFromNibNamed:(NSString *)name owner:(id)owner;

@end

NS_ASSUME_NONNULL_END
