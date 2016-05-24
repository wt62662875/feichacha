//
//  bookClassificationViewController.m
//  feichacha
//
//  Created by wt on 16/5/22.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "bookClassificationViewController.h"
#import "bookClassificationCollectionViewCell.h"
#import "bookClassificationHeadCollectionReusableView.h"
#import "baseViewController.h"

@interface bookClassificationViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation bookClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"bookClassificationCollectionViewCell";
    bookClassificationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.buyButton.layer.cornerRadius = 4;
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/sg_img1.jpg"]];
    [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
        bookClassificationHeadCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bookClassificationHeadCollectionReusableView" forIndexPath:indexPath];
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-40, 20, 80, 80)];
        [image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/sg_banner.jpg"]];
        image.layer.cornerRadius = 40;
        image.layer.masksToBounds = YES;
        [headView addSubview:image];
        
        UILabel *messageLabel = [[UILabel alloc]init];
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.text = @"提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。";
        messageLabel.numberOfLines = 0;//根据最大行数需求来设置
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(SCREENWIDTH-16, 9999);//labelsize的最大值
        //关键语句
        CGSize expectSize = [messageLabel sizeThatFits:maximumLabelSize];
        messageLabel.frame = CGRectMake(8, 120, expectSize.width, expectSize.height);
        [headView addSubview:messageLabel];
        
        reusableview = headView;
    }
    
    return reusableview;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize titleSize =[@"提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。提升幸福感，精致生活每一天。"  boundingRectWithSize:CGSizeMake(SCREENWIDTH-16, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGSize size = {SCREENWIDTH,128+titleSize.height};
    return size;
}
#pragma mark cell里的加入购物车
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    
    UIView *v = [sender superview];//获取父类view
    UICollectionViewCell *tempcell = (UICollectionViewCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:tempcell];//获取cell对应的indexpath;
    bookClassificationCollectionViewCell *cell = (bookClassificationCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexpath];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    
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
