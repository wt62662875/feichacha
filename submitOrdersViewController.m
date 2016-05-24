//
//  submitOrdersViewController.m
//  feichacha
//
//  Created by wt on 16/5/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "submitOrdersViewController.h"
#import "submitOrderGoodsTableViewCell.h"
#import "submitOrderHeadView.h"
#import "submitOrderSectionHeadView.h"
#import "submitOrderSectionFootView.h"
#import "submitOrderFootView.h"

@interface submitOrdersViewController ()
{
    submitOrderHeadView *headView;
    submitOrderFootView *footView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation submitOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.01f)];
    self.tableView.tableHeaderView = view;
    footView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderFootView" owner:self options:nil][0];
    [footView setFrame:CGRectMake(0, 0, SCREENWIDTH, 157)];
    self.tableView.tableFooterView = footView;

    
    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else {
        return 3;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 35;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"submitOrderGoodsTableViewCell";
    submitOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"submitOrderGoodsTableViewCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 4) {
        cell.goodsDescribe.hidden = YES;
        cell.goodsNumber.hidden = YES;
        cell.goodsPrice.text = @"x1";
    }
    
    return cell;
}

#pragma mark 有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
#pragma mark 头有多高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 228;
    }else{
        return 35;
    }
}
#pragma mark 头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        headView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderHeadView" owner:self options:nil][0];
        [headView.couponsButton addTarget:self action:@selector(couponsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return headView;
    }else{
        submitOrderSectionHeadView *sectionHeadView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderSectionHeadView" owner:self options:nil][0];
        if (section == 1) {
            sectionHeadView.name.text = @"叉叉精选";
        }else if (section == 2) {
            sectionHeadView.name.text = @"叉叉代购";
        }else if (section == 3) {
            sectionHeadView.name.text = @"其他商品";
        }else if (section == 4) {
            sectionHeadView.name.text = @"中奖商品";
        }
        
        return sectionHeadView;
    }

}
#pragma mark 底部有多高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else if(section == 4){
        return 0.001;
    }else{
        return 45;
    }
}
#pragma mark 底部内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    submitOrderSectionFootView *sectionFootView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderSectionFootView" owner:self options:nil][0];
    if (section == 0) {
        return nil;
    }else if(section == 4){
        return nil;
    }else{
        
        return sectionFootView;
    }
}
#pragma mark 跳转优惠卷
-(void)couponsButtonClick:(UIButton *)sender{
    [self performSegueWithIdentifier:@"submitOrdersToCoupons" sender:self];
}

- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
