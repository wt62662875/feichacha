//
//  flowersCakeHeadCollectionReusableView.m
//  feichacha
//
//  Created by wt on 16/7/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "flowersCakeHeadCollectionReusableView.h"

@implementation flowersCakeHeadCollectionReusableView
-(void)drawRect:(CGRect)rect{
    _backView.layer.borderColor = RGBCOLORA(193, 0, 1, 1).CGColor;
    _backView.layer.borderWidth = 1;
}
@end
