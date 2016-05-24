//
//  CassegrainWineryViewController.m
//  feichacha
//
//  Created by wt on 16/5/10.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "CassegrainWineryViewController.h"
#import "CassegrainWineryTableViewCell1.h"
#import "CassegrainWineryTableViewCell2.h"
#import "CassegrainWineryTableViewCell3.h"
#import "CassegrainWineryTableViewCell4.h"
#import "CassegrainWineryTableViewCell5.h"
#import "CassegrainWineryTableViewCell6.h"
#import "CassegrainWineryTableViewCell7.h"
#import "CassegrainWineryTableViewCell8.h"
#import "baseViewController.h"

@interface CassegrainWineryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation CassegrainWineryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return SCREENWIDTH*0.675;
    }else if (indexPath.row == 1){
        return 108;
    }else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6){
        return 190;
    }else if (indexPath.row == 3 || indexPath.row == 5){
        return 180;
    }else if (indexPath.row == 7){
        return 100;
    }else if (indexPath.row == 8){
        return SCREENWIDTH*2.19;
    }else if (indexPath.row == 9){
        return SCREENWIDTH*0.824;
    }else if (indexPath.row == 10){
        return (SCREENWIDTH - 16)*1.043;
    }
    
    
    return 0;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell1";
        CassegrainWineryTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell1" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        return cell;
    }else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell2";
        CassegrainWineryTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell2" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        return cell;
    }else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6) {
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell3";
        CassegrainWineryTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell3" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 2) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/fj_img1.png"]];
            [cell.image2 setImage:[UIImage imageNamed:@"red_wine_por1"]];
        }else if (indexPath.row == 4) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/fj_img3.png"]];
            [cell.image2 setImage:[UIImage imageNamed:@"red_wine_por3"]];
        }else if (indexPath.row == 6) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/fj_img5.png"]];
            [cell.image2 setImage:[UIImage imageNamed:@"red_wine_por5"]];
        }
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 3 || indexPath.row == 5) {
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell4";
        CassegrainWineryTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell4" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 3) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/fj_img2.png"]];
            [cell.iamge2 setImage:[UIImage imageNamed:@"red_wine_por2"]];
        }else if (indexPath.row == 5) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/fj_img4.png"]];
            [cell.iamge2 setImage:[UIImage imageNamed:@"red_wine_por4"]];
        }
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 7){
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell5";
        CassegrainWineryTableViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell5" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else if (indexPath.row == 8){
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell6";
        CassegrainWineryTableViewCell6 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell6" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else if (indexPath.row == 9){
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell7";
        CassegrainWineryTableViewCell7 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell7" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else if (indexPath.row == 10){
        static NSString *cellIdentifier = @"CassegrainWineryTableViewCell8";
        CassegrainWineryTableViewCell8 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryTableViewCell8" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    
    return nil;
}
-(void)buyButton:(UIButton*)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    if (sender.tag == 2 || sender.tag == 4 || sender.tag == 6) {
        CassegrainWineryTableViewCell3 *cell = (CassegrainWineryTableViewCell3 *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }else{
        CassegrainWineryTableViewCell4 *cell = (CassegrainWineryTableViewCell4 *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }
    
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
