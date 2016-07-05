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
    // Do any additional setup after loading the view.
    [self newListDatas];
}
-(void)newListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] newList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
//        NSLog(@"数据:%@",responseObject);
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
            cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",[datas[0] objectForKey:@"Price"]];
        }else if (indexPath.row == 3) {
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName.text = [datas[1] objectForKey:@"Name"];
            cell.goodsMessage.text = [datas[1] objectForKey:@"Size"];
            cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",[datas[1] objectForKey:@"Price"]];
        }else if (indexPath.row == 4) {
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName.text = [datas[2] objectForKey:@"Name"];
            cell.goodsMessage.text = [datas[2] objectForKey:@"Size"];
            cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",[datas[2] objectForKey:@"Price"]];
        }
        
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
        cell.price1.text = [NSString stringWithFormat:@"￥%@",[lastDatas[(indexPath.row-6)*2] objectForKey:@"Price"]];

        if (lastDatas.count %2 != 0 && lastDatas.count/2 == indexPath.row-6) {
            cell.backView2.hidden = YES;
        }else{
            [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[lastDatas[(indexPath.row-6)*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName2.text = [lastDatas[(indexPath.row-6)*2+1] objectForKey:@"Name"];
            cell.goodsSpecifications2.text = [lastDatas[(indexPath.row-6)*2+1] objectForKey:@"Size"];
            cell.price2.text = [NSString stringWithFormat:@"￥%@",[lastDatas[(indexPath.row-6)*2+1] objectForKey:@"Price"]];

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

        return cell;
    }
}
#pragma mark 横排商品购买
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods1TableViewCell *cell = (newProductGoods1TableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];

}
#pragma mark 竖排商品购买1
-(void)buyButton1:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods2TableViewCell *cell = (newProductGoods2TableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
}
#pragma mark 竖排商品购买2
-(void)buyButton2:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    newProductGoods2TableViewCell *cell = (newProductGoods2TableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
}
-(void)initHeadView{
    UIView *headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.5519+16)];
    headView.backgroundColor = RGBCOLORA(252, 234, 222, 1);
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.5519)];
    [image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/news_index_banner.jpg"]];
    
    
    [headView addSubview:image];
    _tableView.tableHeaderView = headView;
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
