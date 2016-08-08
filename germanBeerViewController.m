//
//  germanBeerViewController.m
//  feichacha
//
//  Created by wt on 16/5/10.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "germanBeerViewController.h"
#import "germanBeerCollectionViewCell.h"
#import "germanBeerHeadCollectionReusableView.h"
#import "germanBeerFootCollectionReusableView.h"
#import "goodsDetailsViewController.h"

@interface germanBeerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *datas;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation germanBeerViewController

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
    static NSString * CellIdentifier = @"germanBeerCollectionViewCell";
    germanBeerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.name.text = [datas[indexPath.row] objectForKey:@"Name"];
    cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[datas[indexPath.row] objectForKey:@"Price"] floatValue]];
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]]];
    cell.buyButton.backgroundColor = RGBCOLORA(255, 199, 0, 1);
    [cell.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    cell.buyButton.userInteractionEnabled = YES;
    if ([[datas[indexPath.row] objectForKey:@"Stock"] intValue] == 0) {
        cell.buyButton.backgroundColor = [UIColor lightGrayColor];
        [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
        cell.buyButton.userInteractionEnabled = NO;
    }
    
    cell.buyButton.tag = indexPath.row;
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.goodsClick.tag = indexPath.row;
    [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    return  cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/2-12, (SCREENWIDTH/2-14)*1.472);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 7, 8, 7);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    

    if (kind == UICollectionElementKindSectionHeader){
        germanBeerHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"germanBeerHeadCollectionReusableView" forIndexPath:indexPath];
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.514)];
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, image1.frame.size.height , SCREENWIDTH, SCREENWIDTH*0.342)];
        [image1 setImage:[UIImage imageNamed:@"beer_banner.jpg"]];
        [image2 setImage:[UIImage imageNamed:@"beer_forma.jpg"]];
        
        [headView addSubview:image1];
        [headView addSubview:image2];
        reusableview = headView;
    }else{
        germanBeerFootCollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"germanBeerFootCollectionReusableView" forIndexPath:indexPath];
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*1.353)];
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, image1.frame.size.height , SCREENWIDTH, SCREENWIDTH*1.353)];
        UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, image2.frame.size.height+image2.frame.origin.y , SCREENWIDTH, SCREENWIDTH*1.281)];
        [image1 setImage:[UIImage imageNamed:@"beer_bottom_img1.jpg"]];
        [image2 setImage:[UIImage imageNamed:@"beer_bottom_img2.jpg"]];
        [image3 setImage:[UIImage imageNamed:@"beer_bottom_img3.jpg"]];

        [footView addSubview:image1];
        [footView addSubview:image2];
        [footView addSubview:image3];
        reusableview = footView;
    }
    
    return reusableview;
    

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {SCREENWIDTH,SCREENWIDTH*0.514+SCREENWIDTH*0.342};
    return size;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = {SCREENWIDTH,SCREENWIDTH*1.353+SCREENWIDTH*1.353+SCREENWIDTH*1.281};
    return size;
}

-(void)buyButton:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[sender.tag]];
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
