//
//  wineViewController.m
//  feichacha
//
//  Created by wt on 16/5/16.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "wineViewController.h"
#import "baseViewController.h"
#import "wineBannerCollectionReusableView.h"
#import "wineHeadCollectionReusableView.h"
#import "wineCollectionViewCell.h"

@interface wineViewController ()
{
    wineHeadCollectionReusableView * wineHeadView;
    
    UIView *navigationView;
    
    float classHeadViewY1;
    float classHeadViewY2;
    float classHeadViewY3;
    float classHeadViewY4;
    
    
    UIButton *navButton1;
    UIButton *navButton2;
    UIButton *navButton3;
    UIButton *navButton4;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@end

@implementation wineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    
    
    [self initNavigationView];
    
    [self.collectionView registerClass:[wineBannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"wineBannerCollectionReusableView"];
    
    classHeadViewY1 = SCREENWIDTH*0.346;
    if (12 % 2 == 0) {
        classHeadViewY2 = classHeadViewY1 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY3 = classHeadViewY2 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY4 = classHeadViewY3 +78+(SCREENWIDTH/2+102)*(4/2);
        
    }else{
        classHeadViewY2 = classHeadViewY1 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        classHeadViewY3 = classHeadViewY2 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        classHeadViewY4 = classHeadViewY3 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        
    }

}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 4;
    }
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"wineCollectionViewCell";
    wineCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 4;
    cell.buyButton.layer.cornerRadius = 4;
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/jou_img2.jpg"]];
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
            wineBannerCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"wineBannerCollectionReusableView" forIndexPath:indexPath];
            UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.346)];
            [tempImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/jou_banner.jpg"]];
            [headView addSubview:tempImage];
            reusableview = headView;
        }else{
            wineHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"wineHeadCollectionReusableView" forIndexPath:indexPath];
            [wineHeadView.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/jou_img1.jpg"]];
            wineHeadView.buyButton.tag = indexPath.section;
            [wineHeadView.buyButton addTarget:self action:@selector(SectionBuyButton:) forControlEvents:UIControlEventTouchUpInside];
            
            reusableview = wineHeadView;
        }
    }
    
    return reusableview;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        CGSize size = {SCREENWIDTH,SCREENWIDTH*0.346+20};
        return size;
    }else{
        CGSize size = {SCREENWIDTH,148};
        return size;
    }
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat sectionHeaderHeight = 148;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    CGPoint point=scrollView.contentOffset;
    CGRect frame = [navigationView frame];
    if (point.y >= SCREENWIDTH*0.346) {
        frame.origin.y = 64;
    }else{
        frame.origin.y = SCREENWIDTH*0.346+64 - point.y;
    }
    navigationView.frame = frame;
    

    [navButton1 setImage:nil forState:UIControlStateNormal];
    [navButton2 setImage:nil forState:UIControlStateNormal];
    [navButton3 setImage:nil forState:UIControlStateNormal];
    [navButton4 setImage:nil forState:UIControlStateNormal];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (point.y >= classHeadViewY1 && point.y < classHeadViewY2) {
        [navButton1 setTitleColor:RGBCOLORA(245, 239, 60, 1) forState:UIControlStateNormal];
        [navButton1 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY2 && point.y < classHeadViewY3){
        [navButton2 setTitleColor:RGBCOLORA(245, 239, 60, 1) forState:UIControlStateNormal];
        [navButton2 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY3 && point.y < classHeadViewY4){
        [navButton3 setTitleColor:RGBCOLORA(245, 239, 60, 1) forState:UIControlStateNormal];
        [navButton3 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY4 ){
        [navButton4 setTitleColor:RGBCOLORA(245, 239, 60, 1) forState:UIControlStateNormal];
        [navButton4 setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    }
    
}
-(void)initNavigationView{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.346+64, SCREENWIDTH, 39)];
    navigationView.backgroundColor = RGBCOLORA(238, 118, 156, 1);
    
    
    navButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton1 setBackgroundColor:RGBCOLORA(238, 118, 156, 1)];
    [navButton1 setFrame:CGRectMake(0, 0, SCREENWIDTH/4, 39)];
    [navButton1 setTitle:@"小编热荐" forState:UIControlStateNormal];
    
    navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton2 setBackgroundColor:RGBCOLORA(238, 118, 156, 1)];
    [navButton2 setFrame:CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 39)];
    [navButton2 setTitle:@"热门香烟" forState:UIControlStateNormal];
    
    navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton3 setBackgroundColor:RGBCOLORA(238, 118, 156, 1)];
    [navButton3 setFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/4, 39)];
    [navButton3 setTitle:@"整条批发" forState:UIControlStateNormal];
    
    navButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton4 setBackgroundColor:RGBCOLORA(238, 118, 156, 1)];
    [navButton4 setFrame:CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 39)];
    [navButton4 setTitle:@"香烟周边" forState:UIControlStateNormal];
    
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
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4, 0, 1, 39)];
    line2.backgroundColor = [UIColor whiteColor];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, 1, 39)];
    line3.backgroundColor = [UIColor whiteColor];
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*3, 0, 1, 39)];
    line4.backgroundColor = [UIColor whiteColor];
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
    wineCollectionViewCell *cell = (wineCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexpath];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    
    
}
#pragma mark scetion里的加入购物车
-(void)SectionBuyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    [baseVC addProductsAnimation:wineHeadView.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];

    NSLog(@"%d",sender.tag);
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