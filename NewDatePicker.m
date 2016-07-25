//
//  NewDatePicker.m
//  LiuLiuGanXi_User
//
//  Created by wt on 15/4/21.
//  Copyright (c) 2015年 Fslit. All rights reserved.
//

#import "NewDatePicker.h"
#import "Public.h"
@implementation NewDatePicker
{
    UIView *view1;
    UIView *alertview;
    
    
    UIPickerView *datePicker;
}


- (void)drawRect:(CGRect)rect {

    self.backgroundColor = [UIColor lightGrayColor];
    self.alpha = 0.65;

    float width = 280;
    float heigh = 275;
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    view1.backgroundColor = [UIColor clearColor];
    [self.superview addSubview:view1];

    alertview = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-width/2, 0, width, heigh)];
    alertview.backgroundColor = [UIColor whiteColor];
    alertview.layer.cornerRadius = 4;
    alertview.alpha = 1;
    [view1 addSubview:alertview];

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, width, 25)];
    title.text = @"选择预约时间";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor lightGrayColor];
    title.font = [UIFont boldSystemFontOfSize:17];
    [alertview addSubview:title];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(8, 30, width-16, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [alertview addSubview:lineView];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 140, 50)];
    lab1.text = @"预约日期";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont boldSystemFontOfSize:15];
    [alertview addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(140, 25, 140, 50)];
    lab2.text = @"时间段";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = [UIColor blackColor];
    lab2.font = [UIFont boldSystemFontOfSize:15];
    [alertview addSubview:lab2];
    
    datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 55, width, 150)];
    datePicker.delegate = self;
    datePicker.dataSource = self;
    [alertview addSubview:datePicker];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(45, 225, 90, 35)];
    [button1 setBackgroundColor:[UIColor lightGrayColor]];
    button1.layer.cornerRadius = 5;
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [alertview addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(145, 225, 90, 35)];
    [button2 setBackgroundColor:RGBCOLORA(248, 215, 72, 1)];
    button2.layer.cornerRadius = 5;
    [button2 setTitle:@"确定" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [alertview addSubview:button2];
    
    [UIView animateWithDuration:0.3 animations:^{
        alertview.layer.frame = CGRectMake(SCREENWIDTH/2-width/2, SCREENHTIGHT/2, width, heigh);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            alertview.layer.frame = CGRectMake(SCREENWIDTH/2-width/2, SCREENHTIGHT/2-heigh/2, width, heigh);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
            } completion:^(BOOL finished) {
                
            }];
            
        }];
    }];
    
//    _leftArray = [[NSMutableArray alloc]initWithObjects:@"YYYY年MM月DD日",@"YYYY年MM月DD日",@"YYYY年MM月DD日", nil];
//    _right1Array =[[NSMutableArray alloc]initWithObjects:@"10:00-12:00",@"12:00-14:00",@"14:00-16:00", nil];
//    _right2Array =[[NSMutableArray alloc]initWithObjects:@"8:00-10:00",@"10:00-12:00",@"12:00-14:00",@"14:00-16:00", @"16:00-18:00",nil];
//    _NewrightArray = _right1Array;
}
-(void)button1Click:(UIButton *)btn
{
    [view1 removeFromSuperview];
    [self removeFromSuperview];

}
-(void)button2Click:(UIButton *)btn
{
    [self.delegate sendtime:_dayString hour:_hourString];

    
    [view1 removeFromSuperview];
    [self removeFromSuperview];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _leftArray.count;
    }else{
        return _NewrightArray.count;
    }
    
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return _leftArray[row];
    }else{
        return _NewrightArray[row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (row != 0) {
            _NewrightArray = _right2Array;
            [pickerView reloadAllComponents];

        }else{
            _NewrightArray = _right1Array;
            [pickerView reloadAllComponents];

        }
        _dayString = [NSString stringWithFormat:@"%ld",(long)row];
    }else{
        _hourString = [NSString stringWithFormat:@"%ld",(long)row];

    }
//
//    _dayString = [_leftArray objectAtIndex:[pickerView selectedRowInComponent:0]];
//    _hourString = [_NewrightArray objectAtIndex:[pickerView selectedRowInComponent:1]];

}
//改字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
@end
