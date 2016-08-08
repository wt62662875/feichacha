//
//  salesPromotionViewController.m
//  feichacha
//
//  Created by wt on 16/5/9.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "salesPromotionViewController.h"
#import "salesPromotionGoodsTableViewCell.h"
#import "salesPromotionClassView.h"
#import "newProductGoods2TableViewCell.h"
#import "baseViewController.h"

@interface salesPromotionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datas;
    NSMutableArray *lastDatas;
}
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation salesPromotionViewController

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
    [self initTableHeadView];
    [self PromotionsListDatas];

}
-(void)PromotionsListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] PromotionsList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[NSMutableArray alloc]init];
            datas = [responseObject objectForKey:@"AppendData"];
            if (datas.count<2) {
                lastDatas = [[NSMutableArray alloc]init];
            }else{
                lastDatas = [datas mutableCopy];
                [lastDatas removeObjectsInRange:NSMakeRange(0, 2)];
            }
            
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

    if (section == 2) {
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
    if (indexPath.section == 2) {
        return SCREENWIDTH/2+100;
    }
    return 124;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        static NSString *cellIdentifier = @"newProductGoods2TableViewCell";
        newProductGoods2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"newProductGoods2TableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = RGBCOLORA(239, 239, 239, 1);
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[lastDatas[indexPath.row*2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.goodsName1.text = [lastDatas[indexPath.row*2] objectForKey:@"Name"];
        cell.goodsSpecifications1.text = [lastDatas[indexPath.row*2] objectForKey:@"Size"];
        cell.price1.text = [NSString stringWithFormat:@"%@",[lastDatas[indexPath.row*2] objectForKey:@"Price"]];
        cell.goodsOldPrice1.text =[NSString stringWithFormat:@"原价:￥%@",[lastDatas[indexPath.row*2] objectForKey:@"PromotionPrice"]];
        cell.sellingLabel1.text = @"活动价：￥";
        if ([[lastDatas[indexPath.row*2] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton1.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton1 setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton1.userInteractionEnabled = NO;
        }
        
        if (lastDatas.count %2 != 0 && lastDatas.count/2 == indexPath.row) {
            cell.backView2.hidden = YES;
        }else{
            [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[lastDatas[indexPath.row*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName2.text = [lastDatas[indexPath.row*2+1] objectForKey:@"Name"];
            cell.goodsSpecifications2.text = [lastDatas[indexPath.row*2+1] objectForKey:@"Size"];
            cell.price2.text = [NSString stringWithFormat:@"%@",[lastDatas[indexPath.row*2+1] objectForKey:@"Price"]];
            cell.goodsOldPrice2.text =[NSString stringWithFormat:@"原价:￥%@",[lastDatas[indexPath.row*2+1] objectForKey:@"PromotionPrice"]];
            cell.sellinglbael2.text = @"活动价：￥";
            if ([[lastDatas[indexPath.row*2+1] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton2.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton2 setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton2.userInteractionEnabled = NO;
            }
        }
        
        [cell.buyButton1 setBackgroundColor:RGBCOLORA(246, 170, 0, 1)];
        [cell.buyButton2 setBackgroundColor:RGBCOLORA(246, 170, 0, 1)];
        [cell.buyButton1 addTarget:self action:@selector(buyButton1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buyButton2 addTarget:self action:@selector(buyButton2:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsClick.tag = indexPath.row;
        cell.goodsClick2.tag = indexPath.row;
        [cell.goodsClick addTarget:self action:@selector(goodsClick2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsClick2 addTarget:self action:@selector(goodsClick3:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    static NSString *cellIdentifier = @"salesPromotionGoodsTableViewCell";
    salesPromotionGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"salesPromotionGoodsTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.goodsName.text = [datas[0] objectForKey:@"Name"];
        cell.goodsSpecifications.text = [datas[0] objectForKey:@"Size"];
        cell.goodsPrice.text = [NSString stringWithFormat:@"%@",[datas[0] objectForKey:@"Price"]];
        cell.goodsOldPrice.text = [NSString stringWithFormat:@"原价￥%@",[datas[0] objectForKey:@"PromotionPrice"]];
        if ([[datas[0] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
    }else{
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.goodsName.text = [datas[1] objectForKey:@"Name"];
        cell.goodsSpecifications.text = [datas[1] objectForKey:@"Size"];
        cell.goodsPrice.text = [NSString stringWithFormat:@"%@",[datas[1] objectForKey:@"Price"]];
        cell.goodsOldPrice.text = [NSString stringWithFormat:@"原价￥%@",[datas[1] objectForKey:@"PromotionPrice"]];
        if ([[datas[1] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
    }
    
    
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.goodsClick.tag = indexPath.section;
    [cell.goodsClick addTarget:self action:@selector(goodsClick1:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
#pragma mark 横排商品购买
-(void)buyButton:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    salesPromotionGoodsTableViewCell *cell = (salesPromotionGoodsTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];

    if (indexPath.section == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: datas[0]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: datas[1]];
    }
    
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark 竖排商品购买1
-(void)buyButton1:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods2TableViewCell *cell = (newProductGoods2TableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: lastDatas[indexPath.row*2]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];

}
#pragma mark 竖排商品购买2
-(void)buyButton2:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods2TableViewCell *cell = (newProductGoods2TableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: lastDatas[indexPath.row*2+1]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
-(void)goodsClick1:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"0"];
    if (sender.tag == 0) {
        [goodsDetailsVC setGetID:datas[0]];
    }else{
        [goodsDetailsVC setGetID:datas[1]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
}
-(void)goodsClick2:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"0"];
    [goodsDetailsVC setGetID:lastDatas[sender.tag*2]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsClick3:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"0"];
    [goodsDetailsVC setGetID:lastDatas[sender.tag*2+1]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
#pragma mark 有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (datas.count == 0) {
        return 0;
    }
    if (datas.count == 1) {
        return 1;
    }
    if (lastDatas.count < 1) {
        return 2;
    }
    return 3;
}
#pragma mark 头有多高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 52;
}
#pragma mark 头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 52)];
    [headBackView setBackgroundColor:RGBCOLORA(239, 239, 239, 1)];
    salesPromotionClassView *headView = [[NSBundle mainBundle] loadNibNamed:@"salesPromotionClassView" owner:self options:nil][0];
    [headView setFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    if (section == 0) {
        headView.backgroundColor = RGBCOLORA(255, 100, 0, 1);
        [headView.iamge setImage:[UIImage imageNamed:@"sales_icon1"]];
        headView.message.text = @"每天10点 好货好价格";
    }else if(section == 1){
        headView.backgroundColor = RGBCOLORA(230, 27, 23, 1);
        [headView.iamge setImage:[UIImage imageNamed:@"sales_icon2"]];
        headView.message.text = @"最佳人气特惠榜单";
    }else if(section == 2){
        headView.backgroundColor = RGBCOLORA(246, 170, 0, 1);
        [headView.iamge setImage:[UIImage imageNamed:@"sales_icon3"]];
        headView.message.text = @"爆款直降区";
    }
    
    [headBackView addSubview:headView];
    return headBackView;
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 52;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
-(void)initTableHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.779)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:headView.frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/f_cx_banner.jpg"]];
    [headView addSubview:imageView];
    _tableView.tableHeaderView = headView;
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
