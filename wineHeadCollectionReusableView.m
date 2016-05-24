//
//  wineHeadCollectionReusableView.m
//  feichacha
//
//  Created by wt on 16/5/16.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "wineHeadCollectionReusableView.h"

@implementation wineHeadCollectionReusableView
-(void)drawRect:(CGRect)rect{
    _backView.layer.borderColor = [UIColor whiteColor].CGColor;
    _backView.layer.borderWidth = 1;
    
    _buyButton.layer.cornerRadius = 4;
}
@end
