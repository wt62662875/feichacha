//
//  couponsViewController.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "couponsViewController.h"
#import "DoNotUseTableViewCell.h"
#import "expiredCouponsTableViewCell.h"
#import "couponsTableViewCell.h"

@interface couponsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

@end

@implementation couponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bindingButton.layer.cornerRadius = 4;
    _bindingButton.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else if(indexPath.row == 1){
        return 127;
    }else{
        return 127;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"DoNotUseTableViewCell";
        DoNotUseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"DoNotUseTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.notUseButton addTarget:self action:@selector(notUseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if(indexPath.row == 1){
        static NSString *cellIdentifier = @"expiredCouponsTableViewCell";
        expiredCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"expiredCouponsTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];


        return cell;
    }else{
        static NSString *cellIdentifier = @"couponsTableViewCell";
        couponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"couponsTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
   
}

#pragma mark 不使用优惠卷
-(void)notUseButton:(UIButton *)sender{
    NSLog(@" 不使用优惠卷");
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
