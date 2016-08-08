//
//  ChenHempViewController.m
//  feichacha
//
//  Created by wt on 16/5/10.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "ChenHempViewController.h"
#import "ChenHempCollectionViewCell.h"
#import "ChenHempHeadCollectionReusableView.h"
#import "baseViewController.h"

@interface ChenHempViewController ()
{
    ChenHempHeadCollectionReusableView * headView ;
    NSArray *datas;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation ChenHempViewController

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
    [self ActivityListDatas];

}
-(void)ActivityListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] ActivityList:[_getDatas objectForKey:@"Id"] ActType:[_getDatas objectForKey:@"ActType"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[NSMutableArray alloc]init];
            datas = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ActivityProduct"];
            
            [_collectionView reloadData];
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return datas.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ChenHempCollectionViewCell";
    ChenHempCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/chen_img2.jpg"]];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    cell.name.text = [datas[indexPath.row] objectForKey:@"Name"];
    cell.specifications.text = [datas[indexPath.row] objectForKey:@"Size"];
    cell.price.text = [NSString stringWithFormat:@"%@",[datas[indexPath.row] objectForKey:@"Price"]];
    
    [cell.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    cell.buyButton.userInteractionEnabled = YES;
    if ([[datas[indexPath.row] objectForKey:@"Stock"] intValue] == 0) {
        if ([datas[indexPath.row] objectForKey:@"Stock"]) {
            cell.buyButton.backgroundColor = [UIColor lightGrayColor];
            [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            cell.buyButton.userInteractionEnabled = NO;
        }
    }
    
    
    cell.oldPrice.hidden = YES;
//    /**
//     老价格加下划线
//     **/
//    NSString *oldPrice = @"原价：339.2";
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, oldPrice.length)];
//    [cell.oldPrice setAttributedText:attri];
    
    
    [cell.buyButton addTarget:self action:@selector(cellBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.goodsClick.tag = indexPath.row;
    [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    return  cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/2-12, SCREENWIDTH/2+100);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 7, 8, 7);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ChenHempHeadCollectionReusableView" forIndexPath:indexPath];
    [headView.iamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    headView.name.text = [datas[0] objectForKey:@"Name"];
    headView.size.text = [datas[0] objectForKey:@"Size"];
    headView.price.text = [NSString stringWithFormat:@"热卖价：%@",[datas[0] objectForKey:@"Price"]];
    if ([[datas[0] objectForKey:@"Stock"] intValue] == 0) {
        if ([datas[0] objectForKey:@"Stock"]) {
            headView.buyButton.backgroundColor = [UIColor lightGrayColor];
            [headView.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
            headView.buyButton.userInteractionEnabled = NO;
        }
    }
    [headView.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/chen_banner.jpg"]];
    [headView.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    [headView.goodsClick addTarget:self action:@selector(titleGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return  headView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {SCREENWIDTH,106+SCREENWIDTH*0.54};
    return size;
}

#pragma mark title buyButton
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    [baseVC addProductsAnimation:headView.iamge selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[0]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark cell buybutton
-(void)cellBuyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    UIView *v = [sender superview];//获取父类view
    UICollectionViewCell *tempcell = (UICollectionViewCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:tempcell];//获取cell对应的indexpath;
    ChenHempCollectionViewCell *cell = (ChenHempCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexpath];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[indexpath.row]];
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
-(void)titleGoodsClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:datas[0]];
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
