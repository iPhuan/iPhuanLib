//
//  IPHConditionSelectorViewController.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/3/31.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHConditionSelectorViewController.h"
#import "IPHConditionSelectorView.h"
#import "IPHCondition.h"
#import "IPHConditions.h"

@interface IPHConditionSelectorViewController () <IPHConditionSelectorViewDataSource, IPHConditionSelectorViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *conditionButton;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (strong, nonatomic) IPHConditionSelectorView *conditionSelectorView;
@property (strong, nonatomic) IPHConditions *conditions;


@end

@implementation IPHConditionSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"IPHConditions" ofType:@"plist"];
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.conditions = [[IPHConditions alloc] initWithDictionary:dataDic];
    self.conditionSelectorView = [[IPHConditionSelectorView alloc] init];
    _conditionSelectorView.dataSource = self;
    _conditionSelectorView.delegate = self;
    
    // 设置对应的颜色
    _conditionSelectorView.headerTitleColor = [UIColor blackColor];
    _conditionSelectorView.buttonNormalColor = [UIColor blackColor];
    _conditionSelectorView.buttonSelectedColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)onConditionClick:(id)sender {
    [_conditionSelectorView show];
}


#pragma mark - WFPConditionSelectorViewDataSource

- (NSInteger)numberOfSectionsInConditionSelectorView:(IPHConditionSelectorView *)selectorView{
    return 2;
}

- (NSString *)conditionSelectorView:(IPHConditionSelectorView *)selectorView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"价格";
    }else if (section == 1){
        return @"星级";
    }
    return nil;
}

- (NSArray<id <IPHConditionProtocol>> *)conditionSelectorView:(IPHConditionSelectorView *)selectorView conditionsInSection:(NSInteger)section{
    if (section == 0) {
        return _conditions.priceConditions;
    }else if (section == 1){
        return _conditions.starConditions;
    }
    return nil;
}

- (BOOL)conditionSelectorView:(IPHConditionSelectorView *)selectorView canMultiSelectInSection:(NSInteger)section{
    return YES;
}

- (id <IPHConditionProtocol>)conditionSelectorView:(IPHConditionSelectorView *)selectorView defaultConditionSelectInSection:(NSInteger)section{
    if (section == 0) {
        return _conditions.priceConditions[0];
    }else if (section == 1){
        return _conditions.starConditions[0];
    }
    return nil;
}



#pragma mark - WFPConditionSelectorViewDelegate

- (void)conditionSelectorView :(IPHConditionSelectorView *)selectorView didSelectConditions:(NSArray<NSArray<id <IPHConditionProtocol>> *> *)conditions{
    NSArray *selectedPriceConditions = conditions[0];
    NSMutableArray *priceConditionCodes = [[NSMutableArray alloc] initWithCapacity:7];
    NSMutableArray *priceConditionNames = [[NSMutableArray alloc] initWithCapacity:7];
    for (IPHCondition *condition in selectedPriceConditions) {
        if (!condition.isUnlimited) {
            [priceConditionCodes addObject:condition.conditionId];
            [priceConditionNames addObject:condition.title];
        }
    }
    
    NSArray *selectedStarConditions = conditions[1];
    NSMutableArray *starConditionCodes = [[NSMutableArray alloc] initWithCapacity:7];
    NSMutableArray *starConditionNames = [[NSMutableArray alloc] initWithCapacity:7];
    for (IPHCondition *condition in selectedStarConditions) {
        if (!condition.isUnlimited) {
            [starConditionCodes addObject:condition.conditionId];
            [starConditionNames addObject:condition.title];
        }
    }
    
    NSString * priceRanges = @"";
    if (priceConditionNames.count > 0) {
        priceRanges = [priceConditionNames componentsJoinedByString:@"，"];
    }
    
    NSString * starRanges = @"";
    if (starConditionNames.count > 0) {
        starRanges = [starConditionNames componentsJoinedByString:@"，"];
    }
    
    NSString *text = priceRanges;
    if ((text)) {
        text = [text stringByAppendingString:@"\n\n"];
    }
    if (IPHIsAvailableString(starRanges)) {
        text = [text stringByAppendingString:starRanges];
    }else{
        text = [text stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
    }
    if (IPHIsAvailableString(text)) {
        _conditionsLabel.text = text;
    }else{
        _conditionsLabel.text = nil;
    }
}


@end
