//
//  FCLpurchaseViewController.m
//  feichacha
//
//  Created by wt on 16/7/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "FCLpurchaseViewController.h"
#import "baseViewController.h"
#import "FCLpurchaseCollectionViewCell.h"
#import "FCLpurchaseHeadCollectionReusableView.h"
#import "FCLpurchaseBannerCollectionReusableView.h"

@interface FCLpurchaseViewController ()
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
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@end

@implementation FCLpurchaseViewController

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
    
    [self.collectionView registerClass:[FCLpurchaseBannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FCLpurchaseBannerCollectionReusableView"];
    
    
    [self ActivityListDatas];
    // Do any additional setup after loading the view.
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
            
            classHeadViewY1 = SCREENWIDTH*0.57;
            if (datas1.count %2 == 0) {
                classHeadViewY2 = classHeadViewY1 +40+(SCREENWIDTH/2+102)*(datas1.count/2);
            }else{
                classHeadViewY2 = classHeadViewY1 +40+(SCREENWIDTH/2+102)*(datas1.count/2+1);
            }
            if (datas2.count %2 == 0) {
                classHeadViewY3 = classHeadViewY2 +40+(SCREENWIDTH/2+102)*(datas2.count/2);
            }else{
                classHeadViewY3 = classHeadViewY2 +40+(SCREENWIDTH/2+102)*(datas2.count/2+1);
            }
            if (datas3.count %2 == 0) {
                classHeadViewY4 = classHeadViewY3 +40+(SCREENWIDTH/2+102)*(datas3.count/2);
            }else{
                classHeadViewY4 = classHeadViewY3 +40+(SCREENWIDTH/2+102)*(datas3.count/2+1);
            }
            
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
    if (section == 0) {
        return 0;
    }else{
        NSArray *tempArray = [allDatas[section-1] objectForKey:@"ActivityProduct"];
        return tempArray.count;    }
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"FCLpurchaseCollectionViewCell";
    FCLpurchaseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.iamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    cell.name.text = [[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"Name"];
    cell.specifications.text = [[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"Size"];
    cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"Price"] floatValue]];
    cell.buyButton.backgroundColor = RGBCOLORA(214, 14, 24, 1);
    [cell.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    cell.buyButton.userInteractionEnabled = YES;
    if ([[[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"Stock"] intValue] == 0) {
        cell.buyButton.backgroundColor = [UIColor lightGrayColor];
        [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
        cell.buyButton.userInteractionEnabled = NO;
    }
    
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/2-12, SCREENWIDTH/2+90);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 7, 8, 7);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            FCLpurchaseBannerCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FCLpurchaseBannerCollectionReusableView" forIndexPath:indexPath];
            UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.57)];
            [tempImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/f_zxg_banner1.jpg"]];
            [headView addSubview:tempImage];
            
            reusableview = headView;
        }else{
            FCLpurchaseHeadCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FCLpurchaseHeadCollectionReusableView" forIndexPath:indexPath];
            headView.titleLabel.text = [allDatas[indexPath.section-1] objectForKey:@"Name"];
            
            reusableview = headView;
            
        }
    }
    
    return reusableview;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        CGSize size = {SCREENWIDTH,SCREENWIDTH*0.57+23};
        return size;
    }else{
        CGSize size = {SCREENWIDTH,40};
        return size;
    }
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    CGPoint point=scrollView.contentOffset;
    CGRect frame = [navigationView frame];
    if (point.y >= SCREENWIDTH*0.57) {
        frame.origin.y = 64;
    }else{
        frame.origin.y = SCREENWIDTH*0.57+64 - point.y;
    }
    navigationView.frame = frame;
    
    [navButton1 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    [navButton2 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    [navButton3 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    [navButton4 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    [navButton1 setImage:nil forState:UIControlStateNormal];
    [navButton2 setImage:nil forState:UIControlStateNormal];
    [navButton3 setImage:nil forState:UIControlStateNormal];
    [navButton4 setImage:nil forState:UIControlStateNormal];

    if (point.y >= classHeadViewY1 && point.y < classHeadViewY2) {
        [navButton1 setTitleColor:RGBCOLORA(217, 231, 53, 1) forState:UIControlStateNormal];
        [navButton1 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY2 && point.y < classHeadViewY3){
        [navButton2 setTitleColor:RGBCOLORA(217, 231, 53, 1) forState:UIControlStateNormal];
        [navButton2 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY3 && point.y < classHeadViewY4){
        [navButton3 setTitleColor:RGBCOLORA(217, 231, 53, 1) forState:UIControlStateNormal];
        [navButton3 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY4 ){
        [navButton4 setTitleColor:RGBCOLORA(217, 231, 53, 1) forState:UIControlStateNormal];
        [navButton4 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }
    
}
-(void)initNavigationView{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.57+64, SCREENWIDTH, 39)];
    navigationView.backgroundColor = RGBCOLORA(126, 21, 7, 1);
    
    
    navButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton1 setBackgroundColor:RGBCOLORA(126, 21, 7, 1)];
    [navButton1 setFrame:CGRectMake(0, 0, SCREENWIDTH/4, 39)];
    [navButton1 setTitle:@"小编力荐" forState:UIControlStateNormal];
    
    navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton2 setBackgroundColor:RGBCOLORA(126, 21, 7, 1)];
    [navButton2 setFrame:CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 39)];
    [navButton2 setTitle:@"牛奶" forState:UIControlStateNormal];
    
    navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton3 setBackgroundColor:RGBCOLORA(126, 21, 7, 1)];
    [navButton3 setFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/4, 39)];
    [navButton3 setTitle:@"饮料" forState:UIControlStateNormal];
    
    navButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton4 setBackgroundColor:RGBCOLORA(126, 21, 7, 1)];
    [navButton4 setFrame:CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 39)];
    [navButton4 setTitle:@"其他" forState:UIControlStateNormal];
    
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
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY1+1) animated:YES];
            break;
        case 2:
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY2+1) animated:YES];
            break;
        case 3:
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY3+1) animated:YES];
            break;
        case 4:
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY4+1) animated:YES];
            break;
        default:
            break;
    }
}
#pragma mark cell里的加入购物车
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    
    UIView *v = [sender superview];//获取父类view
    UICollectionViewCell *tempcell = (UICollectionViewCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:tempcell];//获取cell对应的indexpath;
    FCLpurchaseCollectionViewCell *cell = (FCLpurchaseCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexpath];
    [baseVC addProductsAnimation:cell.iamge selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsAdd" object:[allDatas[indexpath.section-1] objectForKey:@"ActivityProduct"][indexpath.row]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];

}
-(void)goodsClick:(UIButton *)sender{
    UIView *v = [sender superview];//获取父类view
    UICollectionViewCell *tempcell = (UICollectionViewCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:tempcell];//获取cell对应的indexpath;
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:[allDatas[indexpath.section-1] objectForKey:@"ActivityProduct"][indexpath.row]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}

- (IBAction)goShoppingCart:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToShoppingCart" object:nil];
}
- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
