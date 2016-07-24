//
//  editOrAddAddressViewController.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "editOrAddAddressViewController.h"
#import "CityPicker.h"
#import "noAddressSearchViewController.h"
#import "haveAddressSearchViewController.h"

@interface editOrAddAddressViewController ()<CityPickerViewDelegate>
{
    UIView *backView;
    NSArray *areasArray;
    NSString *cityID;           //城市ID
    NSString *isSex;                 //1男  0女
    NSString *lat;            //经度
    NSString *lon;            //纬度
    
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailsTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectCity;
@property (weak, nonatomic) IBOutlet UIButton *selectDetailsAddress;

@end

@implementation editOrAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_editOrAddBool boolValue]) {
        _titleLabel.text = @"新增地址";
        _deleteAddressButton.hidden = YES;
        [self getAreasList];
    }else{
        _titleLabel.text = @"修改地址";
        _deleteAddressButton.hidden = NO;
        [self getdatas];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    if (_sendDatas) {
        lat = [NSString stringWithFormat:@"%f",[[_sendDatas objectForKey:@"latitude"] floatValue]];
        lon = [NSString stringWithFormat:@"%f",[[_sendDatas objectForKey:@"longitude"] floatValue]];
        [_selectDetailsAddress setTitle:[_sendDatas objectForKey:@"name"] forState:UIControlStateNormal];
    }
}
#pragma mark 选择城市
- (IBAction)selectCityClick:(id)sender {
    CityPicker *picker = [[[NSBundle mainBundle]loadNibNamed:@"CityPickerView" owner:self options:nil] objectAtIndex:0];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (int i=0;i<areasArray.count ;i++ ) {
        [temp addObject:[areasArray[i] objectForKey:@"Name"]];
    }
    picker.cityArray = temp;
    
    [picker setCenter:CGPointMake( self.view.bounds.size.width/2.0,  self.view.bounds.size.height-130)];
    picker.delegate = self;
    //动画
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [picker setAlpha:1.0f];
    [picker.layer addAnimation:animation forKey:@"pushIn"];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    [self.navigationController.view addSubview:backView];
    [self.navigationController.view addSubview:picker];
}
//cityPicker代理
-(void)sendCity:(NSString *)city{
    if (![city isEqualToString:@""]) {
        [_selectCity setTitle:city forState:UIControlStateNormal];
        for (int i = 0; i<areasArray.count; i++) {
            if ([[areasArray[i] objectForKey:@"Name"] isEqualToString:city]) {
                cityID = [areasArray[i] objectForKey:@"AreaId"];
            }
        }
    }
    
    [backView removeFromSuperview];
}
#pragma mark 选择地区
- (IBAction)selectDetailsAddressClick:(id)sender {
    if (!cityID) {
        [SVProgressHUD showInfoWithStatus:@"请选择城市"];
    }else{
        if ([_selectDetailsAddress.titleLabel.text isEqualToString:@"请选择您的住宅小区、大厦或学校"]) {
            [self performSegueWithIdentifier:@"toNoAddressSearch" sender:self];
        }else{
            [self performSegueWithIdentifier:@"toHaveAddressSearch" sender:self];
        }
    }
    
}



-(void)getdatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] addressDetails:_addressID success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            _nameTextField.text = [[responseObject objectForKey:@"AppendData"]objectForKey:@"Name"];
            _phoneNumberTextField.text = [[responseObject objectForKey:@"AppendData"]objectForKey:@"Mobile"];
            _addressDetailsTextField.text = [[responseObject objectForKey:@"AppendData"]objectForKey:@"AddressDetail"];
            isSex = [[responseObject objectForKey:@"AppendData"]objectForKey:@"Sex"];
            if ([isSex boolValue]) {
                [self manClick:nil];
            }else{
                [self womanClick:nil];
            }
            [_selectCity setTitle:[[responseObject objectForKey:@"AppendData"]objectForKey:@"CityName"] forState:UIControlStateNormal];
            [_selectDetailsAddress setTitle:[[responseObject objectForKey:@"AppendData"]objectForKey:@"Address"] forState:UIControlStateNormal];
            lat = [[responseObject objectForKey:@"AppendData"] objectForKey:@"Coordinate_x"];
            lon = [[responseObject objectForKey:@"AppendData"] objectForKey:@"Coordinate_y"];
            cityID = [[responseObject objectForKey:@"AppendData"] objectForKey:@"CityId"];
            
            [self getAreasList];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)getAreasList{
//    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] areasList:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            areasArray = [responseObject objectForKey:@"AppendData"];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
//        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
//        [SVProgressHUD dismiss];
    }];

}

- (IBAction)manClick:(id)sender {
    [_manButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
    [_womenButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    isSex = @"1";
}
- (IBAction)womanClick:(id)sender {
    [_womenButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    isSex = @"0";
}


#pragma mark 保存按钮
- (IBAction)saveButtonClick:(id)sender {
    if (_nameTextField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系人"];
    }else if(!isSex){
        [SVProgressHUD showInfoWithStatus:@"请选择性别"];
    }else if(![AppUtils isValidateMobile:_phoneNumberTextField.text]){
        [SVProgressHUD showInfoWithStatus:@"请正确填写手机号"];
    }else if(!cityID){
        [SVProgressHUD showInfoWithStatus:@"请选择城市"];
    }else if([_selectDetailsAddress.titleLabel.text isEqualToString:@"请选择您的住宅小区、大厦或学校"]){
        [SVProgressHUD showInfoWithStatus:@"请选择您的住宅小区、大厦或学校"];
    }else if(_addressDetailsTextField.text.length <= 0){
        [SVProgressHUD showInfoWithStatus:@"请填写详细门牌号"];
    }else{
        NSString *sexStr;
        if ([isSex boolValue]) {
            sexStr = @"true";
        }else{
            sexStr = @"false";
        }
        if ([_editOrAddBool boolValue]) {
            //新增地址
            [SVProgressHUD showWithStatus:@"加载中..."];
            [[NetworkUtils shareNetworkUtils] insertAddress:lat lon:lon Address:_selectDetailsAddress.titleLabel.text Sex:sexStr Mobile:_phoneNumberTextField.text Tablet:_addressDetailsTextField.text Name:_nameTextField.text IsDefault:@"false" CityId:cityID success:^(id responseObject) {
//                NSLog(@"数据:%@",responseObject);
                if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"新增地址成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
                }
                [SVProgressHUD dismiss];
            } failure:^(NSString *error) {
                [SVProgressHUD dismiss];
            }];
        }else{
            //修改地址
            [SVProgressHUD showWithStatus:@"加载中..."];
            [[NetworkUtils shareNetworkUtils] upDateAddress:_addressID lat:lat lon:lon Address:_selectDetailsAddress.titleLabel.text Sex:sexStr Mobile:_phoneNumberTextField.text Tablet:_addressDetailsTextField.text Name:_nameTextField.text IsDefault:@"false" CityId:cityID success:^(id responseObject) {
//                NSLog(@"数据:%@",responseObject);
                [SVProgressHUD dismiss];
                if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"地址修改成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
                }
                
            } failure:^(NSString *error) {
                [SVProgressHUD dismiss];
            }];
        }
    }
}
#pragma mark 删除地址
- (IBAction)deleteAddress:(id)sender {
//    delAddress
    [UIAlertView showWithTitle:@"温馨提示" message:@"是否删除该地址？" style:UIAlertViewStyleDefault cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            [SVProgressHUD showWithStatus:@"加载中..."];
            [[NetworkUtils shareNetworkUtils] delAddress:_addressID success:^(id responseObject) {
//                NSLog(@"数据:%@",responseObject);
                if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"地址删除成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
                }
                [SVProgressHUD dismiss];
            } failure:^(NSString *error) {
                [SVProgressHUD dismiss];
            }];

        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNoAddressSearch"]) {
        noAddressSearchViewController *noAddressSearchVC = segue.destinationViewController;
        [noAddressSearchVC setCity:_selectCity.titleLabel.text];
    }else if([segue.identifier isEqualToString:@"toHaveAddressSearch"]){
        haveAddressSearchViewController *haveAddressSearchVC = segue.destinationViewController;
        [haveAddressSearchVC setLon:lon];
        [haveAddressSearchVC setLat:lat];
        [haveAddressSearchVC setCity:_selectCity.titleLabel.text];

    }
    
}

#pragma mark 不让输入笑脸符号
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
//    DLog(@"[[UITextInputMode currentInputMode]primaryLanguage] is %@",);
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
