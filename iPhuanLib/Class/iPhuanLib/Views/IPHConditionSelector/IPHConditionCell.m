//
//  IPHConditionCell.m
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/27.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import "IPHConditionCell.h"
#import "IPHConditionProtocol.h"

#define IPHConditionCellHeaderTitleColor       [UIColor blackColor]
#define IPHConditionCellButtonNormalColor      [UIColor blackColor]
#define IPHConditionCellButtonSelectedColor    IPHRGBColor(2, 107, 191);

static const CGFloat kIPHButtonMinSpace = 8; // button最小间隙
static const CGFloat kIPHButtonMaxSpace = 10;
static const CGFloat kIPHButtonLeft = 13; // button左边距
static const CGFloat kIPHButtonRigth = 28; // button右边距
static const CGFloat kIPHButtonMinWidth = 75;
static const CGFloat kIPHButtonHeight = 38;

#pragma mark - IPHConditionButton

@interface IPHConditionButton : UIButton
@property (nonatomic, strong) id <IPHConditionProtocol> condition;
@property (nonatomic, assign) BOOL isUnlimited;

@end

@implementation IPHConditionButton

- (BOOL)isUnlimited{
    return _condition.isUnlimited;
}

@end



#pragma mark - IPHConditionCell

@interface IPHConditionCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) NSMutableArray *conditionButtons;
@property (nonatomic, strong) NSMutableArray *selectedConditions;
@property (nonatomic, strong) NSArray *conditionsData;
@property (nonatomic, strong) IPHConditionButton *unlimitedButton;


@end


@implementation IPHConditionCell

@synthesize headerTitleColor = _headerTitleColor;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = self.headerTitleColor;
        [self addSubview:_titleLabel];
        [self addSubview:self.noDataLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __block float x = kIPHButtonLeft;
    __block float y = 10;
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleLabel.frame = CGRectMake(x, y, self.frame.size.width - x, size.height);
    y += size.height + 3;
    self.noDataLabel.frame = CGRectMake(x + 5, y, self.frame.size.width - x - 5, self.titleLabel.frame.size.height);
    y += 7;
    float space = kIPHButtonMinSpace; // 最小空隙
    float width = kIPHButtonMinWidth; // button最小宽度
    int t = (self.frame.size.width - kIPHButtonLeft - kIPHButtonRigth + space) / (width + space);
    space = (self.frame.size.width - kIPHButtonLeft - kIPHButtonRigth - width * t) / (t - 1); // 修正空隙宽度
    if (space > kIPHButtonMaxSpace) {  // 修正button宽度
        width += (space - kIPHButtonMaxSpace) * (t - 1) / t;
        space = kIPHButtonMaxSpace;
    }
    
    [self.conditionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
        button.frame = CGRectMake(x, y, width, kIPHButtonHeight);
        if ((index + 1) % t == 0) {
            y += kIPHButtonHeight + 5;
            x = kIPHButtonLeft;
        }
        else {
            x += width + space;
        }
    }];
}

#pragma mark - Public

- (void)setConditionsData:(NSArray *)conditionsData selectedConditions:(NSMutableArray *)selectedConditions{
    self.conditionsData = conditionsData;
    self.selectedConditions = selectedConditions;
    if (_conditionsData == nil || _conditionsData.count == 0) {
        [self addSubview:self.noDataLabel];
        self.noDataLabel.hidden = NO;
        return;
    }
    
    self.noDataLabel.hidden = YES;
    
    [_conditionsData enumerateObjectsUsingBlock:^(id <IPHConditionProtocol> condition, NSUInteger index, BOOL *stop) {
        @autoreleasepool {
            IPHConditionButton *button = nil;
            if (index < self.conditionButtons.count) {
                button = [self.conditionButtons objectAtIndex:index];
            }
            else {
                button = [[IPHConditionButton alloc] init];
                [button setBackgroundColor:IPHRGBColor(235, 236, 237)];

                button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 2.0f;
                [button addTarget:self action:@selector(p_onConditionBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.conditionButtons addObject:button];
                [self addSubview:button];
            }
            [button setTitleColor:self.buttonNormalColor forState:UIControlStateNormal];
            [button setTitleColor:self.buttonSelectedColor forState:UIControlStateHighlighted];
            [button setTitleColor:self.buttonSelectedColor forState:UIControlStateSelected];
            [button.layer setBorderColor:self.buttonSelectedColor.CGColor];
            button.condition = condition;
            if (button.isUnlimited) {
                self.unlimitedButton = button;
            }
            
            [button setTitle:condition.title forState:UIControlStateNormal];
            button.tag = index;
            
            [self p_setButton:button selected:[_selectedConditions containsObject:condition]];
            
            while (_conditionsData.count < self.conditionButtons.count) {
                [(UIView *)self.conditionButtons.lastObject removeFromSuperview];
                [self.conditionButtons removeLastObject];
            }
        }
    }];
}


+ (CGFloat)getCellHeightWithConditions:(NSArray *)conditions {
    float h = 30;
    if (conditions != nil && conditions.count > 0) {
        float space = kIPHButtonMinSpace; // 最小空隙
        float width = kIPHButtonMinWidth; // button最小宽度
        int t = ([UIScreen mainScreen].bounds.size.width - kIPHButtonLeft - kIPHButtonRigth + space) / (width + space);
        space = ([UIScreen mainScreen].bounds.size.width - kIPHButtonLeft - kIPHButtonRigth - width * t) / (t - 1); // 修正空隙宽度
        if (space > kIPHButtonMaxSpace) { // 修正button宽度
            width += (space - kIPHButtonMaxSpace) * (t - 1) / t;
            space = kIPHButtonMaxSpace;
        }
        
        h += (10 + (kIPHButtonHeight + 5) * (conditions.count / t + (conditions.count % t == 0 ? 0 : 1)));
    }
    else {
        h += 17;
    }
    return h;
}


#pragma mark - Event Response
- (void)p_onConditionBtn:(IPHConditionButton *)sender{
    if (_allowsMultipleSelection) {
        //保证至少选择一个条件
        if (_selectedConditions.count == 1 && sender.condition == _selectedConditions[0]) {
            return;
        }
        
        if (sender.isUnlimited) {
            [_selectedConditions enumerateObjectsUsingBlock:^(id <IPHConditionProtocol> condition, NSUInteger index, BOOL *stop) {
                NSUInteger idx = [_conditionsData indexOfObject:condition];
                IPHConditionButton *button = self.conditionButtons[idx];
                [self p_setButton:button selected:NO];
            }];
            [_selectedConditions removeAllObjects];
            [self p_setButton:sender conditionSelected:YES];
        }else{
            [self p_setButton:sender conditionSelected:!sender.selected];
            [self p_setButton:_unlimitedButton conditionSelected:NO];
        }
    }else{
        id lastSelectedCondition = nil;
        if (_selectedConditions && _selectedConditions.count > 0) {
            lastSelectedCondition = _selectedConditions[0];
        }

        if (lastSelectedCondition) {
            NSUInteger idx = [_conditionsData indexOfObject:lastSelectedCondition];
            IPHConditionButton *lastSelectedButton = self.conditionButtons[idx];
            [self p_setButton:lastSelectedButton conditionSelected:NO];
        }
        [self p_setButton:sender conditionSelected:YES];
    }
}

- (void)p_setButton:(IPHConditionButton *)button conditionSelected:(BOOL)selected{
    button.selected = selected;
    if (selected) {
        button.layer.borderWidth = 1.0f;
        [_selectedConditions addObject:button.condition];
    }else{
        button.layer.borderWidth = 0.0f;
        [_selectedConditions removeObject:button.condition];
    }
}

- (void)p_setButton:(IPHConditionButton *)button selected:(BOOL)selected{
    button.selected = selected;
    if (selected) {
        button.layer.borderWidth = 1.0f;
    }else{
        button.layer.borderWidth = 0.0f;
    }
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    _titleLabel.text = title;
}

- (void)setHeaderTitleColor:(UIColor *)headerTitleColor{
    if (CGColorEqualToColor(_headerTitleColor.CGColor, headerTitleColor.CGColor)) {
        return;
    }
    _headerTitleColor = headerTitleColor;
    _titleLabel.textColor = _headerTitleColor;
}


#pragma mark - Getter

- (UIColor *)headerTitleColor{
    if (_headerTitleColor == nil) {
        _headerTitleColor = IPHConditionCellHeaderTitleColor;
    }
    return _headerTitleColor;
}

- (UIColor *)buttonNormalColor{
    if (_buttonNormalColor == nil) {
        _buttonNormalColor = IPHConditionCellButtonNormalColor;
    }
    return _buttonNormalColor;
}

- (UIColor *)buttonSelectedColor{
    if (_buttonSelectedColor == nil) {
        _buttonSelectedColor = IPHConditionCellButtonSelectedColor;
    }
    return _buttonSelectedColor;
}


- (UILabel *)noDataLabel{
    if (_noDataLabel == nil) {
        _noDataLabel = [[UILabel alloc] init];
        [_noDataLabel setText:@"暂无数据"];
        [_noDataLabel setTextColor:[UIColor grayColor]];
        [_noDataLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _noDataLabel;
}

- (NSMutableArray *)conditionButtons{
    if (_conditionButtons == nil) {
        _conditionButtons = [[NSMutableArray alloc] init];
    }
    return _conditionButtons;
}


@end
