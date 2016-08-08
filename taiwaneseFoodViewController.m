//
//  taiwaneseFoodViewController.m
//  feichacha
//
//  Created by wt on 16/5/20.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "taiwaneseFoodViewController.h"
#import "baseViewController.h"
#import "taiwaneseFoodTableViewCell.h"
#import "goodsDetailsViewController.h"

@interface taiwaneseFoodViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datas;
    NSMutableArray *lastDatas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;


@end

@implementation taiwaneseFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENWIDTH*0.509)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:tableHeadView.frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/twms_banner.png"]];
    [tableHeadView addSubview:imageView];
    _tableView.tableHeaderView = tableHeadView;
    
    [self ActivityListDatas];
}
-(void)ActivityListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] ActivityList:[_getDatas objectForKey:@"Id"] ActType:[_getDatas objectForKey:@"ActType"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[NSMutableArray alloc]init];
            datas = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ActivityProduct"];
            lastDatas = [datas mutableCopy];
            [lastDatas removeObjectsInRange:NSMakeRange(0, 2)];
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
    if (section == 1) {
        if ((lastDatas.count)%2 == 0) {
            return lastDatas.count/2;
        }else{
            return lastDatas.count/2+1;
        }
    }
    return 1;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH/2+37-8;
}

#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"taiwaneseFoodTableViewCell";
    taiwaneseFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"taiwaneseFoodTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name1.text = [datas[0] objectForKey:@"Name"];
        cell.price1.text = [NSString stringWithFormat:@"￥%.1f",[[datas[0] objectForKey:@"Price"] floatValue]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name2.text = [datas[1] objectForKey:@"Name"];
        cell.price2.text = [NSString stringWithFormat:@"￥%.1f",[[datas[1] objectForKey:@"Price"] floatValue]];
        if ([[datas[1] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
        cell.roundView.layer.cornerRadius = 7;
    }else{
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[lastDatas[indexPath.row*2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name1.text = [lastDatas[indexPath.row*2] objectForKey:@"Name"];
        cell.price1.text = [NSString stringWithFormat:@"￥%.1f",[[lastDatas[indexPath.row*2] objectForKey:@"Price"] floatValue]];
        if ([[lastDatas[indexPath.row*2] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
        if (lastDatas.count %2 != 0 && lastDatas.count/2 == indexPath.row) {
            cell.backView2.hidden = YES;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREENWIDTH-16, SCREENWIDTH/2+37-8) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.roundView.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.roundView.layer.mask  = maskLayer;
        }else{
            [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[lastDatas[indexPath.row*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.name2.text = [lastDatas[indexPath.row*2+1] objectForKey:@"Name"];
            cell.price2.text = [NSString stringWithFormat:@"￥%.1f",[[lastDatas[indexPath.row*2+1] objectForKey:@"Price"] floatValue]];
            if ([[lastDatas[indexPath.row*2+1] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton2.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton2 setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton2.userInteractionEnabled = NO;
            }
            
            if (indexPath.row == 0) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREENWIDTH-16, SCREENWIDTH/2+37-8) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = cell.roundView.bounds;
                maskLayer.path = maskPath.CGPath;
                cell.roundView.layer.mask  = maskLayer;
            }
        }
    }
    
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buyButton2 addTarget:self action:@selector(buyButton2:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goodsClick2 addTarget:self action:@selector(goodsClick2:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    headView.backgroundColor = RGBCOLORA(5, 145, 2, 1);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-55, 16, 110, 44)];
    if (section == 0) {
        [imageView setImage:[UIImage imageNamed:@"tw_title"]];
    }else{
        [imageView setImage:[UIImage imageNamed:@"tw_title1"]];
    }
    [headView addSubview:imageView];
    
    
    return headView;
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat sectionHeaderHeight = 60;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)buyButton:(UIButton*)sender{

    UIView *temp = [[[[sender superview] superview] superview] superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    taiwaneseFoodTableViewCell *cell = (taiwaneseFoodTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.image1 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];

    if (indexPath.section == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[0]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:lastDatas[indexPath.row*2]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
-(void)buyButton2:(UIButton*)sender{
    UIView *temp = [[[[sender superview] superview] superview] superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    taiwaneseFoodTableViewCell *cell = (taiwaneseFoodTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.image2 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    if (indexPath.section == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[1]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:lastDatas[indexPath.row*2+1]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
-(void)goodsClick:(UIButton *)sender{
    UIView *temp = [[[sender superview] superview] superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    if (indexPath.section == 0) {
        [goodsDetailsVC setGetID:datas[0]];
    }else{
        [goodsDetailsVC setGetID:lastDatas[indexPath.row*2]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsClick2:(UIButton *)sender{
    UIView *temp = [[[sender superview] superview] superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    if (indexPath.section == 0) {
        [goodsDetailsVC setGetID:datas[1]];
    }else{
        [goodsDetailsVC setGetID:lastDatas[indexPath.row*2+1]];
    }
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
