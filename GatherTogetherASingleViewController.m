//
//  GatherTogetherASingleViewController.m
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "GatherTogetherASingleViewController.h"
#import "GatherTogetherCollectionViewCell.h"
#import "baseViewController.h"


@interface GatherTogetherASingleViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIView *redLine;
    
    NSArray *datas;
    
}
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation GatherTogetherASingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSlidingLine];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    // Do any additional setup after loading the view.
    [self MinatoList:@"5" min:@"0"];
}
-(void)MinatoList:(NSString *)max min:(NSString *)min{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] MinatoList:[USERDEFAULTS objectForKey:@"shopID"] Library:_isAct Maxmoney:max Minmoney:min success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [responseObject objectForKey:@"AppendData"];
            
            [_collectionView reloadData];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToBaseView" object:nil];
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
    static NSString * CellIdentifier = @"GatherTogetherCollectionViewCell";
    GatherTogetherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    cell.goodsName.text = [datas[indexPath.row] objectForKey:@"Name"];
    cell.goodsMessage1.text = [datas[indexPath.row] objectForKey:@"Size"];
    cell.goodsPrice1.text = [NSString stringWithFormat:@"￥%@",[datas[indexPath.row] objectForKey:@"Price"]];

    
    cell.addShoppingCartButton1.tag = indexPath.row;
    [cell.addShoppingCartButton1 addTarget:self action:@selector(addShoppingCartButton1:) forControlEvents:UIControlEventTouchUpInside];
    cell.goodsClick.tag = indexPath.row;
    [cell.goodsClick addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];

    
    cell.goodsDescribe1.hidden = YES;
    cell.goodsDescribe2.hidden = YES;
    cell.goodsDescribe3.hidden = YES;
    /**
     老价格加下划线
     **/
    NSString *oldPrice = @"¥ 99.9";
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
    [cell.goodsOldPrice1 setAttributedText:attri];
    cell.goodsOldPrice1.hidden = YES;
    
    return cell;
}
#pragma mark 加入购物车
-(void)addShoppingCartButton1:(UIButton *)sender{

    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    GatherTogetherCollectionViewCell *cell = (GatherTogetherCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    if ([_isAct isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[sender.tag]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsAdd" object:datas[sender.tag]];
    }
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];

}
-(void)goodsClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setIsAct:_isAct];
    [goodsDetailsVC setGetID:datas[sender.tag]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/2-12, SCREENWIDTH/2+70);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 7, 4, 7);
}
#pragma mark 0-5
- (IBAction)button1Click:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self MinatoList:@"5" min:@"0"];
    }];
}
#pragma mark 5-10
- (IBAction)button2Click:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*3-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self MinatoList:@"10" min:@"5"];
    }];
}
#pragma mark 10-15
- (IBAction)button3Click:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*5-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self MinatoList:@"15" min:@"10"];

    }];
}
#pragma mark 20以上
- (IBAction)button4Click:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*7-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self MinatoList:@"0" min:@"20"];
    }];
}
#pragma mark 初始化滑动线
-(void)initSlidingLine{
    redLine = [[UIView alloc]init];
    [redLine setFrame:CGRectMake(SCREENWIDTH/8-30, 106, 60, 2)];
    redLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:redLine];
}
- (IBAction)shoppingCarButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
