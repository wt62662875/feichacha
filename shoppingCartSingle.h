//
//  shoppingCartSingle.h
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shoppingCartSingle : NSObject

@property(nonatomic,retain)NSString *test;


+(shoppingCartSingle *)sharedInstance;
@end
