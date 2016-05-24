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
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation salesPromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
    [self initTableHeadView];
//    guideView *guiView = [[NSBundle mainBundle] loadNibNamed:@"guideView" owner:self options:nil][0];
    CGSize size =  [AppUtils getImageSizeWithURL:[NSURL URLWithString:@"http://img05.tooopen.com/images/20140604/sy_62331342149.jpg"]];
    NSLog(@"%f==%f",size.height,size.width);

}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 3;
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
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/img1.png"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/img1.png"]];
        [cell.buyButton1 setBackgroundColor:RGBCOLORA(246, 170, 0, 1)];
        [cell.buyButton2 setBackgroundColor:RGBCOLORA(246, 170, 0, 1)];
        
        
        [cell.buyButton1 addTarget:self action:@selector(buyButton1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buyButton2 addTarget:self action:@selector(buyButton2:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    static NSString *cellIdentifier = @"salesPromotionGoodsTableViewCell";
    salesPromotionGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"salesPromotionGoodsTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/f_cx_img1.png"]];
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
}
#pragma mark 有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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