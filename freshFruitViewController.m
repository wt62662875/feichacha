//
//  freshFruitViewController.m
//  feichacha
//
//  Created by wt on 16/5/10.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "freshFruitViewController.h"
#import "freshFruitTableViewCell1.h"
#import "freshFruitTableViewCell2.h"
#import "baseViewController.h"

@interface freshFruitViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *navigationView;
    
    float classHeadViewY1;
    float classHeadViewY2;
    float classHeadViewY3;
    float classHeadViewY4;
    
    UIButton *navButton1;
    UIButton *navButton2;
    UIButton *navButton3;
    UIButton *navButton4;
    
    NSArray *allDatas;
    NSArray * datas1;
    NSArray * datas2;
    NSArray * datas3;
    NSArray * datas4;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation freshFruitViewController

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
            datas4 = [allDatas[3] objectForKey:@"ActivityProduct"];

            classHeadViewY1 = SCREENWIDTH*0.375;
            classHeadViewY2 = classHeadViewY1 +44+datas1.count*116;
            classHeadViewY3 = classHeadViewY2 +44+datas2.count*132;
            if (datas3.count %2 == 0) {
                classHeadViewY4 = classHeadViewY3 +44+(SCREENWIDTH/2+100)*(datas3.count/2);
            }else{
                classHeadViewY4 = classHeadViewY3 +44+(SCREENWIDTH/2+100)*(datas3.count/2+1);
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
    }else if (section == 1){
        return datas2.count;
    }else if(section == 2){
        if (datas3.count %2 == 0) {
            return datas3.count/2;
        }else{
            return datas3.count/2+1;
        }
    }
    if (datas4.count %2 == 0) {
        return datas4.count/2;
    }else{
        return datas4.count/2+1;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 116;
    }else if (indexPath.section == 1){
        return 132;
    }else{
        return SCREENWIDTH/2+100;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row %2 == 0) {
            static NSString *cellIdentifier = @"freshFruitRightTableViewCell";
            freshFruitRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"freshFruitRightTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas1[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.name.text = [datas1[indexPath.row] objectForKey:@"Name"];
            cell.specifications.text = [datas1[indexPath.row] objectForKey:@"Size"];
            cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[datas1[indexPath.row] objectForKey:@"Price"] floatValue]];
            if ([[datas1[indexPath.row] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton.userInteractionEnabled = NO;
            }
            
            cell.oldPrice.hidden = YES;
            cell.buyButton.tag = indexPath.row;
            [cell.buyButton addTarget:self action:@selector(buyButton0:) forControlEvents:UIControlEventTouchUpInside];
            cell.goodsClick.tag = indexPath.row;
            [cell.goodsClick addTarget:self action:@selector(goodsClick0:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            static NSString *cellIdentifier = @"freshFruitLeftTableViewCell";
            freshFruitLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"freshFruitLeftTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas1[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.name.text = [datas1[indexPath.row] objectForKey:@"Name"];
            cell.specifications.text = [datas1[indexPath.row] objectForKey:@"Size"];
            cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[datas1[indexPath.row] objectForKey:@"Price"] floatValue]];
            if ([[datas1[indexPath.row] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton.userInteractionEnabled = NO;
            }
            
            cell.oldPrice.hidden = YES;
            cell.buyButton.tag = indexPath.row;
            [cell.buyButton addTarget:self action:@selector(buyButton0:) forControlEvents:UIControlEventTouchUpInside];
            cell.goodsClick.tag = indexPath.row;
            [cell.goodsClick addTarget:self action:@selector(goodsClick0:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }
    }else if(indexPath.section == 1){
        static NSString *cellIdentifier = @"freshFruitTableViewCell1";
        freshFruitTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"freshFruitTableViewCell1" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas2[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name.text = [datas2[indexPath.row] objectForKey:@"Name"];
        cell.specifications.text = [datas2[indexPath.row] objectForKey:@"Size"];
        cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[datas2[indexPath.row] objectForKey:@"Price"] floatValue]];
        if ([[datas2[indexPath.row] objectForKey:@"Stock"] intValue] == 0) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
        
        cell.oldPrice.hidden = YES;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else{
        static NSString *cellIdentifier = @"freshFruitTableViewCell2";
        freshFruitTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"freshFruitTableViewCell2" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.section == 2) {
            [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas3[indexPath.row*2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName1.text = [datas3[indexPath.row*2] objectForKey:@"Name"];
            cell.goodsSpecifications1.text = [datas3[indexPath.row*2] objectForKey:@"Size"];
            cell.price1.text = [NSString stringWithFormat:@"%@",[datas3[indexPath.row*2] objectForKey:@"Price"]];
            if ([[datas3[indexPath.row*2] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton1.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton1 setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton1.userInteractionEnabled = NO;
            }

            if (datas3.count %2 != 0 && datas3.count/2 == indexPath.row) {
                cell.backView2.hidden = YES;
            }else{
                [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas3[indexPath.row*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
                cell.goodsName2.text = [datas3[indexPath.row*2+1] objectForKey:@"Name"];
                cell.goodsSpecifications2.text = [datas3[indexPath.row*2+1] objectForKey:@"Size"];
                cell.price2.text = [NSString stringWithFormat:@"%@",[datas3[indexPath.row*2+1] objectForKey:@"Price"]];
                if ([[datas3[indexPath.row*2+1] objectForKey:@"Stock"] intValue] == 0) {
                    cell.buyButton2.backgroundColor = [UIColor lightGrayColor];
                    [cell.buyButton2 setTitle:@"已抢光" forState:UIControlStateNormal];
                    cell.buyButton2.userInteractionEnabled = NO;
                }
            }
        }else{
            [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas4[indexPath.row*2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName1.text = [datas4[indexPath.row*2] objectForKey:@"Name"];
            cell.goodsSpecifications1.text = [datas4[indexPath.row*2] objectForKey:@"Size"];
            cell.price1.text = [NSString stringWithFormat:@"%@",[datas4[indexPath.row*2] objectForKey:@"Price"]];
            if ([[datas4[indexPath.row*2] objectForKey:@"Stock"] intValue] == 0) {
                cell.buyButton1.backgroundColor = [UIColor lightGrayColor];
                [cell.buyButton1 setTitle:@"已抢光" forState:UIControlStateNormal];
                cell.buyButton1.userInteractionEnabled = NO;
            }
            if (datas4.count %2 != 0 && datas4.count/2 == indexPath.row) {
                cell.backView2.hidden = YES;
            }else{
                [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas4[indexPath.row*2+1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
                cell.goodsName2.text = [datas4[indexPath.row*2+1] objectForKey:@"Name"];
                cell.goodsSpecifications2.text = [datas4[indexPath.row*2+1] objectForKey:@"Size"];
                cell.price2.text = [NSString stringWithFormat:@"%@",[datas4[indexPath.row*2+1] objectForKey:@"Price"]];
                if ([[datas4[indexPath.row*2+1] objectForKey:@"Stock"] intValue] == 0) {
                    cell.buyButton2.backgroundColor = [UIColor lightGrayColor];
                    [cell.buyButton2 setTitle:@"已抢光" forState:UIControlStateNormal];
                    cell.buyButton2.userInteractionEnabled = NO;
                }
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
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    if (section == 0) {
        [self initSectionLabel:sectionHeadView labelText:@"小编热荐"];
    }else if(section == 1){
        [self initSectionLabel:sectionHeadView labelText:@"新鲜上市"];
    }else if(section == 2){
        [self initSectionLabel:sectionHeadView labelText:@"进口水果"];
    }else{
        [self initSectionLabel:sectionHeadView labelText:@"整箱购"];
    }
    
    return sectionHeadView;
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
    if (point.y >= SCREENWIDTH*0.375) {
        frame.origin.y = 64;
    }else{
        frame.origin.y = SCREENWIDTH*0.375+64 - point.y;
    }
    navigationView.frame = frame;
    
    [navButton1 setImage:nil forState:UIControlStateNormal];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2 setImage:nil forState:UIControlStateNormal];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3 setImage:nil forState:UIControlStateNormal];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4 setImage:nil forState:UIControlStateNormal];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (point.y >= classHeadViewY1 && point.y < classHeadViewY2) {
        [navButton1 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
        [navButton1 setTitleColor:RGBCOLORA(217, 231, 53, 1)forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY2 && point.y < classHeadViewY3){
        [navButton2 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
        [navButton2 setTitleColor:RGBCOLORA(217, 231, 53, 1)forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY3 && point.y < classHeadViewY4){
        [navButton3 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
        [navButton3 setTitleColor:RGBCOLORA(217, 231, 53, 1)forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY4 ){
        [navButton4 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
        [navButton4 setTitleColor:RGBCOLORA(217, 231, 53, 1)forState:UIControlStateNormal];
    }
    
}

-(void)initNavigationView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.375+39)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.375)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/ms_banner.jpg"]];
    [headView addSubview:imageView];
    _tableView.tableHeaderView = headView;
    
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.375+64, SCREENWIDTH, 39)];
    
    navButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton1 setBackgroundColor:RGBCOLORA(106, 139, 0, 1)];
    [navButton1 setFrame:CGRectMake(0, 0, SCREENWIDTH/4, 39)];
    [navButton1 setTitle:@"小编热荐" forState:UIControlStateNormal];
    
    navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton2 setBackgroundColor:RGBCOLORA(106, 139, 0, 1)];
    [navButton2 setFrame:CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 39)];
    [navButton2 setTitle:@"新鲜上市" forState:UIControlStateNormal];
    
    navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton3 setBackgroundColor:RGBCOLORA(106, 139, 0, 1)];
    [navButton3 setFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/4, 39)];
    [navButton3 setTitle:@"进口水果" forState:UIControlStateNormal];
    
    navButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton4 setBackgroundColor:RGBCOLORA(106, 139, 0, 1)];
    [navButton4 setFrame:CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 39)];
    [navButton4 setTitle:@"整箱购" forState:UIControlStateNormal];
    
    navButton1.tag = 1;
    navButton2.tag = 2;
    navButton3.tag = 3;
    navButton4.tag = 4;
    
    [navButton1 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton2 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton3 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton4 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:navButton1];
    [navigationView addSubview:navButton2];
    [navigationView addSubview:navButton3];
    [navigationView addSubview:navButton4];
    
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
        case 4:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY4+1) animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark 初始化section的label
//number 总数   location  第几个字
-(void)initSectionLabel:(UIView *)sctionView labelText:(NSString *)labelText {
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(50, 22, SCREENWIDTH/2-110, 1)];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+65, 22, SCREENWIDTH/2-110, 1)];
    lineView1.backgroundColor = RGBCOLORA(100, 161, 40, 1);
    lineView2.backgroundColor = RGBCOLORA(100, 161, 40, 1);
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = RGBCOLORA(100, 161, 40, 1);
    label1.layer.cornerRadius = 15;
    label1.layer.masksToBounds = YES;
    label1.font = [UIFont systemFontOfSize:15];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.backgroundColor = RGBCOLORA(100, 161, 40, 1);
    label2.layer.cornerRadius = 15;
    label2.layer.masksToBounds = YES;
    label2.font = [UIFont systemFontOfSize:15];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.backgroundColor = RGBCOLORA(100, 161, 40, 1);
    label3.layer.cornerRadius = 15;
    label3.layer.masksToBounds = YES;
    label3.font = [UIFont systemFontOfSize:15];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.backgroundColor = RGBCOLORA(100, 161, 40, 1);
    label4.layer.cornerRadius = 15;
    label4.layer.masksToBounds = YES;
    label4.font = [UIFont systemFontOfSize:15];
    
    if (labelText.length == 3) {
        label1.text = [labelText substringWithRange:NSMakeRange(0, 1)];
        [label1 setFrame:CGRectMake(SCREENWIDTH/2-40, 6, 30, 30)];

        label2.text = [labelText substringWithRange:NSMakeRange(1, 1)];
        [label2 setFrame:CGRectMake(SCREENWIDTH/2-15, 6, 30, 30)];

        label3.text = [labelText substringWithRange:NSMakeRange(2, 1)];
        [label3 setFrame:CGRectMake(SCREENWIDTH/2+10, 6, 30, 30)];

    }else{
        label1.text = [labelText substringWithRange:NSMakeRange(0, 1)];
        label2.text = [labelText substringWithRange:NSMakeRange(1, 1)];
        label3.text = [labelText substringWithRange:NSMakeRange(2, 1)];
        label4.text = [labelText substringWithRange:NSMakeRange(3, 1)];

        [label1 setFrame:CGRectMake(SCREENWIDTH/2-50, 6, 30, 30)];
        [label2 setFrame:CGRectMake(SCREENWIDTH/2-25, 6, 30, 30)];
        [label3 setFrame:CGRectMake(SCREENWIDTH/2, 6, 30, 30)];
        [label4 setFrame:CGRectMake(SCREENWIDTH/2+25, 6, 30, 30)];
        }
    
    [sctionView addSubview:label1];
    [sctionView addSubview:label2];
    [sctionView addSubview:label3];
    [sctionView addSubview:label4];
    [sctionView addSubview:lineView1];
    [sctionView addSubview:lineView2];
}

#pragma mark section0
-(void)buyButton0:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    freshFruitRightTableViewCell *cell = (freshFruitRightTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas1[sender.tag]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark 中间cell
-(void)buyButton:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    freshFruitTableViewCell1 *cell = (freshFruitTableViewCell1 *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas2[indexPath.row]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark button1
-(void)buyButton1:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    freshFruitTableViewCell2 *cell = (freshFruitTableViewCell2 *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    if (indexPath.section == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas3[indexPath.row*2]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas4[indexPath.row*2]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark button2
-(void)buyButton2:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    freshFruitTableViewCell2 *cell = (freshFruitTableViewCell2 *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    if (indexPath.section == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas3[indexPath.row*2+1]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas4[indexPath.row*2+1]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
-(void)goodsClick0:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:datas1[sender.tag]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];

}
-(void)goodsClick:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:datas2[indexPath.row]];
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
    if (indexPath.section == 2) {
        [goodsDetailsVC setGetID:datas3[indexPath.row*2]];
    }else{
        [goodsDetailsVC setGetID:datas4[indexPath.row*2]];
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
    if (indexPath.section == 2) {
        [goodsDetailsVC setGetID:datas3[indexPath.row*2+1]];
    }else{
        [goodsDetailsVC setGetID:datas4[indexPath.row*2+1]];
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
