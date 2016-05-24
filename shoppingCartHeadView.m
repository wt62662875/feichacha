//
//  shoppingCartHeadView.m
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "shoppingCartHeadView.h"

@implementation shoppingCartHeadView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    _roundView.layer.cornerRadius = 4;
    
    _togetherButton.layer.cornerRadius = 4;
    _togetherButton.layer.borderWidth = 1;
    _togetherButton.layer.borderColor = [UIColor redColor].CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
