//
//  FiletMignonViewController.m
//  feichacha
//
//  Created by wt on 16/7/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "FiletMignonViewController.h"
#import "baseViewController.h"
#import "FiletMignonTableViewCell.h"

@interface FiletMignonViewController (){
    NSArray *datas;
    
}
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FiletMignonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    // Do any additional setup after loading the view from its nib.
    [self initHeadFootView];
    [self ActivityListDatas];
}
-(void)ActivityListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] ActivityList:[_getDatas objectForKey:@"Id"] ActType:[_getDatas objectForKey:@"ActType"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[NSMutableArray alloc]init];
            datas = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ActivityProduct"];
            
            [_tableView reloadData];
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
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
    return 134;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FiletMignonTableViewCell";
    FiletMignonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FiletMignonTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    cell.name.text = [datas[indexPath.row] objectForKey:@"Name"];
    cell.size.text = [datas[indexPath.row] objectForKey:@"Size"];
    cell.price.text = [NSString stringWithFormat:@"￥%@",[datas[indexPath.row] objectForKey:@"Price"]];
    
    cell.buyButton.tag = indexPath.row;
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.goodsClick.tag = indexPath.row;
    [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
-(void)initHeadFootView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.388)];
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:headView.frame];
    [headImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_lpbanner.jpg"] placeholderImage:[UIImage imageNamed:@"banner"]];
    [headView addSubview:headImage];
    _tableView.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENWIDTH*0.917*3+SCREENWIDTH*1.69+SCREENWIDTH*1.55)];
    UIImageView *footImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.917)];
    [footImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/-xxyd_lpimg1.jpg"] placeholderImage:[UIImage imageNamed:@"banner"]];
    [footView addSubview:footImage1];
    
    UIImageView *footImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.917, SCREENWIDTH, SCREENWIDTH*0.917)];
    [footImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/-xxyd_lpimg2.jpg"] placeholderImage:[UIImage imageNamed:@"banner"]];
    [footView addSubview:footImage2];
    
    UIImageView *footImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.917*2, SCREENWIDTH,SCREENWIDTH*0.917)];
    [footImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/-xxyd_lpimg3.jpg"] placeholderImage:[UIImage imageNamed:@"banner"]];
    [footView addSubview:footImage3];
    
    UIImageView *footImage4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.917*3, SCREENWIDTH, SCREENWIDTH*1.69)];
    [footImage4 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_lpimg4.jpg"] placeholderImage:[UIImage imageNamed:@"banner"]];
    [footView addSubview:footImage4];
    
    UIImageView *footImage5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.917*3+SCREENWIDTH*1.69, SCREENWIDTH, SCREENWIDTH*1.55)];
    [footImage5 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/-xxyd_lpimg5.jpg"] placeholderImage:[UIImage imageNamed:@"banner"]];
    [footView addSubview:footImage5];
    
    _tableView.tableFooterView = footView;
    [_tableView reloadData];
}
#pragma mark cell里的加入购物车
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    
    FiletMignonTableViewCell *cell = (FiletMignonTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsAdd" object:datas[sender.tag]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
-(void)goodsClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:datas[sender.tag]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}

- (IBAction)goShoppingCart:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToShoppingCart" object:nil];
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
