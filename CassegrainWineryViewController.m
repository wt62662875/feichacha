//
//  CassegrainWineryViewController.m
//  feichacha
//
//  Created by wt on 16/5/10.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "CassegrainWineryViewController.h"
#import "CassegrainWineryLeftTableViewCell.h"
#import "CassegrainWineryRightTableViewCell.h"
#import "baseViewController.h"

@interface CassegrainWineryViewController ()
{
    NSArray *datas;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation CassegrainWineryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    // Do any additional setup after loading the view.
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
    if (indexPath.row % 2 == 0) {
        return 190;
    }else{
        return 180;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        static NSString *cellIdentifier = @"CassegrainWineryLeftTableViewCell";
        CassegrainWineryLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryLeftTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name.text = [datas[indexPath.row] objectForKey:@"Name"];
        cell.size.text = [datas[indexPath.row] objectForKey:@"Size"];
        cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[datas[indexPath.row] objectForKey:@"Price"] floatValue]];
        if ([[datas[indexPath.row] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
        
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsClick.tag = indexPath.row;
        [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString *cellIdentifier = @"CassegrainWineryRightTableViewCell";
        CassegrainWineryRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CassegrainWineryRightTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name.text = [datas[indexPath.row] objectForKey:@"Name"];
        cell.size.text = [datas[indexPath.row] objectForKey:@"Size"];
        cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[datas[indexPath.row] objectForKey:@"Price"] floatValue]];
        if ([[datas[indexPath.row] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
        
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsClick.tag = indexPath.row;
        [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(void)initHeadFootView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.68+106)];
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.68)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/fj_banner.jpg"] placeholderImage:[UIImage imageNamed:@"banner"]];
    [headView addSubview:headImage];
    UIImageView *headImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-106, SCREENWIDTH*0.68+8, 212, 90)];
    [headImage2 setImage:[UIImage imageNamed:@"red_wine_synopsis"]];
    [headView addSubview:headImage2];
    _tableView.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80+SCREENWIDTH*2.19+SCREENWIDTH*0.824+SCREENWIDTH*1.042)];
    UIImageView *footImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-118, 8, 236, 64)];
    [footImage1 setImage:[UIImage imageNamed:@"red_wine_for1"]];
    [footView addSubview:footImage1];
    
    UIImageView *footImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, SCREENWIDTH, SCREENWIDTH*2.19)];
    [footImage2 setImage:[UIImage imageNamed:@"red_wine_for2"]];
    [footView addSubview:footImage2];
    
    UIImageView *footImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80+SCREENWIDTH*2.19, SCREENWIDTH, SCREENWIDTH*0.824)];
    [footImage3 setImage:[UIImage imageNamed:@"red_wine_for3"]];
    [footView addSubview:footImage3];
    
    UIImageView *footImage4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80+SCREENWIDTH*2.19+SCREENWIDTH*0.824, SCREENWIDTH, SCREENWIDTH*1.042)];
    [footImage4 setImage:[UIImage imageNamed:@"red_wine_for4"]];
    [footView addSubview:footImage4];
   
    _tableView.tableFooterView = footView;
    
    [_tableView reloadData];
}
#pragma mark cell里的加入购物车
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    
    if (sender.tag %2 == 0) {
        CassegrainWineryLeftTableViewCell *cell = (CassegrainWineryLeftTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }else{
        CassegrainWineryRightTableViewCell *cell = (CassegrainWineryRightTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[sender.tag]];
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
