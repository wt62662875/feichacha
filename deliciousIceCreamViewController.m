//
//  deliciousIceCreamViewController.m
//  feichacha
//
//  Created by wt on 16/5/16.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "deliciousIceCreamViewController.h"
#import "baseViewController.h"
#import "deliciousIceCreamCollectionViewCell.h"
#import "deliciousIceCreamBannerCollectionReusableView.h"
#import "deliciousIceCreamHeadCollectionReusableView.h"

@interface deliciousIceCreamViewController ()
{
    UIView *navigationView;
    
    float classHeadViewY1;
    float classHeadViewY2;
    float classHeadViewY3;
    float classHeadViewY4;
    float classHeadViewY5;
    float classHeadViewY6;
    float classHeadViewY7;
    float classHeadViewY8;
    
    UIButton *navButton1;
    UIButton *navButton2;
    UIButton *navButton3;
    UIButton *navButton4;
    UIButton *navButton5;
    UIButton *navButton6;
    UIButton *navButton7;
    UIButton *navButton8;
    
    NSArray *allDatas;
    NSArray * datas1;
    NSArray * datas2;
    NSArray * datas3;
    NSArray * datas4;
    NSArray * datas5;
    NSArray * datas6;
    NSArray * datas7;
    NSArray * datas8;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation deliciousIceCreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    [self initNavigationView];
    
    [self.collectionView registerClass:[deliciousIceCreamBannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deliciousIceCreamBannerCollectionReusableView"];
    
    [self ActivityListDatas];

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
            datas5 = [allDatas[4] objectForKey:@"ActivityProduct"];
            datas6 = [allDatas[5] objectForKey:@"ActivityProduct"];
            datas7 = [allDatas[6] objectForKey:@"ActivityProduct"];
            datas8 = [allDatas[7] objectForKey:@"ActivityProduct"];
            classHeadViewY1 = SCREENWIDTH*0.333;
            if (datas1.count %2 == 0) {
                classHeadViewY2 = classHeadViewY1 +78+(SCREENWIDTH/2+102)*(datas1.count/2);
            }else{
                classHeadViewY2 = classHeadViewY1 +78+(SCREENWIDTH/2+102)*(datas1.count/2+1);
            }
            if (datas2.count %2 == 0) {
                classHeadViewY3 = classHeadViewY2 +78+(SCREENWIDTH/2+102)*(datas2.count/2);
            }else{
                classHeadViewY3 = classHeadViewY2 +78+(SCREENWIDTH/2+102)*(datas2.count/2+1);
            }
            if (datas3.count %2 == 0) {
                classHeadViewY4 = classHeadViewY3 +78+(SCREENWIDTH/2+102)*(datas3.count/2);
            }else{
                classHeadViewY4 = classHeadViewY3 +78+(SCREENWIDTH/2+102)*(datas3.count/2+1);
            }
            if (datas4.count %2 == 0) {
                classHeadViewY5 = classHeadViewY4 +78+(SCREENWIDTH/2+102)*(datas4.count/2);
            }else{
                classHeadViewY5 = classHeadViewY4 +78+(SCREENWIDTH/2+102)*(datas4.count/2+1);
            }
            if (datas5.count %2 == 0) {
                classHeadViewY6 = classHeadViewY5 +78+(SCREENWIDTH/2+102)*(datas5.count/2);
            }else{
                classHeadViewY6 = classHeadViewY5 +78+(SCREENWIDTH/2+102)*(datas5.count/2+1);
            }
            if (datas6.count %2 == 0) {
                classHeadViewY7 = classHeadViewY6 +78+(SCREENWIDTH/2+102)*(datas6.count/2);
            }else{
                classHeadViewY7 = classHeadViewY6 +78+(SCREENWIDTH/2+102)*(datas6.count/2+1);
            }
            if (datas7.count %2 == 0) {
                classHeadViewY8 = classHeadViewY7 +78+(SCREENWIDTH/2+102)*(datas7.count/2);
            }else{
                classHeadViewY8 = classHeadViewY7 +78+(SCREENWIDTH/2+102)*(datas7.count/2+1);
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
        return tempArray.count;
    }
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"deliciousIceCreamCollectionViewCell";
    deliciousIceCreamCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = RGBCOLORA(224, 224, 224, 1).CGColor;
    cell.buyButton.layer.cornerRadius = 4;
    
    [cell.iamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    cell.name.text = [[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"Name"];
    cell.specifications.text = [[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"Size"];
    cell.price.text = [NSString stringWithFormat:@"￥%@",[[allDatas[indexPath.section-1] objectForKey:@"ActivityProduct"][indexPath.row]objectForKey:@"Price"]];
    cell.oldPrice.hidden = YES;

    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 9;
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
            deliciousIceCreamBannerCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deliciousIceCreamBannerCollectionReusableView" forIndexPath:indexPath];
            UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.333)];
            [tempImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/mwbql_banner.jpg"]];
            [headView addSubview:tempImage];
            
            reusableview = headView;
        }else{
            deliciousIceCreamHeadCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deliciousIceCreamHeadCollectionReusableView" forIndexPath:indexPath];
            headView.titleLabel.text = [allDatas[indexPath.section-1] objectForKey:@"Name"];

            reusableview = headView;
            
        }
    }
    
    return reusableview;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        CGSize size = {SCREENWIDTH,SCREENWIDTH*0.333+70};
        return size;
    }else{
        CGSize size = {SCREENWIDTH,76};
        return size;
    }
}

// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat sectionHeaderHeight = 76;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    CGPoint point=scrollView.contentOffset;
    CGRect frame = [navigationView frame];
    if (point.y >= SCREENWIDTH*0.333) {
        frame.origin.y = 64;
    }else{
        frame.origin.y = SCREENWIDTH*0.333+64 - point.y;
    }
    navigationView.frame = frame;
    
    [navButton1 setBackgroundColor:[UIColor whiteColor]];
    [navButton2 setBackgroundColor:[UIColor whiteColor]];
    [navButton3 setBackgroundColor:[UIColor whiteColor]];
    [navButton4 setBackgroundColor:[UIColor whiteColor]];
    [navButton5 setBackgroundColor:[UIColor whiteColor]];
    [navButton6 setBackgroundColor:[UIColor whiteColor]];
    [navButton7 setBackgroundColor:[UIColor whiteColor]];
    [navButton8 setBackgroundColor:[UIColor whiteColor]];
    [navButton1 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton2 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton3 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton4 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton5 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton6 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton7 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton8 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    
    
    if (point.y >= classHeadViewY1 && point.y < classHeadViewY2) {
        [navButton1 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton1 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY2 && point.y < classHeadViewY3){
        [navButton2 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton2 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY3 && point.y < classHeadViewY4){
        [navButton3 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton3 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY4 && point.y < classHeadViewY5){
        [navButton4 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton4 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY5 && point.y < classHeadViewY6){
        [navButton5 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton5 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY6 && point.y < classHeadViewY7){
        [navButton6 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton6 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY7 && point.y < classHeadViewY8){
        [navButton7 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton7 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY8 ){
        [navButton8 setBackgroundColor:RGBCOLORA(235, 99, 146, 1)];
        [navButton8 setTitleColor:RGBCOLORA(255, 255, 255, 1) forState:UIControlStateNormal];
    }
    
}

-(void)initNavigationView{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.333+64, SCREENWIDTH, 78)];
    navigationView.backgroundColor = [UIColor whiteColor];
    navigationView.layer.borderColor = RGBCOLORA(235, 99, 146, 1).CGColor;
    navigationView.layer.borderWidth = 1;
    
    
    navButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton1 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton1 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton1 setFrame:CGRectMake(0, 0, SCREENWIDTH/4, 39)];
    [navButton1 setTitle:@"小编力荐" forState:UIControlStateNormal];
    
    navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton2 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton2 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton2 setFrame:CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 39)];
    [navButton2 setTitle:@"哈根达斯" forState:UIControlStateNormal];
    
    navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton3 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton3 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton3 setFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/4, 39)];
    [navButton3 setTitle:@"八喜" forState:UIControlStateNormal];
    
    navButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton4 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton4.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton4 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton4 setFrame:CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 39)];
    [navButton4 setTitle:@"雀巢" forState:UIControlStateNormal];
    
    navButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton5 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton5.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton5 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton5 setFrame:CGRectMake(0, 39, SCREENWIDTH/4, 39)];
    [navButton5 setTitle:@"和路雪" forState:UIControlStateNormal];
    
    navButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton6 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton6.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton6 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton6 setFrame:CGRectMake(SCREENWIDTH/4, 39, SCREENWIDTH/4, 39)];
    [navButton6 setTitle:@"乐天" forState:UIControlStateNormal];
    
    navButton7 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton7 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton7.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton7 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton7 setFrame:CGRectMake(SCREENWIDTH/2, 39, SCREENWIDTH/4, 39)];
    [navButton7 setTitle:@"伊利" forState:UIControlStateNormal];
    
    navButton8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton8 setTitleColor:RGBCOLORA(235, 99, 146, 1) forState:UIControlStateNormal];
    [navButton8.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton8 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
    [navButton8 setFrame:CGRectMake(SCREENWIDTH/4*3, 39, SCREENWIDTH/4, 39)];
    [navButton8 setTitle:@"蒙牛" forState:UIControlStateNormal];
    
    
    navButton1.tag = 1;
    navButton2.tag = 2;
    navButton3.tag = 3;
    navButton4.tag = 4;
    navButton5.tag = 5;
    navButton6.tag = 6;
    navButton7.tag = 7;
    navButton8.tag = 8;
    
    [navButton1 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton2 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton3 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton4 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton5 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton6 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton7 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton8 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:navButton1];
    [navigationView addSubview:navButton2];
    [navigationView addSubview:navButton3];
    [navigationView addSubview:navButton4];
    [navigationView addSubview:navButton5];
    [navigationView addSubview:navButton6];
    [navigationView addSubview:navButton7];
    [navigationView addSubview:navButton8];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    line1.backgroundColor = RGBCOLORA(235, 99, 146, 1);
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4, 0, 1, 78)];
    line2.backgroundColor = RGBCOLORA(235, 99, 146, 1);
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, 1, 78)];
    line3.backgroundColor = RGBCOLORA(235, 99, 146, 1);
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*3, 0, 1, 78)];
    line4.backgroundColor = RGBCOLORA(235, 99, 146, 1);
    [navigationView addSubview:line1];
    [navigationView addSubview:line2];
    [navigationView addSubview:line3];
    [navigationView addSubview:line4];
    
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
        case 5:
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY5+1) animated:YES];
            break;
        case 6:
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY6+1) animated:YES];
            break;
        case 7:
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY7+1) animated:YES];
            break;
        case 8:
            [_collectionView setContentOffset:CGPointMake(0, classHeadViewY8+1) animated:YES];
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
    deliciousIceCreamCollectionViewCell *cell = (deliciousIceCreamCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexpath];
    [baseVC addProductsAnimation:cell.iamge selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:[allDatas[indexpath.section-1] objectForKey:@"ActivityProduct"][indexpath.row]];
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
