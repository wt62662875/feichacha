//
//  CityPicker.h
//  LiuLiuGanXi_User
//
//  Created by wt on 15/4/10.
//  Copyright (c) 2015年 Fslit. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CityPickerViewDelegate <NSObject>
-(void)sendCity:(NSString *)city;

@end

@interface CityPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *CityPicker;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSString *cityName;


@property(nonatomic,retain)id<CityPickerViewDelegate> delegate;

@end
