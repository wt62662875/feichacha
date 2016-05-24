//
//  afterSalesViewController.m
//  feichacha
//
//  Created by wt on 16/5/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "afterSalesViewController.h"
#import "myOrderTableViewCell.h"


@interface afterSalesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation afterSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    cell.footButton.tag = indexPath.row;
    cell.footButton2.tag = indexPath.row;
    [cell.footButton addTarget:self action:@selector(footButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.footButton2 addTarget:self action:@selector(footButton2:) forControlEvents:UIControlEventTouchUpInside];

    [cell.footButton setTitle:@"申请退款" forState:UIControlStateNormal];
    [cell.footButton2 setTitle:@"申请售后" forState:UIControlStateNormal];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"afterSalesToOrderDetails" sender:self];
}
#pragma mark 底部按钮
-(void)footButton:(UIButton *)sender{
    
}
#pragma mark 底部按钮2
-(void)footButton2:(UIButton *)sender{
    
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
