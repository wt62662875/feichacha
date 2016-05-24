//
//  shoppingCartSingle.m
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "shoppingCartSingle.h"
static shoppingCartSingle *sharedCLDelegate = nil;

@implementation shoppingCartSingle

+(shoppingCartSingle *)sharedInstance{
    @synchronized(self) {
        if(sharedCLDelegate == nil) {
            sharedCLDelegate =  [[[shoppingCartSingle class] alloc] init]; //   assignment   not   done   here
        }
    }
    return sharedCLDelegate;
}

- (id)init
{
    self=[super init];
    if (self) {
        
        
        
        
    }
    return self;
}







@end
