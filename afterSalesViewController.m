//
//  afterSalesViewController.m
//  feichacha
//
//  Created by wt on 16/5/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "afterSalesViewController.h"
#import "myOrderTableViewCell.h"
#import "orderDetailsViewController.h"


@interface afterSalesViewController ()
{
    NSMutableArray* datas;
    id sendDatas;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation afterSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self FinishOrder];
}
-(void)FinishOrder{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] FinishOrder:[USERDEFAULTS objectForKey:@"UserID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
        }else {
            datas = nil;
            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datas.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 146;
    }else{
        return 187;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myOrderTableViewCell";
    myOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"myOrderTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    NSArray *tempArray = [datas[indexPath.row] objectForKey:@"OrderList"];
    if (tempArray.count == 1) {
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else if(tempArray.count == 2){
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else if(tempArray.count == 3){
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][2]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else if(tempArray.count == 4){
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][2]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][3]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else{
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][2]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][3]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.iamge5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][4]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }

    if (indexPath.row == 0) {
        cell.footButtonView.hidden = YES;
    }
    cell.timeLbael.text = [datas[indexPath.row] objectForKey:@"AddDates"];
    cell.goodsNumberLabel.text = [NSString stringWithFormat:@"共计%lu件商品",(unsigned long)tempArray.count];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",[[datas[indexPath.row] objectForKey:@"Money"] floatValue]];

    cell.footButton.tag = indexPath.row;
    cell.footButton2.tag = indexPath.row;
    [cell.footButton addTarget:self action:@selector(footButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.footButton2 addTarget:self action:@selector(footButton2:) forControlEvents:UIControlEventTouchUpInside];

    [cell.footButton setTitle:@"申请退款" forState:UIControlStateNormal];
    [cell.footButton2 setTitle:@"申请售后" forState:UIControlStateNormal];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    sendDatas = datas[indexPath.row];
    [self performSegueWithIdentifier:@"afterSalesToOrderDetails" sender:self];
}
#pragma mark 底部按钮
-(void)footButton:(UIButton *)sender{
    
}
#pragma mark 底部按钮2
-(void)footButton2:(UIButton *)sender{
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"afterSalesToOrderDetails"]) {
        orderDetailsViewController *orderDetailsVC = segue.destinationViewController;
        [orderDetailsVC setGetDatas:sendDatas];
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
