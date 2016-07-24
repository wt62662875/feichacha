//
//  myPrizeViewController.m
//  feichacha
//
//  Created by wt on 16/7/22.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "myPrizeViewController.h"

@interface myPrizeViewController ()
{
    NSArray *datas;
}

@end

@implementation myPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDatas];
}
-(void)getDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] UserLuckyList:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [responseObject objectForKey:@"AppendData"];
//            [_tableView reloadData];
        }else {
            datas = nil;
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
//            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
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
