//
//  IPHConditionProtocol.h
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/29.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPHConditionProtocol <NSObject>

@property (nonatomic, copy) NSString *conditionId; //适用于条件数据不仅仅为标题，还包含ID
@property (nonatomic, copy) NSString *title; // 条件标题
@property (nonatomic, assign) BOOL isUnlimited; // 是否条件无限制，在实现上如果为多选状态，点击无限制的条件将清空所有其他选择的条件

@end

