//
//  IPHConditionSelectorView.m
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/26.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import "IPHConditionSelectorView.h"
#import "IPHConfirmCell.h"
#import "IPHConditionCell.h"
#import "IPHConditionProtocol.h"


static const NSTimeInterval kIPHAnimateDuration = 0.3;
static const NSInteger kIPHMaskViewTag = 1000;

static NSString * const kIPHConditionCellReuseIdentifier = @"IPHConditionCell";
static NSString * const kIPHConfirmCellReuseIdentifier = @"IPHConfirmCell";



@interface IPHConditionSelectorView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedConditions;
@property (nonatomic, assign) NSInteger numberOfConditionsSection;

@end

@implementation IPHConditionSelectorView

- (instancetype)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _numberOfConditionsSection = 0;
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
        [_tableView registerClass:[IPHConditionCell class] forCellReuseIdentifier:kIPHConditionCellReuseIdentifier];
        
        BOOL isConfirmCellXibExist = [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:kIPHConfirmCellReuseIdentifier ofType:@"xib"]];
        
        if (isConfirmCellXibExist) {
            UINib *nib = [UINib nibWithNibName:kIPHConfirmCellReuseIdentifier bundle:nil];
            [_tableView registerNib:nib forCellReuseIdentifier:kIPHConfirmCellReuseIdentifier];
        }else{
            [_tableView registerClass:[IPHConfirmCell class] forCellReuseIdentifier:kIPHConfirmCellReuseIdentifier];
        }
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"headerTitleColor" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"buttonNormalColor" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"buttonSelectedColor" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

         
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.height_iph = _tableView.contentSize.height;
    }else if ([keyPath containsString:@"Color"]){
        [_tableView reloadData];
    }
}

- (void)dealloc {
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
    [self removeObserver:self forKeyPath:@"headerTitleColor"];
    [self removeObserver:self forKeyPath:@"buttonNormalColor"];
    [self removeObserver:self forKeyPath:@"buttonSelectedColor"];
}


#pragma mark - show


- (void)show{
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    UIView *maskView = [[UIView alloc] initWithFrame:superView.bounds];
    maskView.tag = kIPHMaskViewTag;
    maskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    maskView.alpha = 0;
    [superView addSubview:maskView];
    [superView addSubview:self];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_onConfirmButton)];
    [maskView addGestureRecognizer:tapGestureRecognizer];
    
    [self p_setTop:maskView.height_iph];
    [UIView animateWithDuration:kIPHAnimateDuration animations:^{
        maskView.alpha = 1;
        [self p_setTop:maskView.height_iph - self.height_iph];
    }];
}


- (void)p_hide{
    UIView *superView = self.superview;
    UIView *maskView = [superView viewWithTag:kIPHMaskViewTag];
    [UIView animateWithDuration:kIPHAnimateDuration animations:^{
        maskView.alpha = 0;
        [self p_setTop:maskView.height_iph];
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)p_setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


#pragma mark - set or get

- (void)setDataSource:(id<IPHConditionSelectorViewDataSource>)dataSource{
    _dataSource = dataSource;
    if (_dataSource) {
        _numberOfConditionsSection = [_dataSource numberOfSectionsInConditionSelectorView:self];
    }
}



- (NSMutableArray *)selectedConditions{
    if (_selectedConditions == nil) {
        _selectedConditions = [NSMutableArray arrayWithCapacity:_numberOfConditionsSection];
        int i = 0;
        while (i++ < _numberOfConditionsSection) {
            NSMutableArray *conditions = [NSMutableArray arrayWithCapacity:10];
            [_selectedConditions addObject:conditions];
        }
    }
    return _selectedConditions;
}

- (NSArray *)allSelectedConditions{
    NSMutableArray *allSelectedConditions = [NSMutableArray arrayWithCapacity:_numberOfConditionsSection];
    for (NSMutableArray *array in self.selectedConditions) {
        [allSelectedConditions addObject:[NSArray arrayWithArray:array]];
    }
    return [NSArray arrayWithArray:allSelectedConditions];
}


#pragma mark - action

- (void)p_onConfirmButton{
    [self p_hide];
    if (_delegate && [_delegate respondsToSelector:@selector(conditionSelectorView:didSelectConditions:)]) {
        [_delegate conditionSelectorView:self didSelectConditions:self.allSelectedConditions];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfConditionsSection + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _numberOfConditionsSection) {
        IPHConfirmCell *cell =[tableView dequeueReusableCellWithIdentifier:kIPHConfirmCellReuseIdentifier forIndexPath:indexPath];
        cell.buttonBackgroundColor = self.buttonSelectedColor;
        cell.onConfirmButtonBlock = ^{
            [self p_onConfirmButton];
        };
        return cell;
    }else{
        IPHConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:kIPHConditionCellReuseIdentifier forIndexPath:indexPath];
        cell.headerTitleColor = self.headerTitleColor;
        cell.buttonNormalColor = self.buttonNormalColor;
        cell.buttonSelectedColor = self.buttonSelectedColor;

        cell.title = [self p_titleInSection:indexPath.row];
        cell.allowsMultipleSelection = [self p_allowsMultipleSelectionInSection:indexPath.row];
        NSArray *conditionsData = [self p_conditionsInSection:indexPath.row];
        
        NSMutableArray *cellSelectedConditions = (NSMutableArray *)self.selectedConditions[indexPath.row];
        BOOL canSetDefaultSelectedConditions = YES;
        if (cellSelectedConditions.count > 0) {
            canSetDefaultSelectedConditions = NO;
        }
        if (conditionsData == nil || conditionsData.count == 0) {
            canSetDefaultSelectedConditions = NO;
        }
        
        if (canSetDefaultSelectedConditions) {
            id <IPHConditionProtocol> defaultConditionData = [self p_defaultConditionSelectInSection:indexPath.row];
            id defaultCondition = conditionsData[0];
            if (defaultConditionData) {
                for (id <IPHConditionProtocol> condition in conditionsData) {
                    if ([condition.conditionId isEqualToString:defaultConditionData.conditionId]) {
                        defaultCondition = condition;
                        break;
                    }
                }
            }
            [cellSelectedConditions addObject:defaultCondition];
        }
        [cell setConditionsData:conditionsData selectedConditions:cellSelectedConditions];
        return cell;
    }
    return nil;
}


- (NSString *)p_titleInSection:(NSInteger)section{
    if (_dataSource) {
        return [_dataSource conditionSelectorView:self titleForHeaderInSection:section];
    }
    return nil;
}

- (BOOL)p_allowsMultipleSelectionInSection:(NSInteger)section{
    if ([self p_dataSourceCanRespondsToSelector:@selector(conditionSelectorView:canMultiSelectInSection:)]) {
        return [_dataSource conditionSelectorView:self canMultiSelectInSection:section];
    }
    return NO;
}

- (NSArray *)p_conditionsInSection:(NSInteger)section{
    if ([self p_dataSourceCanRespondsToSelector:@selector(conditionSelectorView:conditionsInSection:)]) {
        return [_dataSource conditionSelectorView:self conditionsInSection:section];
    }
    return nil;
}

- (id)p_defaultConditionSelectInSection:(NSInteger)section{
    if ([self p_dataSourceCanRespondsToSelector:@selector(conditionSelectorView:defaultConditionSelectInSection:)]) {
        return [_dataSource conditionSelectorView:self defaultConditionSelectInSection:section];
    }
    return nil;
}

- (BOOL)p_dataSourceCanRespondsToSelector:(SEL)selector{
    return _dataSource && [_dataSource respondsToSelector:selector];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSArray *conditionsData = [self p_conditionsInSection:indexPath.row];
    if (indexPath.row == _numberOfConditionsSection) {
        height = IPH6FitSize(51);
    }else{
        height = [IPHConditionCell getCellHeightWithConditions:conditionsData];
    }

    return height;
}






@end
