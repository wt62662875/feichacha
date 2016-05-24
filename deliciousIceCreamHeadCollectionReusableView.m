//
//  deliciousIceCreamHeadCollectionReusableView.m
//  feichacha
//
//  Created by wt on 16/5/16.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "deliciousIceCreamHeadCollectionReusableView.h"

@implementation deliciousIceCreamHeadCollectionReusableView

-(void)drawRect:(CGRect)rect{
    _backView.layer.borderColor = [UIColor blackColor].CGColor;
    _backView.layer.borderWidth = 1;
}
@end
