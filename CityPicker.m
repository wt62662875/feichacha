//
//  CityPicker.m
//  LiuLiuGanXi_User
//
//  Created by wt on 15/4/10.
//  Copyright (c) 2015年 Fslit. All rights reserved.
//

#import "CityPicker.h"
#import "Public.h"
@implementation CityPicker


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setFrame:CGRectMake(0, SCREENHTIGHT-250, SCREENWIDTH, 250)];

    _CityPicker.delegate = self;
    _CityPicker.dataSource = self;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _cityArray.count;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _cityArray[row];
}



- (IBAction)cancelBtn:(id)sender {
    
    //移除动画
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [_CityPicker.layer addAnimation:animation forKey:@"TSLocateView"];
    
    [self.delegate sendCity:@""];
}

- (IBAction)SureBtn:(id)sender {
    

    //移除动画
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [_CityPicker.layer addAnimation:animation forKey:@"TSLocateView"];
    
    _cityName = [_cityArray objectAtIndex:[_CityPicker selectedRowInComponent:0]];
    
    [self.delegate sendCity:_cityName ];
    
}

@end
