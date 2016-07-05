//
//  articlesForDailyUseHeadCollectionReusableView.m
//  feichacha
//
//  Created by wt on 16/6/29.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "articlesForDailyUseHeadCollectionReusableView.h"

@implementation articlesForDailyUseHeadCollectionReusableView

-(void)drawRect:(CGRect)rect{
    _backView.layer.borderColor = RGBCOLORA(60, 132, 105, 1).CGColor;
    _backView.layer.borderWidth = 1;
}
@end
