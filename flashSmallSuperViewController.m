//
//  flashSmallSuperViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "flashSmallSuperViewController.h"
#import "leftClassNameTableViewCell.h"
#import "headTitleTableViewCell.h"
#import "footTitleTableViewCell.h"
#import "flashGoodsTableViewCell.h"
#import "baseViewController.h"

@interface flashSmallSuperViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger selectCellTag;                //选中cell
}
@property (weak, nonatomic) IBOutlet UILabel *deliveryTo;   //配送至

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property(nonatomic,strong)NSMutableArray<CALayer *> *animationLayers;

@end

@implementation flashSmallSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _deliveryTo.layer.borderColor = [UIColor blackColor].CGColor;
    _deliveryTo.layer.borderWidth = 0.5;
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 7;
    }else{
        return 8;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 50;
    }else if (indexPath.row == 0) {
        return 22;
    }else if (indexPath.row == 7){
        return 95;
    }else{
        return 90;
    }
    
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        static NSString *cellIdentifier = @"leftClassNameTableViewCell";
        leftClassNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"leftClassNameTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == selectCellTag) {
            [cell.name setTintColor:[UIColor blackColor]];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }else{
            [cell.name setTintColor:RGBCOLORA(166, 166, 166, 1)];
            [cell setBackgroundColor:RGBCOLORA(248, 248, 248, 1)];
        }
        
       
        return cell;
    }else if(indexPath.row == 0){
        static NSString *cellIdentifier = @"headTitleTableViewCell";
        headTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"headTitleTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else if (indexPath.row == 7){
        static NSString *cellIdentifier = @"footTitleTableViewCell";
        footTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"footTitleTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;

    }else{
        static NSString *cellIdentifier = @"flashGoodsTableViewCell";
        flashGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"flashGoodsTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.addShoppingCartButton.tag = indexPath.row;
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/img1.png"]];
        [cell.addShoppingCartButton addTarget:self action:@selector(addShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
}
#pragma mark 加入购物车
-(void)addShoppingCartButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
     flashGoodsTableViewCell *cell = (flashGoodsTableViewCell *)[_rightTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        selectCellTag = indexPath.row;
        [_leftTableView reloadData];
    }
   
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
