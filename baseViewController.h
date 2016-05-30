//
//  baseViewController.h
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsDetailsViewController.h"
#import "newProductViewController.h"
#import "salesPromotionViewController.h"
#import "appleViewController.h"
#import "CassegrainWineryViewController.h"
#import "ChenHempViewController.h"
#import "germanBeerViewController.h"
#import "freshFruitViewController.h"
#import "braisedFoodViewController.h"
#import "dairyCakeViewController.h"
#import "drinkWineViewController.h"
#import "theBrandOfCigarettesViewController.h"
#import "leisureSnacksViewController.h"
#import "convenientFastFoodViewController.h"
#import "deliciousIceCreamViewController.h"
#import "wineViewController.h"
#import "taiwaneseFoodViewController.h"
#import "VerifyTheMobilePhoneViewController.h"
#import "aDishThatGoesWithLiquorViewController.h"

@interface baseViewController : UIViewController


- (void)addProductsAnimation:(UIImageView *)imageView selfView:(UIView *)selfView pointX:(float) pointX pointY:(float)pointY;
@end
