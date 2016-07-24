//
//  serchViewController.m
//  feichacha
//
//  Created by wt on 16/5/15.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "serchViewController.h"
#import "serchCollectionViewCell.h"
#import "serchHeadCollectionReusableView.h"
#import "baseViewController.h"

@interface serchViewController ()<JCTagViewDelegate,UITextFieldDelegate>
{
    UIButton *comprehensiveButton;
    UIButton *salesButton;
    UIButton *thePriceButton;
    BOOL thePriceBool;
    BOOL changeBool;
    
    UILabel *hotSerch;
    JCTagView *JCView;
    UILabel *historySerch;
    JCTagView *JCView2;
    UIButton *clearHistory;
    
    NSArray *datas;
}
@property (weak, nonatomic) IBOutlet UIView *serchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBackViewHeigh;
@property (weak, nonatomic) IBOutlet UIView *backScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;

@property (weak, nonatomic) IBOutlet UITextField *serchTextField;
///数组数据源
@property (nonatomic, strong) NSArray *dataSource;

///数组数据源
@property (nonatomic, strong) NSArray *dataSource2;
@end

@implementation serchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    _serchView.layer.cornerRadius = 4;
    _serchView.layer.borderWidth = 1;
    _serchView.layer.borderColor = RGBCOLORA(190, 190, 190, 1).CGColor;
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    // Do any additional setup after loading the view.
    _collectionView.hidden = YES;
    _badgeView.hidden = YES;
    [self initJCTagView];
}
- (IBAction)changed:(id)sender {
    if (_serchTextField.text.length == 0) {
        _collectionView.hidden = YES;
        _badgeView.hidden = YES;
    }
}
//搜索接口
-(void)serchAPI:(NSString *)order{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] serchGoods:[USERDEFAULTS objectForKey:@"shopID"] serchStr:_serchTextField.text Order:order success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[NSArray alloc]init];
            datas = [responseObject objectForKey:@"AppendData"];
            [_collectionView reloadData];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];

}
//点击搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self serchAdd:textField.text];
    [self initJCTagView];
    _collectionView.hidden = NO;
    _badgeView.hidden = NO;
    [self serchAPI:@"ture"];
    
    return YES;
}
///懒加载
- (NSArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSArray arrayWithObjects:@"大家",@"你是什么",@"是不是呢",@"想要什么呢",@"吃大餐了哦哦哦",@"技术部的大牛",@"商场部的技术",@"全体人员注意了。开始了",@"全体人员注意了。开始了",@"全体人员注意了。开始了",@"全体人员注意了。开始了",@"全体人员注意了。开始了",@"全体人员注意了。开始了", nil];
    }
    return _dataSource;
}
- (NSArray *)dataSource2 {
//    if (!_dataSource2) {
        self.dataSource2 = [USERDEFAULTS objectForKey:@"SearchRecord"];
//    }
    return _dataSource2;
}
//搜索记录增加变更
-(void)serchAdd:(NSString *)sender{
    NSMutableArray * temp = [[NSMutableArray alloc]initWithArray:[USERDEFAULTS objectForKey:@"SearchRecord"]];
    
    if ([temp containsObject:sender]) {
        [temp removeObject:sender];
        [temp insertObject:sender atIndex:0];
    }else{
        [temp insertObject:sender atIndex:0];
    }
    if (temp.count >10) {
        [temp removeLastObject];
    }
    [USERDEFAULTS setObject:temp forKey:@"SearchRecord"];
}
-(void)initJCTagView{
    [hotSerch removeFromSuperview];
    [JCView removeFromSuperview];
    [historySerch removeFromSuperview];
    [JCView2 removeFromSuperview];
    [clearHistory removeFromSuperview];
    
//    hotSerch = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, SCREENWIDTH, 22)];
//    hotSerch.text = @"热门搜索";
//    hotSerch.font = [UIFont systemFontOfSize:15];
//    hotSerch.textColor = RGBCOLORA(139, 139, 139, 1);
//    [_backScrollView addSubview:hotSerch];
//    
//    JCView = [[JCTagView alloc] initWithFrame:CGRectMake(0, 38, SCREENWIDTH, 0)];
//    JCView.delegate = self;
//    JCView.JCSignalTagColor = [UIColor whiteColor];
//    JCView.JCbackgroundColor = [UIColor clearColor];
//    [JCView setArrayTagWithLabelArray:self.dataSource];
//    [_backScrollView addSubview:JCView];
    
//    historySerch = [[UILabel alloc]initWithFrame:CGRectMake(8, JCView.frame.size.height+50, SCREENWIDTH, 22)];
    historySerch = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, SCREENWIDTH, 22)];

    historySerch.text = @"历史搜索";
    historySerch.font = [UIFont systemFontOfSize:15];
    historySerch.textColor = RGBCOLORA(139, 139, 139, 1);
    [_backScrollView addSubview:historySerch];
    
//    JCView2 = [[JCTagView alloc] initWithFrame:CGRectMake(0, historySerch.frame.origin.y+30, SCREENWIDTH, 0)];
    JCView2 = [[JCTagView alloc] initWithFrame:CGRectMake(0,38, SCREENWIDTH, 0)];

    JCView2.delegate = self;
    JCView2.JCSignalTagColor = [UIColor whiteColor];
    JCView2.JCbackgroundColor = [UIColor clearColor];
    [JCView2 setArrayTagWithLabelArray:self.dataSource2];
    [_backScrollView addSubview:JCView2];
    
    clearHistory = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearHistory setFrame:CGRectMake(20, JCView2.frame.origin.y+JCView2.frame.size.height+20, SCREENWIDTH-40, 30)];
    clearHistory.layer.cornerRadius = 4;
    clearHistory.layer.borderWidth = 1;
    clearHistory.layer.borderColor = RGBCOLORA(224, 224, 224, 1).CGColor;
    [clearHistory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearHistory.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearHistory setTitle:@"清空历史" forState:UIControlStateNormal];
    [clearHistory addTarget:self action:@selector(clearHistoryClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:clearHistory];
    
    _scrollBackViewHeigh.constant = clearHistory.frame.origin.y + 40;

}
-(void)buttonClick:(NSString *)str{
    _serchTextField.text = str;
    [self textFieldShouldReturn:_serchTextField];

}
//清空历史记录
-(void)clearHistoryClick:(UIButton *)sender{
    [USERDEFAULTS removeObjectForKey:@"SearchRecord"];
    [self initJCTagView];
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return datas.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"serchCollectionViewCell";
    serchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]]];
    cell.addShoppingCartButton1.tag = indexPath.row;
    [cell.addShoppingCartButton1 addTarget:self action:@selector(addShoppingCartButton1:) forControlEvents:UIControlEventTouchUpInside];
    cell.goodsName.text = [datas[indexPath.row] objectForKey:@"Name"];
    cell.goodsPrice1.text = [NSString stringWithFormat:@"￥%.1f",[[datas[indexPath.row] objectForKey:@"Price"] floatValue]];
    cell.goodsMessage1.text = [datas[indexPath.row] objectForKey:@"Size"];
    if (![[datas[indexPath.row] objectForKey:@"IsDirect"] boolValue]) {
        cell.goodsDescribe1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
        cell.goodsDescribe1.layer.borderWidth = 1;
        cell.goodsDescribe1.layer.cornerRadius = 8;
        cell.goodsDescribe1.text = @"进";
        cell.goodsDescribe1.textColor = RGBCOLORA(114, 172, 74, 1);
        cell.goodsDescribe2.hidden = YES;
    }
    if (![[datas[indexPath.row]objectForKey:@"IsImport"] boolValue]) {
        cell.goodsDescribe1.hidden = YES;
    }
    
    cell.goodsDescribe3.hidden = YES;
    cell.goodsOldPrice1.hidden = YES;
//    /**
//     老价格加下划线
//     **/
//    NSString *oldPrice = @"¥ 99.9";
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
//    [cell.goodsOldPrice1 setAttributedText:attri];
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/2-12, SCREENWIDTH/2+70);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 7, 8, 7);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        serchHeadCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"serchHeadCollectionReusableView" forIndexPath:indexPath];
        
        
        if (!changeBool) {
            comprehensiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            salesButton = [UIButton buttonWithType:UIButtonTypeCustom];
            thePriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [comprehensiveButton setFrame:CGRectMake(0, 8, SCREENWIDTH/3, 26)];
            [salesButton setFrame:CGRectMake(SCREENWIDTH/3, 8, SCREENWIDTH/3, 26)];
            [thePriceButton setFrame:CGRectMake(SCREENWIDTH/3*2, 8, SCREENWIDTH/3, 26)];
            [comprehensiveButton setTitle:@"综合" forState:UIControlStateNormal];
            [salesButton setTitle:@"销量" forState:UIControlStateNormal];
            [thePriceButton setTitle:@"价格" forState:UIControlStateNormal];
            comprehensiveButton.titleLabel.font = [UIFont systemFontOfSize:15];
            salesButton.titleLabel.font = [UIFont systemFontOfSize:15];
            thePriceButton.titleLabel.font = [UIFont systemFontOfSize:15];
            thePriceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30);
            thePriceButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
            [comprehensiveButton setTitleColor:RGBCOLORA(239, 114, 30, 1) forState:UIControlStateNormal];
            [salesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [thePriceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [thePriceButton setImage:[UIImage imageNamed:@"arrow_bottom"] forState:UIControlStateNormal];
            [comprehensiveButton addTarget:self action:@selector(comprehensiveButton:) forControlEvents:UIControlEventTouchUpInside];
            [salesButton addTarget:self action:@selector(salesButton:) forControlEvents:UIControlEventTouchUpInside];
            [thePriceButton addTarget:self action:@selector(thePriceButton:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [headView addSubview:comprehensiveButton];
            [headView addSubview:salesButton];
            [headView addSubview:thePriceButton];
        }
        changeBool = YES;
        return headView;
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {SCREENWIDTH,44};
    return size;
}
#pragma mark 加入购物车
-(void)addShoppingCartButton1:(UIButton *)sender{
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    serchCollectionViewCell *cell = (serchCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsAdd" object:datas[sender.tag]];
    _badgeLabel.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark 综合
-(void)comprehensiveButton:(UIButton *)sender{
    [comprehensiveButton setTitleColor:RGBCOLORA(239, 114, 30, 1) forState:UIControlStateNormal];
    [salesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [thePriceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [thePriceButton setImage:[UIImage imageNamed:@"arrow_bottom"] forState:UIControlStateNormal];
    thePriceBool = NO;
}
#pragma mark 销量
-(void)salesButton:(UIButton *)sender{
    [comprehensiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [salesButton setTitleColor:RGBCOLORA(239, 114, 30, 1) forState:UIControlStateNormal];
    [thePriceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [thePriceButton setImage:[UIImage imageNamed:@"arrow_bottom"] forState:UIControlStateNormal];
    thePriceBool = NO;
}
#pragma mark 价格
-(void)thePriceButton:(UIButton *)sender{
    [comprehensiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [salesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [thePriceButton setTitleColor:RGBCOLORA(239, 114, 30, 1) forState:UIControlStateNormal];
    
    thePriceBool = !thePriceBool;
    if (thePriceBool) {
        [thePriceButton setImage:[UIImage imageNamed:@"arrow_top_1"] forState:UIControlStateNormal];
        [self serchAPI:@"true"];
    }else{
        [thePriceButton setImage:[UIImage imageNamed:@"arrow_bottom_1"] forState:UIControlStateNormal];
        [self serchAPI:@"false"];
    }
    
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
