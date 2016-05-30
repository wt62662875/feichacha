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
    
    NSArray *leftDatas;
    NSArray *rightDatas;

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
    
    [self getleftDatas];
}
-(void)getleftDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] listProClass:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            leftDatas = [[NSArray alloc]init];
            leftDatas = [responseObject objectForKey:@"AppendData"];
            [_leftTableView reloadData];
            [self getRightDatas:[leftDatas[0] objectForKey:@"Id"]];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)getRightDatas:(NSString *)classId{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] ClassProductList:[USERDEFAULTS objectForKey:@"shopID"] classId:classId success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            rightDatas = [[NSArray alloc]init];
            rightDatas = [responseObject objectForKey:@"AppendData"];
            [_rightTableView reloadData];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return leftDatas.count;
    }else{
        return rightDatas.count;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 50;
    }else if (indexPath.row == 0) {
        return 22;
    }else if (indexPath.row == rightDatas.count){
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
        cell.name.text = [leftDatas[indexPath.row] objectForKey:@"Name"];
       
        return cell;
    }else if(indexPath.row == 0){
        static NSString *cellIdentifier = @"headTitleTableViewCell";
        headTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"headTitleTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }else if (indexPath.row == rightDatas.count){
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
        NSString *imageURL = [IMGURL stringByAppendingString:[rightDatas[indexPath.row-1] objectForKey:@"ImageUrl"]];
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        [cell.addShoppingCartButton addTarget:self action:@selector(addShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.goodsName.text = [rightDatas[indexPath.row-1] objectForKey:@"Name"];
        cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",[rightDatas[indexPath.row-1] objectForKey:@"Price"]];
//        cell.goodsMessage.text = [rightDatas[indexPath.row-1] objectForKey:@"Size"];
        
        /**
         老价格加下划线
         **/
        NSString *oldPrice = [NSString stringWithFormat:@"￥%@",[rightDatas[indexPath.row-1] objectForKey:@"Price"]];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
        [cell.goodsOldPrice setAttributedText:attri];
        
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
        [self getRightDatas:[leftDatas[indexPath.row] objectForKey:@"Id"]];
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
