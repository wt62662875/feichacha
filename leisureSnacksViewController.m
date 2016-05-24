//
//  leisureSnacksViewController.m
//  feichacha
//
//  Created by wt on 16/5/14.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "leisureSnacksViewController.h"
#import "leisureSnacksBannerCollectionReusableView.h"
#import "leisureSnacksCollectionViewCell.h"
#import "leisureSnacksHeadCollectionReusableView.h"
#import "baseViewController.h"

@interface leisureSnacksViewController ()
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
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation leisureSnacksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    
    [self initNavigationView];
    
    [self.collectionView registerClass:[leisureSnacksBannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"leisureSnacksBannerCollectionReusableView"];
    
    classHeadViewY1 = SCREENWIDTH*0.307;
    if (12 % 2 == 0) {
        classHeadViewY2 = classHeadViewY1 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY3 = classHeadViewY2 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY4 = classHeadViewY3 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY5 = classHeadViewY4 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY6 = classHeadViewY5 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY7 = classHeadViewY6 +78+(SCREENWIDTH/2+102)*(4/2);
        classHeadViewY8 = classHeadViewY7 +78+(SCREENWIDTH/2+102)*(4/2);
        
    }else{
        classHeadViewY2 = classHeadViewY1 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        classHeadViewY3 = classHeadViewY2 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        classHeadViewY4 = classHeadViewY3 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        
    }

    // Do any additional setup after loading the view.
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
    static NSString * CellIdentifier = @"leisureSnacksCollectionViewCell";
    leisureSnacksCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = RGBCOLORA(250, 217, 55, 1).CGColor;
    cell.buyButton.layer.cornerRadius = 4;
    
    [cell.iamge sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xx_img1.jpg"]];
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
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
            leisureSnacksBannerCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"leisureSnacksBannerCollectionReusableView" forIndexPath:indexPath];
            UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.307)];
            [tempImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xx_banner.jpg"]];
            [headView addSubview:tempImage];
            
            reusableview = headView;
        }else{
            leisureSnacksHeadCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"leisureSnacksHeadCollectionReusableView" forIndexPath:indexPath];
            
            reusableview = headView;
            
        }
    }
    
    return reusableview;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        CGSize size = {SCREENWIDTH,SCREENWIDTH*0.307+70};
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
    if (point.y >= SCREENWIDTH*0.307) {
        frame.origin.y = 64;
    }else{
        frame.origin.y = SCREENWIDTH*0.307+64 - point.y;
    }
    navigationView.frame = frame;
    
    [navButton1 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton2 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton3 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton4 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton5 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton6 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton7 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton8 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton8 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    if (point.y >= classHeadViewY1 && point.y < classHeadViewY2) {
        [navButton1 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton1 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY2 && point.y < classHeadViewY3){
        [navButton2 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton2 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY3 && point.y < classHeadViewY4){
        [navButton3 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton3 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY4 && point.y < classHeadViewY5){
        [navButton4 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton4 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY5 && point.y < classHeadViewY6){
        [navButton5 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton5 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY6 && point.y < classHeadViewY7){
        [navButton6 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton6 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY7 && point.y < classHeadViewY8){
        [navButton7 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton7 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }else if (point.y >= classHeadViewY8 ){
        [navButton8 setBackgroundColor:RGBCOLORA(255, 255, 255, 1)];
        [navButton8 setTitleColor:RGBCOLORA(89, 182, 41, 1) forState:UIControlStateNormal];
    }
    
}

-(void)initNavigationView{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.307+64, SCREENWIDTH, 78)];
    navigationView.backgroundColor = RGBCOLORA(89, 182, 41, 1);
    navigationView.layer.borderColor = RGBCOLORA(89, 182, 41, 1).CGColor;
    navigationView.layer.borderWidth = 1;
    
    
    navButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton1 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton1 setFrame:CGRectMake(0, 0, SCREENWIDTH/4, 39)];
    [navButton1 setTitle:@"小编热荐" forState:UIControlStateNormal];
    
    navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton2 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton2 setFrame:CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 39)];
    [navButton2 setTitle:@"膨化食品" forState:UIControlStateNormal];
    
    navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton3 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton3 setFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/4, 39)];
    [navButton3 setTitle:@"坚果炒货" forState:UIControlStateNormal];
    
    navButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton4 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton4 setFrame:CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 39)];
    [navButton4 setTitle:@"蜜饯果干" forState:UIControlStateNormal];
    
    navButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton5.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton5 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton5 setFrame:CGRectMake(0, 39, SCREENWIDTH/4, 39)];
    [navButton5 setTitle:@"肉类制品" forState:UIControlStateNormal];
    
    navButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton6.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton6 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton6 setFrame:CGRectMake(SCREENWIDTH/4, 39, SCREENWIDTH/4, 39)];
    [navButton6 setTitle:@"豆菌笋类" forState:UIControlStateNormal];
    
    navButton7 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton7.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton7 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton7 setFrame:CGRectMake(SCREENWIDTH/2, 39, SCREENWIDTH/4, 39)];
    [navButton7 setTitle:@"糖果巧克力" forState:UIControlStateNormal];
    
    navButton8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton8 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton8.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton8 setBackgroundColor:RGBCOLORA(250, 217, 55, 1)];
    [navButton8 setFrame:CGRectMake(SCREENWIDTH/4*3, 39, SCREENWIDTH/4, 39)];
    [navButton8 setTitle:@"我要喝酒" forState:UIControlStateNormal];
    
    
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
    line1.backgroundColor = RGBCOLORA(89, 182, 41, 1);
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4, 0, 1, 78)];
    line2.backgroundColor = RGBCOLORA(89, 182, 41, 1);
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, 1, 78)];
    line3.backgroundColor = RGBCOLORA(89, 182, 41, 1);
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*3, 0, 1, 78)];
    line4.backgroundColor = RGBCOLORA(89, 182, 41, 1);
    [navigationView addSubview:line1];
    [navigationView addSubview:line2];
    [navigationView addSubview:line3];
    [navigationView addSubview:line4];
    
    [self.view addSubview:navigationView];
    
    navButton8.hidden = YES;
    
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
    leisureSnacksCollectionViewCell *cell = (leisureSnacksCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexpath];
    [baseVC addProductsAnimation:cell.iamge selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    
    
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
