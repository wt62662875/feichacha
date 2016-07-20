//
//  braisedFoodViewController.m
//  feichacha
//
//  Created by wt on 16/5/12.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "braisedFoodViewController.h"
#import "braisedFoodTableViewCell1.h"
#import "braisedFoodTableViewCell2.h"
#import "baseViewController.h"

@interface braisedFoodViewController ()
{
    UIView *navigationView;
    
    float classHeadViewY1;
    float classHeadViewY2;
    float classHeadViewY3;


    UIButton *navButton1;
    UIButton *navButton2;
    UIButton *navButton3;

    NSArray *allDatas;
    NSArray * datas1;
    NSArray * datas2;
    NSArray * datas3;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@end

@implementation braisedFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    [self initNavigationView];
    [self ActivityListDatas];
    // Do any additional setup after loading the view from its nib.
}
-(void)ActivityListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] ActivityList:[_getDatas objectForKey:@"Id"] ActType:[_getDatas objectForKey:@"ActType"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            allDatas = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ActivityProductClass"];
            datas1 = [allDatas[0] objectForKey:@"ActivityProduct"];
            datas2 = [allDatas[1] objectForKey:@"ActivityProduct"];
            datas3 = [allDatas[2] objectForKey:@"ActivityProduct"];
            classHeadViewY1 = SCREENWIDTH*0.486;

            classHeadViewY2 = classHeadViewY1 +61+132*datas1.count;
            if (datas2.count %2 == 0) {
                classHeadViewY3 = classHeadViewY2 +61+(SCREENWIDTH/2+100)*(datas2.count/2);
            }else{
                classHeadViewY3 = classHeadViewY2 +61+(SCREENWIDTH/2+100)*(datas2.count/2+1);
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
    if (section == 0) {
        return datas1.count;
    }
    if (section == 1) {
        if (datas2.count %2 == 0) {
            return  datas2.count/2;
        }else{
            return  datas2.count/2+1;
        }
    }
    if (datas3.count %2 == 0) {
        return  datas3.count/2;
    }else{
        return  datas3.count/2+1;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 132;
    }else{
        return SCREENWIDTH/2+100;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"braisedFoodTableViewCell1";
        braisedFoodTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"braisedFoodTableViewCell1" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas1[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name.text = [datas1[indexPath.row] objectForKey:@"Name"];
        cell.specifications.text = [datas1[indexPath.row] objectForKey:@"Size"];
        cell.price.text = [NSString stringWithFormat:@"￥%@",[datas1[indexPath.row] objectForKey:@"Price"]];
        
        cell.oldPrice.hidden = YES;
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsClick.tag = indexPath.row;
        [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }else{
        static NSString *cellIdentifier = @"braisedFoodTableViewCell2";
        braisedFoodTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"braisedFoodTableViewCell2" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.section == 1) {
            [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas2[indexPath.row*2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName1.text = [datas2[indexPath.row*2] objectForKey:@"Name"];
            cell.goodsSpecifications1.text = [datas2[indexPath.row*2] objectForKey:@"Size"];
            cell.price1.text = [NSString stringWithFormat:@"%@",[datas2[indexPath.row*2] objectForKey:@"Price"]];
            if (datas2.count %2 != 0 && datas2.count/2 == indexPath.row) {
                cell.backView2.hidden = YES;
            }else{
                [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas2[indexPath.row*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
                cell.goodsName2.text = [datas2[indexPath.row*2+1] objectForKey:@"Name"];
                cell.goodsSpecifications2.text = [datas2[indexPath.row*2+1] objectForKey:@"Size"];
                cell.price2.text = [NSString stringWithFormat:@"%@",[datas2[indexPath.row*2+1] objectForKey:@"Price"]];
            }
        }else{
            [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas3[indexPath.row*2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName1.text = [datas3[indexPath.row*2] objectForKey:@"Name"];
            cell.goodsSpecifications1.text = [datas3[indexPath.row*2] objectForKey:@"Size"];
            cell.price1.text = [NSString stringWithFormat:@"%@",[datas3[indexPath.row*2] objectForKey:@"Price"]];
            
            if (datas3.count %2 != 0 && datas3.count/2 == indexPath.row) {
                cell.backView2.hidden = YES;
            }else{
                [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas3[indexPath.row*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
                cell.goodsName2.text = [datas3[indexPath.row*2+1] objectForKey:@"Name"];
                cell.goodsSpecifications2.text = [datas3[indexPath.row*2+1] objectForKey:@"Size"];
                cell.price2.text = [NSString stringWithFormat:@"%@",[datas3[indexPath.row*2+1] objectForKey:@"Price"]];
            }
        }
        
        cell.goodsOldPrice1.hidden = YES;
        cell.goodsOldPrice2.hidden = YES;
        [cell.buyButton1 addTarget:self action:@selector(buyButton1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buyButton2 addTarget:self action:@selector(buyButton2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsClick1 addTarget:self action:@selector(goodsClick1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsClick2 addTarget:self action:@selector(goodsClick2:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 61;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 92)];
    headView.backgroundColor = RGBCOLORA(248, 242, 226, 1);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-59, -4, 118, 61)];
    [image setImage:[UIImage imageNamed:@"cooked_title"]];
    [headView addSubview:image];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-59, 0, 118, 61)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBCOLORA(248, 242, 226, 1);
    if (section == 0) {
        label.text = @"今日爆品";
    }else if (section == 1) {
        label.text = @"百年卤味";
    }else if (section == 2) {
        label.text = @"陈麻麻";
    }
    [headView addSubview:label];
    
    return headView;
}

#pragma mark 横排购买
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    braisedFoodTableViewCell1 *cell = (braisedFoodTableViewCell1 *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas1[sender.tag]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark 竖排购买1
-(void)buyButton1:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    braisedFoodTableViewCell2 *cell = (braisedFoodTableViewCell2 *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    if (indexPath.section == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas2[indexPath.row*2]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas3[indexPath.row*2]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark 竖排购买2
-(void)buyButton2:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    braisedFoodTableViewCell2 *cell = (braisedFoodTableViewCell2 *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    if (indexPath.section == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas2[indexPath.row*2+1]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas3[indexPath.row*2+1]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
-(void)goodsClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:datas1[sender.tag]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsClick1:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section

    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
     [goodsDetailsVC setIsAct:@"1"];
    if (indexPath.section == 1) {
        [goodsDetailsVC setGetID:datas2[indexPath.row*2]];
    }else{
        [goodsDetailsVC setGetID:datas3[indexPath.row*2]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
}
-(void)goodsClick2:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
     [goodsDetailsVC setIsAct:@"1"];
    if (indexPath.section == 1) {
        [goodsDetailsVC setGetID:datas2[indexPath.row*2+1]];
    }else{
        [goodsDetailsVC setGetID:datas3[indexPath.row*2+1]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
}




// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    CGPoint point=scrollView.contentOffset;
    CGRect frame = [navigationView frame];
    if (point.y >= SCREENWIDTH*0.486) {
        frame.origin.y = 64;
    }else{
        frame.origin.y = SCREENWIDTH*0.486+64 - point.y;
    }
    navigationView.frame = frame;
    
    [navButton1 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton2 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton3 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];


    if (point.y >= classHeadViewY1 && point.y < classHeadViewY2) {
        [navButton1 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }else if (point.y >= classHeadViewY2 && point.y < classHeadViewY3){
        [navButton2 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }else if (point.y >= classHeadViewY3 ){
        [navButton3 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }
    
}
-(void)initNavigationView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.486+39)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.486)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/lw_banner.jpg"]];
    [headView addSubview:imageView];
    _tableView.tableHeaderView = headView;
    
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.486+64, SCREENWIDTH, 39)];
    navigationView.backgroundColor = RGBCOLORA(150, 2, 25, 1);
    

    navButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton1 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton1 setFrame:CGRectMake(0, 0, SCREENWIDTH/3, 39)];
    [navButton1 setTitle:@"今日爆品" forState:UIControlStateNormal];
    
    navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton2 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton2 setFrame:CGRectMake(SCREENWIDTH/3, 0, SCREENWIDTH/3, 39)];
    [navButton2 setTitle:@"百年卤味" forState:UIControlStateNormal];
    
    navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton3 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton3 setFrame:CGRectMake(SCREENWIDTH/3*2, 0, SCREENWIDTH/3, 39)];
    [navButton3 setTitle:@"陈麻麻" forState:UIControlStateNormal];
    
    navButton1.tag = 1;
    navButton2.tag = 2;
    navButton3.tag = 3;

    [navButton1 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton2 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton3 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];

    [navigationView addSubview:navButton1];
    [navigationView addSubview:navButton2];
    [navigationView addSubview:navButton3];



    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3, 0, 1, 39)];
    line2.backgroundColor = [UIColor blackColor];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3*2, 0, 1, 39)];
    line3.backgroundColor = [UIColor blackColor];
    [navigationView addSubview:line2];
    [navigationView addSubview:line3];
    
    
    [self.view addSubview:navigationView];
    
}
-(void)navButton:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY1+1) animated:YES];
            break;
        case 2:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY2+1) animated:YES];
            break;
        case 3:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY3+1) animated:YES];
            break;
        default:
            break;
    }
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
