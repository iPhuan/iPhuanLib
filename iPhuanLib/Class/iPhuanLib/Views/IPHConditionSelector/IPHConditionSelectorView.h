//
//  IPHConditionSelectorView.h
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/26.
//  Copyright © 2016年 iPhuan. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@class IPHConditionSelectorView;
@protocol IPHConditionProtocol;

@protocol IPHConditionSelectorViewDataSource<NSObject>

@required
// 条件分类
- (NSInteger)numberOfSectionsInConditionSelectorView:(IPHConditionSelectorView *)selectorView;

// 分类标题
- (nullable NSString *)conditionSelectorView:(IPHConditionSelectorView *)selectorView titleForHeaderInSection:(NSInteger)section;

// 要展示的条件
- (nullable NSArray<id <IPHConditionProtocol>> *)conditionSelectorView:(IPHConditionSelectorView *)selectorView conditionsInSection:(NSInteger)section;

@optional

// 该类型里面的条件是否可支持多选
- (BOOL)conditionSelectorView:(IPHConditionSelectorView *)selectorView canMultiSelectInSection:(NSInteger)section; // Default is NO

// 默认选中的条件
- (nullable id <IPHConditionProtocol>)conditionSelectorView:(IPHConditionSelectorView *)selectorView defaultConditionSelectInSection:(NSInteger)section; // Default is first Condition


@end

@protocol IPHConditionSelectorViewDelegate<NSObject>

@optional

// 选中的条件，Sections的数量即为conditions元素的数量，conditions里面的元素为选中的条件数组
- (void)conditionSelectorView :(IPHConditionSelectorView *)selectorView didSelectConditions:(NSArray<NSArray<id <IPHConditionProtocol>> *> *)conditions;

@end


@interface IPHConditionSelectorView : UIView

@property (nonatomic, weak, nullable) IBOutlet id <IPHConditionSelectorViewDataSource> dataSource;
@property (nonatomic, weak, nullable) IBOutlet id <IPHConditionSelectorViewDelegate> delegate;
@property (nonatomic, readonly, weak) NSArray<NSArray<id <IPHConditionProtocol>> *> *allSelectedConditions; // 所有选中的条件
@property (nonatomic, strong) UIColor *headerTitleColor; // 分类标题的颜色
@property (nonatomic, strong) UIColor *buttonNormalColor; // 条件按钮未选中状态的颜色
@property (nonatomic, strong) UIColor *buttonSelectedColor; // 条件按钮选中状态的颜色

- (void)show; // 弹出条件选择器

@end


NS_ASSUME_NONNULL_END
