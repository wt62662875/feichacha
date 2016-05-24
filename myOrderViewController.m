//
//  myOrderViewController.m
//  feichacha
//
//  Created by wt on 16/4/27.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "myOrderViewController.h"
#import "myOrderTableViewCell.h"

@interface myOrderViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *redLine;

}

@end

@implementation myOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSlidingLine];
    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 146;
    }else{
        return 187;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myOrderTableViewCell";
    myOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"myOrderTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        cell.footButtonView.hidden = YES;
    }
    [cell.image1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/myorder_img1.png"]];
    [cell.image2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/myorder_img1.png"]];
    [cell.image3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/myorder_img1.png"]];
    
    cell.statelabel.text = @"受理中";
    cell.footButton.tag = indexPath.row;
    [cell.footButton addTarget:self action:@selector(footButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.footButton2.hidden = YES;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"myOrderToOrderDetails" sender:self];
}

#pragma mark 底部按钮
-(void)footButton:(UIButton *)sender{
    UIActionSheet *actionsheet =[[UIActionSheet alloc]initWithTitle:@"去支付" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付",@"支付宝支付", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:self.view];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"1");
    }else if (buttonIndex == 1){
        NSLog(@"2");
    }
}

#pragma mark 全部订单
- (IBAction)allOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8-30, 106, 60, 2);
    }completion:^(BOOL finished) {
    }];
}
#pragma mark 待付款订单
- (IBAction)obligationOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*3-30, 106, 60, 2);
    }completion:^(BOOL finished) {
    }];
}
#pragma mark 待收货订单
- (IBAction)ForTheGoodsOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*5-30, 106, 60, 2);
    }completion:^(BOOL finished) {
    }];
}
#pragma mark 待评价订单
- (IBAction)ToEvaluateOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*7-30, 106, 60, 2);
    }completion:^(BOOL finished) {
    }];
}
#pragma mark 初始化滑动线
-(void)initSlidingLine{
    redLine = [[UIView alloc]init];
    if ([_orderType isEqualToString:@"allOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8-30, 106, 60, 2)];
    }else if ([_orderType isEqualToString:@"obligationOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8*3-30, 106, 60, 2)];
    }if ([_orderType isEqualToString:@"ForTheGoodsOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8*5-30, 106, 60, 2)];
    }if ([_orderType isEqualToString:@"ToEvaluateOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8*7-30, 106, 60, 2)];
    }
    redLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:redLine];
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
