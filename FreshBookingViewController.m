//
//  FreshBookingViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "FreshBookingViewController.h"
#import "freshBookingTableViewCell.h"
#import "bookClassificationViewController.h"
#import "flowersCakeViewController.h"
#import "sangariaViewController.h"
#import "FCLpurchaseViewController.h"
#import "KopiLuwakViewController.h"
#import "FiletMignonViewController.h"
#import "redWineViewController.h"
#import "goodsDetailsViewController.h"


@interface FreshBookingViewController ()<SDCycleScrollViewDelegate>
{
    NSArray *topDatas;
    NSArray *midDatas;
    
    NSInteger selectTag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FreshBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self FreshScrollDatas];
}
-(void)FreshScrollDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] FreshScroll:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
//        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            topDatas = [[NSArray alloc]init];
            topDatas = [responseObject objectForKey:@"AppendData"];
            [self initTableView];
            [_tableView reloadData];
            [self FreshListDatas];
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)FreshListDatas{
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] FreshList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
            NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            midDatas = [[NSArray alloc]init];
            midDatas = [responseObject objectForKey:@"AppendData"];
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
    return midDatas.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH*0.411+190;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"freshBookingTableViewCell";
    freshBookingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"freshBookingTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.bannerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[midDatas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"index-4-1"]];
    cell.bannerButton.tag = indexPath.row;
    [cell.bannerButton addTarget:self action:@selector(onClickbannerImage:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *freshArray = [midDatas[indexPath.row] objectForKey:@"FreshCompany"];
    if (freshArray.count == 0) {
        cell.titleLabel1.hidden = YES;
        cell.name1.hidden = YES;
        cell.message1.hidden = YES;
        cell.specifications1.hidden = YES;
        cell.goodsImage1.hidden = YES;
        cell.goodsButton1.hidden = YES;

        cell.titleLabel2.hidden = YES;
        cell.name2.hidden = YES;
        cell.message2.hidden = YES;
        cell.specifications2.hidden = YES;
        cell.goodsImage2.hidden = YES;
        cell.goodsButton2.hidden = YES;
        
        cell.titleLabel3.hidden = YES;
        cell.name3.hidden = YES;
        cell.message3.hidden = YES;
        cell.specifications3.hidden = YES;
        cell.goodsImage3.hidden = YES;
        cell.goodsButton3.hidden = YES;
    }else if (freshArray.count == 1) {
        cell.titleLabel2.hidden = YES;
        cell.name2.hidden = YES;
        cell.message2.hidden = YES;
        cell.specifications2.hidden = YES;
        cell.goodsImage2.hidden = YES;
        cell.goodsButton2.hidden = YES;
        
        cell.titleLabel3.hidden = YES;
        cell.name3.hidden = YES;
        cell.message3.hidden = YES;
        cell.specifications3.hidden = YES;
        cell.goodsImage3.hidden = YES;
        cell.goodsButton3.hidden = YES;
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.titleLabel1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"ClassId"];
        cell.name1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Name"];
        cell.message1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Size"];
        cell.specifications1.text = [NSString stringWithFormat:@"￥%.1f",[[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Price"] floatValue]];
    }else if (freshArray.count == 2) {
        cell.titleLabel3.hidden = YES;
        cell.name3.hidden = YES;
        cell.message3.hidden = YES;
        cell.specifications3.hidden = YES;
        cell.goodsImage3.hidden = YES;
        cell.goodsButton3.hidden = YES;
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.titleLabel1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"ClassId"];
        cell.titleLabel2.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"ClassId"];
        cell.name1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Name"];
        cell.name2.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"Name"];
        cell.message1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Size"];
        cell.message2.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"Size"];
        cell.specifications1.text = [NSString stringWithFormat:@"￥%.1f",[[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Price"] floatValue]];
        cell.specifications2.text = [NSString stringWithFormat:@"￥%.1f",[[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"Price"] floatValue]];
    }else{
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        
        cell.titleLabel1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"ClassId"];
        cell.titleLabel2.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"ClassId"];
        cell.titleLabel3.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][2] objectForKey:@"ClassId"];
        
        cell.name1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Name"];
        cell.name2.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"Name"];
        cell.name3.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][2] objectForKey:@"Name"];
        
        cell.message1.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Size"];
        cell.message2.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"Size"];
        cell.message3.text = [[midDatas[indexPath.row] objectForKey:@"FreshCompany"][2] objectForKey:@"Size"];
        
        cell.specifications1.text = [NSString stringWithFormat:@"￥%.1f",[[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][0] objectForKey:@"Price"] floatValue]];
        cell.specifications2.text = [NSString stringWithFormat:@"￥%.1f",[[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][1] objectForKey:@"Price"] floatValue]];
        cell.specifications3.text = [NSString stringWithFormat:@"￥%.1f",[[[midDatas[indexPath.row] objectForKey:@"FreshCompany"][2] objectForKey:@"Price"] floatValue]];
    }
    
    cell.goodsButton1.tag = indexPath.row;
    cell.goodsButton2.tag = indexPath.row;
    cell.goodsButton3.tag = indexPath.row;
    [cell.goodsButton1 addTarget:self action:@selector(goodsButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goodsButton2 addTarget:self action:@selector(goodsButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goodsButton3 addTarget:self action:@selector(goodsButtonClick3:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

-(void)initTableView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.375+(SCREENWIDTH-32)/3+16 )];
    headView.backgroundColor = RGBCOLORA(239, 239, 239, 1);
    
    SDCycleScrollView *bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.375)];
    bannerView.delegate = self;

    bannerView.imageURLStringsGroup = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%@",IMGURL,[topDatas[0] objectForKey:@"ImageUrl"]],[NSString stringWithFormat:@"%@%@",IMGURL,[topDatas[1] objectForKey:@"ImageUrl"]],[NSString stringWithFormat:@"%@%@",IMGURL,[topDatas[2] objectForKey:@"ImageUrl"]], nil];
    bannerView.placeholderImage = [UIImage imageNamed:@"bg.png"];
    bannerView.autoScrollTimeInterval = 3.0;
    [headView addSubview:bannerView];
    
    UIButton *classButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [classButton1 setFrame:CGRectMake(8, SCREENWIDTH*0.375+8, (SCREENWIDTH-32)/3, (SCREENWIDTH-32)/3 )];
    [classButton1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[topDatas[3] objectForKey:@"ImageUrl"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_default"]];
    [classButton1 setBackgroundColor:[UIColor whiteColor]];
    [classButton1 addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *classButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [classButton2 setFrame:CGRectMake((SCREENWIDTH-32)/3+16, SCREENWIDTH*0.375+8, (SCREENWIDTH-32)/3, (SCREENWIDTH-32)/3 )];
    [classButton2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[topDatas[4] objectForKey:@"ImageUrl"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_default"]];
    [classButton2 addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *classButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [classButton3 setFrame:CGRectMake(((SCREENWIDTH-32)/3+8)*2+8, SCREENWIDTH*0.375+8, (SCREENWIDTH-32)/3, (SCREENWIDTH-32)/3 )];
    [classButton3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[topDatas[5] objectForKey:@"ImageUrl"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_default"]];
    [classButton3 addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];

    classButton1.tag = 1711;
    classButton2.tag = 1712;
    classButton3.tag = 1713;

    [headView addSubview:classButton1];
    [headView addSubview:classButton2];
    [headView addSubview:classButton3];

    ////-----foot------///////
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.241)];
    UIImageView *footImageView = [[UIImageView alloc]initWithFrame:footView.frame];
    [footImageView sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_img_img4.jpg"]];
    [footView addSubview:footImageView];
    
    _tableView.tableHeaderView = headView;
    _tableView.tableFooterView = footView;

}
#pragma mark - SDCycleScrollViewDelegate 点击轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    flowersCakeViewController *flowersCakeVC = [stroyBoard instantiateViewControllerWithIdentifier:@"flowersCakeViewController"];
    sangariaViewController *sangariaVC = [[sangariaViewController alloc] initWithNibName:@"sangariaViewController"   bundle:nil];
    FCLpurchaseViewController *FCLpurchaseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"FCLpurchaseViewController"];

    switch (index) {
        case 0:
            [flowersCakeVC setGetDatas:topDatas[0]];
            [self.navigationController pushViewController:flowersCakeVC animated:YES];
            break;
        case 1:
            [sangariaVC setGetDatas:topDatas[1]];
            [self.navigationController pushViewController:sangariaVC animated:YES];
            break;
        case 2:
            [FCLpurchaseVC setGetDatas:topDatas[2]];
            [self.navigationController pushViewController:FCLpurchaseVC animated:YES];
            break;
            

        default:
            break;
    }
      NSLog(@"%ld",(long)index);
}
#pragma mark 点击3个分类
-(void)classButton:(UIButton *)sender{
    KopiLuwakViewController *KopiLuwakVC = [[KopiLuwakViewController alloc] initWithNibName:@"KopiLuwakViewController"   bundle:nil];
    FiletMignonViewController *FiletMignonVC = [[FiletMignonViewController alloc] initWithNibName:@"FiletMignonViewController"   bundle:nil];
    redWineViewController *redWineVC = [[redWineViewController alloc] initWithNibName:@"redWineViewController"   bundle:nil];

    switch (sender.tag) {
        case 1711:
            [KopiLuwakVC setGetDatas:topDatas[3]];
            [self.navigationController pushViewController:KopiLuwakVC animated:YES];
            break;
        case 1712:
            [redWineVC setGetDatas:topDatas[4]];
            [self.navigationController pushViewController:redWineVC animated:YES];
            break;
        case 1713:
            [FiletMignonVC setGetDatas:topDatas[5]];
            [self.navigationController pushViewController:FiletMignonVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark cell banner点击
-(void)onClickbannerImage:(UIButton *)sender{
    selectTag = sender.tag;
    [self performSegueWithIdentifier:@"freshBookingToBookClassificationViewController" sender:self];
}
#pragma mark cell 商品点击
-(void)goodsButtonClick1:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setGetID:[midDatas[sender.tag] objectForKey:@"FreshCompany"][0]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsButtonClick2:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setGetID:[midDatas[sender.tag] objectForKey:@"FreshCompany"][1]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsButtonClick3:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setGetID:[midDatas[sender.tag] objectForKey:@"FreshCompany"][2]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"freshBookingToBookClassificationViewController"]) {
        bookClassificationViewController *bookClassificationVC = segue.destinationViewController;
        [bookClassificationVC setGetDatas:midDatas[selectTag]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
