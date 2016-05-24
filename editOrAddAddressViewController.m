//
//  editOrAddAddressViewController.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "editOrAddAddressViewController.h"

@interface editOrAddAddressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;

@end

@implementation editOrAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_editOrAddBool boolValue]) {
        _titleLabel.text = @"新增地址";
        _deleteAddressButton.hidden = YES;
    }else{
        _titleLabel.text = @"修改地址";
        _deleteAddressButton.hidden = NO;
    }
}
- (IBAction)manClick:(id)sender {
    [_manButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
    [_womenButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}
- (IBAction)womanClick:(id)sender {
    [_womenButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}


#pragma mark 保存按钮
- (IBAction)saveButtonClick:(id)sender {
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
