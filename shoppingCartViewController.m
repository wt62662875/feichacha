//
//  shoppingCartViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "shoppingCartViewController.h"
#import "shoppingCartGoodsTableViewCell.h"
#import "shoppingCartHeadView.h"
#import "shoppingCartFootView.h"
#import "shoppingCartAddressTableViewCell.h"
#import "VerifyTheMobilePhoneViewController.h"

@interface shoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    shoppingCartHeadView *headView;
    shoppingCartFootView *footView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation shoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.01f)];
    self.tableView.tableHeaderView = view;

    
    // Do any additional setup after loading the view.
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return  5;
    }else{
        return 20;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize titleSize =[@"重庆市南岸区重庆市南岸区重庆市南岸区重庆市南岸区"  boundingRectWithSize:CGSizeMake(SCREENWIDTH-141, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return titleSize.height + 85;
    }else{
        return 35;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"shoppingCartAddressTableViewCell";
        shoppingCartAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartAddressTableViewCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.addressManage addTarget:self action:@selector(addressManage:) forControlEvents:UIControlEventTouchUpInside];

        cell.address.text = @"重庆市南岸区重庆市南岸区重庆市南岸区重庆市南岸区";

        return cell;
    }else{
        static NSString *cellIdentifier = @"shoppingCartGoodsTableViewCell";
        shoppingCartGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartGoodsTableViewCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"address");
    }
}

#pragma mark 有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
#pragma mark 头有多高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 137;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    headView = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartHeadView" owner:self options:nil][0];
    [headView setFrame:CGRectMake(0, 0, SCREENWIDTH, 137)];
    if (section == 0) {
        return nil;
    }else if(section == 2){
        [headView.flashImage setImage:[UIImage imageNamed:@"shop_cart_xxyd"]];
        [headView.flashButton setTitle:@"新鲜预定" forState:UIControlStateNormal];
        headView.arrowImage.hidden = YES;
        [headView.roundView setBackgroundColor:RGBCOLORA(131, 199, 252, 1)];
        headView.timeLabel2.hidden = YES;
        headView.timeLabel1.text = @"明天10：00-12：00";
        
        [headView.togetherButton addTarget:self action:@selector(togetherButton:) forControlEvents:UIControlEventTouchUpInside];
        return headView;
    }else{
        
        [headView.togetherButton addTarget:self action:@selector(togetherButton:) forControlEvents:UIControlEventTouchUpInside];
        return headView;
    }
    
    
}

#pragma mark  凑单专区
-(void)togetherButton:(UIButton *)sender{
    [self performSegueWithIdentifier:@"shoppingCartToGatherTogetherASingle" sender:self];
}
#pragma mark 底部有多高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else{
        return 61;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    footView = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartFootView" owner:self options:nil][0];
    [footView setFrame:CGRectMake(0, 0, SCREENWIDTH, 61)];
    footView.toPayButton.tag = section;
    [footView.toPayButton addTarget:self action:@selector(toPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        return nil;
    }else{
       
        return footView;
    }
}
#pragma mark 去支付
-(void)toPayButtonClick:(UIButton *)sender{
    [self performSegueWithIdentifier:@"shoppingCartViewToSubmitOrders" sender:self];
}
#pragma mark 跳转地址
-(void)addressManage:(UIButton *)sender{
    [self performSegueWithIdentifier:@"shoppingCartToAddressManage" sender:self];
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
