//
//  aDishThatGoesWithLiquorViewController.m
//  feichacha
//
//  Created by wt on 16/5/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "aDishThatGoesWithLiquorViewController.h"
#import "aDishThatGoesWithLiquorTableViewCell1.h"
#import "aDishThatGoesWithLiquorTableViewCell2.h"
#import "baseViewController.h"

@interface aDishThatGoesWithLiquorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation aDishThatGoesWithLiquorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    [self initHeadFootView];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2 == 0) {
        static NSString *cellIdentifier = @"aDishThatGoesWithLiquorTableViewCell1";
        aDishThatGoesWithLiquorTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"aDishThatGoesWithLiquorTableViewCell1" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xia_img1.jpg"]];
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"aDishThatGoesWithLiquorTableViewCell2";
        aDishThatGoesWithLiquorTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"aDishThatGoesWithLiquorTableViewCell2" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xia_img1.jpg"]];
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
}
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    if (sender.tag %2 == 0) {
        aDishThatGoesWithLiquorTableViewCell1 *cell = (aDishThatGoesWithLiquorTableViewCell1 *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }else{
        aDishThatGoesWithLiquorTableViewCell2 *cell = (aDishThatGoesWithLiquorTableViewCell2 *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }
}

-(void)initHeadFootView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.454)];
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:headView.frame];
    [headImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xia_banner.png"]];
    [headView addSubview:headImage];
    _tableView.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.171)];
    UIImageView *footImage = [[UIImageView alloc]initWithFrame:footView.frame];
    [footImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/xia_bottom_img.png"]];
    [footView addSubview:footImage];
    _tableView.tableFooterView = footView;
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
