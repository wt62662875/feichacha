//
//  helpCenterViewController.m
//  feichacha
//
//  Created by wt on 16/4/25.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "helpCenterViewController.h"

@interface helpCenterViewController ()

@end

@implementation helpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (IBAction)callPhone:(id)sender {
    [AppUtils callPhone:@"4000172819"];
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
