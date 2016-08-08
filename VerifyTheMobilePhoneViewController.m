//
//  VerifyTheMobilePhoneViewController.m
//  feichacha
//
//  Created by wt on 16/5/23.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "VerifyTheMobilePhoneViewController.h"
#import "JPUSHService.h"

@interface VerifyTheMobilePhoneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeigh;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCode;
@property (weak, nonatomic) IBOutlet UIButton *determine;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCodeTextField;

@end

@implementation VerifyTheMobilePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bannerHeigh.constant = SCREENWIDTH*0.327;
    _getVerificationCode.layer.cornerRadius = 4;
    _determine.layer.cornerRadius = 4;
    NSLog(@"registrationID:%@",[JPUSHService registrationID]) ;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    if (sender == self.phoneNumberTextField) {
        if (sender.text.length > 11) {
            sender.text = [sender.text substringToIndex:11];
        }
    }
    if (sender == self.VerificationCodeTextField) {
        if (sender.text.length > 4) {
            sender.text = [sender.text substringToIndex:4];
        }
    }
}


#pragma mark 验证码
- (IBAction)getVerificationCodeClick:(id)sender {
     if (![AppUtils isValidateMobile:_phoneNumberTextField.text] ) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号" maskType:SVProgressHUDMaskTypeNone];
    }else{
        [SVProgressHUD showWithStatus:@"加载中..."];
        [[NetworkUtils shareNetworkUtils] getVerificationCode:_phoneNumberTextField.text success:^(id responseObject) {
            NSLog(@"数据:%@",responseObject);
            if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                [self startTime];
            }else {
              [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSString *error) {
            [SVProgressHUD dismiss];
        }];
    }
    
    
}
#pragma mark 倒计时
-(void)startTime{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置 特别注明：UI的改变一定要在主线程中进行
                [_getVerificationCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                _getVerificationCode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getVerificationCode setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                
                _getVerificationCode.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

#pragma mark 确定
- (IBAction)determineClick:(id)sender {
    if (![AppUtils isValidateMobile:_phoneNumberTextField.text] ) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号" maskType:SVProgressHUDMaskTypeNone];
    }else if (_VerificationCodeTextField.text.length<4){
        [SVProgressHUD showErrorWithStatus:@"请输入完整的验证码" maskType:SVProgressHUDMaskTypeNone];
    }else{
        [SVProgressHUD showWithStatus:@"加载中..."];
        [[NetworkUtils shareNetworkUtils] login:_phoneNumberTextField.text code:_VerificationCodeTextField.text success:^(id responseObject) {
            NSLog(@"数据:%@",responseObject);
            if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                [USERDEFAULTS setObject:[[responseObject objectForKey:@"AppendData"] objectForKey:@"token"] forKey:@"TOKEN"];
                [USERDEFAULTS setObject:[[responseObject objectForKey:@"AppendData"] objectForKey:@"userid"] forKey:@"UserID"];
                
                [USERDEFAULTS setObject:@"1" forKey:@"isRegister"];
                [USERDEFAULTS setObject:_phoneNumberTextField.text forKey:@"telPhoneNumber"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSString *error) {
            [SVProgressHUD dismiss];
        }];
    }
}
#pragma mark 语音验证码
- (IBAction)VoiceVerificationCodeClick:(id)sender {
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
