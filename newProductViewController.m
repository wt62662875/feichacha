//
//  newProductViewController.m
//  feichacha
//
//  Created by wt on 16/5/8.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "newProductViewController.h"
#import "newProductTitleTableViewCell.h"
#import "newProductGoods1TableViewCell.h"
#import "newProductGoods2TableViewCell.h"
#import "baseViewController.h"


@interface newProductViewController ()
{
    NSMutableArray *datas;
    NSMutableArray *lastDatas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;


@end

@implementation newProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    // Do any additional setup after loading the view.
    [self newListDatas];
}
-(void)newListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] newList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[NSMutableArray alloc]init];
            datas = [responseObject objectForKey:@"AppendData"];
            lastDatas = [datas mutableCopy];
            [lastDatas removeObjectsInRange:NSMakeRange(0, 3)];

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
    if ((lastDatas.count)%2 == 0) {
        return 6+(lastDatas.count)/2;
    }else{
        return 6+(lastDatas.count)/2+1;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2 ) {
        return 70;
    }
    if (indexPath.row == 5) {
        return 49;
    }
    if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4) {
        return 150;
    }
    return SCREENWIDTH/2+100;
    
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4) {
        static NSString *cellIdentifier = @"newProductGoods1TableViewCell";
        newProductGoods1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"newProductGoods1TableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 1) {
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName.text = [datas[0] objectForKey:@"Name"];
            cell.goodsMessage.text = [datas[0] objectForKey:@"Size"];
            cell.goodsPrice.text = [NSString stringWithFormat:@"￥%.1f",[[datas[0] objectForKey:@"Price"] floatValue]];
            if ([[datas[0] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton.userInteractionEnabled = NO;
            }
        }else if (indexPath.row == 3) {
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName.text = [datas[1] objectForKey:@"Name"];
            cell.goodsMessage.text = [datas[1] objectForKey:@"Size"];
            cell.goodsPrice.text = [NSString stringWithFormat:@"￥%.1f",[[datas[1] objectForKey:@"Price"] floatValue]];
            if ([[datas[1] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton.userInteractionEnabled = NO;
            }
        }else if (indexPath.row == 4) {
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName.text = [datas[2] objectForKey:@"Name"];
            cell.goodsMessage.text = [datas[2] objectForKey:@"Size"];
            cell.goodsPrice.text = [NSString stringWithFormat:@"￥%.1f",[[datas[2] objectForKey:@"Price"] floatValue]];
            if ([[datas[1] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton.userInteractionEnabled = NO;
            }
        }
        
        cell.goodsMessage2.hidden = YES;
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsClick.tag = indexPath.row;
        [cell.goodsClick addTarget:self action:@selector(goodsClick1:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if ((indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5)) {
        static NSString *cellIdentifier = @"newProductTitleTableViewCell";
        newProductTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"newProductTitleTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            cell.moreLabel.text = @"FRUIT";
        }else if (indexPath.row == 2) {
            cell.moreLabel.text = @"NEW";
        }else if (indexPath.row == 5) {
            cell.moreLabel.text = @"MORE";
        }
        cell.message3.hidden = YES;
        if (indexPath.row == 5) {
            cell.message1.hidden = YES;
            cell.message2.hidden = YES;
            cell.message3.hidden = NO;
        }
        if (indexPath.row == 2) {
            cell.backView.backgroundColor = RGBCOLORA(207, 174, 167, 1);
            cell.message1.text = @"春意暖暖 吃心大开";
            cell.message2.text = @"今日上线新品";
        }
        
        
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"newProductGoods2TableViewCell";
        newProductGoods2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"newProductGoods2TableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[lastDatas[(indexPath.row-6)*2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.goodsName1.text = [lastDatas[(indexPath.row-6)*2] objectForKey:@"Name"];
        cell.goodsSpecifications1.text = [lastDatas[(indexPath.row-6)*2] objectForKey:@"Size"];
        cell.price1.text = [NSString stringWithFormat:@"￥%.1f",[[lastDatas[(indexPath.row-6)*2] objectForKey:@"Price"] floatValue]];
        if ([[lastDatas[(indexPath.row-6)*2] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton1.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton1 setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton1.userInteractionEnabled = NO;
        }

        if (lastDatas.count %2 != 0 && lastDatas.count/2 == indexPath.row-6) {
            cell.backView2.hidden = YES;
        }else{
            [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[lastDatas[(indexPath.row-6)*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName2.text = [lastDatas[(indexPath.row-6)*2+1] objectForKey:@"Name"];
            cell.goodsSpecifications2.text = [lastDatas[(indexPath.row-6)*2+1] objectForKey:@"Size"];
            cell.price2.text = [NSString stringWithFormat:@"￥%.1f",[[lastDatas[(indexPath.row-6)*2+1] objectForKey:@"Price"] floatValue]];
            if ([[lastDatas[(indexPath.row-6)*2+1] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton2.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton2 setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton2.userInteractionEnabled = NO;
            }
        }

        
        cell.goodsOldPrice1.hidden = YES;
        cell.goodsOldPrice2.hidden = YES;
//        /**
//         老价格加下划线
//         **/
//        NSString *oldPrice = @"原价：5.28";
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
//        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, oldPrice.length)];
//        [cell.goodsOldPrice1 setAttributedText:attri];
//        [cell.goodsOldPrice2 setAttributedText:attri];
    
        cell.buyButton1.tag = indexPath.row;
        cell.buyButton2.tag = indexPath.row;
        [cell.buyButton1 addTarget:self action:@selector(buyButton1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buyButton2 addTarget:self action:@selector(buyButton2:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsClick.tag = indexPath.row;
        cell.goodsClick2.tag = indexPath.row;
        [cell.goodsClick addTarget:self action:@selector(goodsClick2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsClick2 addTarget:self action:@selector(goodsClick3:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
#pragma mark 横排商品购买
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods1TableViewCell *cell = (newProductGoods1TableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    if (sender.tag == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: datas[0]];
    }else if (sender.tag == 3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: datas[1]];
    }else if (sender.tag == 4) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: datas[2]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];

}
#pragma mark 竖排商品购买1
-(void)buyButton1:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods2TableViewCell *cell = (newProductGoods2TableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: lastDatas[(sender.tag-6)*2]];
     _badgeLabel.hidden = NO;
     _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark 竖排商品购买2
-(void)buyButton2:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods2TableViewCell *cell = (newProductGoods2TableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object: lastDatas[(sender.tag-6)*2+1]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
-(void)goodsClick1:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    if (sender.tag == 1) {
        [goodsDetailsVC setGetID:datas[0]];
    }else if (sender.tag == 3) {
        [goodsDetailsVC setGetID:datas[1]];
    }else if (sender.tag == 4) {
        [goodsDetailsVC setGetID:datas[2]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];

}
-(void)goodsClick2:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:lastDatas[(sender.tag-6)*2]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsClick3:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:lastDatas[(sender.tag-6)*2+1]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)initHeadView{
    UIView *headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.5519+16)];
    headView.backgroundColor = RGBCOLORA(252, 234, 222, 1);
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.5519)];
    [image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/news_index_banner.jpg"]];
    
    
    [headView addSubview:image];
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
