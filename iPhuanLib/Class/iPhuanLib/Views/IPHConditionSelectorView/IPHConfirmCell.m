//
//  IPHConfirmCell.m
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/27.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import "IPHConfirmCell.h"

#define IPHConfirmCellDefaultButtonBackGroundColor   IPHRGBColor(2, 107, 191);

static const CGFloat kIPHConfirmButtonTag = 123;


@interface IPHConfirmCell (){
    BOOL _isLoadFromNib;
}

@end

@implementation IPHConfirmCell

@synthesize buttonBackgroundColor = _buttonBackgroundColor;

- (void)awakeFromNib {
    [super awakeFromNib];
    _isLoadFromNib = YES;
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_isLoadFromNib) {
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IPH6FitSize(296), IPH6FitSize(39))];
        confirmBtn.tag = kIPHConfirmButtonTag;
        confirmBtn.backgroundColor = self.buttonBackgroundColor;
        confirmBtn.center = CGPointMake(self.width_iph/2.0f, self.height_iph/2.0f);
        confirmBtn.layer.cornerRadius = 4;
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [confirmBtn addTarget:self action:@selector(onConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIColor *)buttonBackgroundColor{
    if (_buttonBackgroundColor == nil) {
        _buttonBackgroundColor = IPHConfirmCellDefaultButtonBackGroundColor;
    }
    return _buttonBackgroundColor;
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor{
    _buttonBackgroundColor = buttonBackgroundColor;
    UIView *confirmBtn = [self viewWithTag:kIPHConfirmButtonTag];
    confirmBtn.backgroundColor = _buttonBackgroundColor;
}


- (IBAction)onConfirmBtn:(id)sender {
    if (_onConfirmButtonBlock) {
        _onConfirmButtonBlock();
    }
}

@end
