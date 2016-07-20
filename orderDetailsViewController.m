//
//  orderDetailsViewController.m
//  feichacha
//
//  Created by wt on 16/4/27.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "orderDetailsViewController.h"
#import "orderStateTableViewCell.h"
#import "orderDetailsTableViewCell.h"
#import "orderDetailsGoodsTableViewCell.h"
#import "orderDetailsFootTableViewCell.h"

@interface orderDetailsViewController ()<UIActionSheetDelegate>
{
    BOOL stateOrDetails;
}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *orderStateButton;
@property (weak, nonatomic) IBOutlet UIButton *orderDetailsButton;

@property (weak, nonatomic) IBOutlet UIButton *footButton1;
@property (weak, nonatomic) IBOutlet UIButton *footButton2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation orderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayer];
    stateOrDetails = YES;
    NSLog(@"%@",_getDatas);

    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (stateOrDetails) {
        return 3;
    }else{
        return 4;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (stateOrDetails) {
        return 70;
    }else{
        if (indexPath.row == 0) {
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
            CGSize titleSize =[@"备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注"  boundingRectWithSize:CGSizeMake(SCREENWIDTH-84, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            return titleSize.height + 332;
        }else if (indexPath.row == 3){
            return 44;
        }else{
            return 35;
        }
        
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (stateOrDetails) {
        static NSString *cellIdentifier = @"orderStateTableViewCell";
        orderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"orderStateTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            cell.line1.hidden = YES;
            [cell.roundImageView setImage:[UIImage imageNamed:@"yuan_1.png"]];
        }else if (indexPath.row == 2){
            cell.line2.hidden = YES;
        }
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"orderDetailsTableViewCell";
            orderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDetailsTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.note.text = @"备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注";

            
            return cell;
        }else if (indexPath.row == 3){
            static NSString *cellIdentifier = @"orderDetailsFootTableViewCell";
            orderDetailsFootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDetailsFootTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            return cell;
        }else{
            static NSString *cellIdentifier = @"orderDetailsGoodsTableViewCell";
            orderDetailsGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDetailsGoodsTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            return cell;
        }
       
    }
    
}
#pragma mark 底部button点击
- (IBAction)button1Click:(id)sender {
    UIActionSheet *actionsheet =[[UIActionSheet alloc]initWithTitle:@"去支付" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付",@"支付宝支付", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:self.view];
}
- (IBAction)button2Click:(id)sender {
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"1");
    }else if (buttonIndex == 1){
        NSLog(@"2");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 订单状态
- (IBAction)orderStateClick:(id)sender {
    stateOrDetails = YES;
    _orderStateButton.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _orderDetailsButton.backgroundColor = [UIColor whiteColor];
    [_orderStateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_orderDetailsButton setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];
    
    [_tableView reloadData];
}
#pragma mark 订单详情
- (IBAction)orderDetailsClick:(id)sender {
    stateOrDetails = NO;
    _orderDetailsButton.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _orderStateButton.backgroundColor = [UIColor whiteColor];
    [_orderDetailsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_orderStateButton setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];
    
    [_tableView reloadData];
}
-(void)initLayer{
    _titleView.layer.cornerRadius = 4;
    _titleView.layer.masksToBounds = YES;
    _titleView.layer.borderWidth = 1;
    _titleView.layer.borderColor = RGBCOLORA(255, 214, 0, 1).CGColor;
    _footButton1.layer.cornerRadius = 4;
    _footButton2.layer.cornerRadius = 4;

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
