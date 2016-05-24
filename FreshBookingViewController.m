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


@interface FreshBookingViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FreshBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initTableView];
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
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
    [cell.bannerImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_banner_img1.jpg"]];
    cell.bannerButton.tag = indexPath.row;
    [cell.bannerButton addTarget:self action:@selector(onClickbannerImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_img_img1.png"]];
    [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_img_img2.png"]];
    [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_img_img3.png"]];
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
    bannerView.imageURLStringsGroup = [[NSArray alloc]initWithObjects:@"http://manage.feichacha.com/html/shop/images/xxyd_xh.jpg",@"http://manage.feichacha.com/html/shop/images/xxyd_banner_top.jpg",@"http://manage.feichacha.com/html/shop/images/index_banner_top3.jpg", nil];
    bannerView.placeholderImage = [UIImage imageNamed:@"bg.png"];
    bannerView.autoScrollTimeInterval = 3.0;
    [headView addSubview:bannerView];
    
    UIButton *classButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [classButton1 setFrame:CGRectMake(8, SCREENWIDTH*0.375+8, (SCREENWIDTH-32)/3, (SCREENWIDTH-32)/3 )];
    [classButton1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_gg1_1.jpg"] forState:UIControlStateNormal];
    [classButton1 setBackgroundColor:[UIColor whiteColor]];
    [classButton1 addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *classButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [classButton2 setFrame:CGRectMake((SCREENWIDTH-32)/3+16, SCREENWIDTH*0.375+8, (SCREENWIDTH-32)/3, (SCREENWIDTH-32)/3 )];
    [classButton2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_gg2_1.jpg"] forState:UIControlStateNormal];
    [classButton2 addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *classButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [classButton3 setFrame:CGRectMake(((SCREENWIDTH-32)/3+8)*2+8, SCREENWIDTH*0.375+8, (SCREENWIDTH-32)/3, (SCREENWIDTH-32)/3 )];
    [classButton3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xxyd_gg3_1.jpg"] forState:UIControlStateNormal];
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
      NSLog(@"%ld",(long)index);
}
#pragma mark 点击3个分类
-(void)classButton:(UIButton *)sender{
    switch (sender.tag) {
        case 1711:
            NSLog(@"1");
            break;
        case 1712:
            NSLog(@"2");
            break;
        case 1713:
            NSLog(@"3");
            break;
        default:
            break;
    }
}

#pragma mark cell banner点击
-(void)onClickbannerImage:(UIButton *)sender{
    [self performSegueWithIdentifier:@"freshBookingToBookClassificationViewController" sender:self];
    
    NSLog(@"%d",sender.tag);
}
#pragma mark cell 商品点击
-(void)goodsButtonClick1:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
}
-(void)goodsButtonClick2:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
}
-(void)goodsButtonClick3:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
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
