//
//  NewDatePicker.h
//  LiuLiuGanXi_User
//
//  Created by wt on 15/4/21.
//  Copyright (c) 2015年 Fslit. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewPickDateViewDelegate <NSObject>
-(void)sendtime:(NSString *)year hour:(NSString*)hour;
@end

@interface NewDatePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *leftArray;
@property (strong, nonatomic) NSMutableArray *right1Array;
@property (strong, nonatomic) NSMutableArray *right2Array;

@property (strong, nonatomic) NSMutableArray *NewrightArray;

@property (strong, nonatomic)NSString *dayString;
@property (strong, nonatomic)NSString *hourString;



@property(nonatomic,retain)id<NewPickDateViewDelegate> delegate;

@end
