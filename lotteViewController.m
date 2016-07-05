//
//  lotteViewController.m
//  feichacha
//
//  Created by wt on 16/6/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "lotteViewController.h"
#import "lotteLeftTableViewCell.h"
#import "lotteRightTableViewCell.h"
#import "baseViewController.h"

@interface lotteViewController ()
{
    NSArray *datas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation lotteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    [self initHeadFootView];
    [self ActivityListDatas];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)ActivityListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] ActivityList:[_getDatas objectForKey:@"Id"] ActType:[_getDatas objectForKey:@"ActType"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[NSMutableArray alloc]init];
            datas = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ActivityProduct"];
            
            [_tableView reloadData];
            
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
    return datas.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2 == 0) {
        static NSString *cellIdentifier = @"lotteLeftTableViewCell";
        lotteLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"lotteLeftTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name.text = [datas[indexPath.row] objectForKey:@"Name"];
        cell.price.text = [NSString stringWithFormat:@"%@元",[datas[indexPath.row] objectForKey:@"Price"]];
        
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString *cellIdentifier = @"lotteRightTableViewCell";
        lotteRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"lotteRightTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[indexPath.row] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        cell.name.text = [datas[indexPath.row] objectForKey:@"Name"];
        cell.price.text = [NSString stringWithFormat:@"%@元",[datas[indexPath.row] objectForKey:@"Price"]];
        
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
}

#pragma mark cell里的加入购物车
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    if (sender.tag %2 == 0) {
        lotteLeftTableViewCell *cell = (lotteLeftTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }else{
        lotteRightTableViewCell *cell = (lotteRightTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    }
}

-(void)initHeadFootView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.385)];
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:headView.frame];
    [headImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_banner.png"]];
    [headView addSubview:headImage];
    _tableView.tableHeaderView = headView;

    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.462*5+SCREENWIDTH*0.825+SCREENWIDTH*0.199)];
    UIImageView *footImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.199)];
    [footImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_title.jpg"]];
    [footView addSubview:footImage];
    
    UIImageView *footImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.199, SCREENWIDTH, SCREENWIDTH*0.462)];
    [footImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_bottom1.jpg"]];
    [footView addSubview:footImage1];
    
    UIImageView *footImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.199+SCREENWIDTH*0.462, SCREENWIDTH, SCREENWIDTH*0.462)];
    [footImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_bottom2.jpg"]];
    [footView addSubview:footImage2];
    
    UIImageView *footImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.199+SCREENWIDTH*0.462*2, SCREENWIDTH, SCREENWIDTH*0.462)];
    [footImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_bottom3.jpg"]];
    [footView addSubview:footImage3];
    
    UIImageView *footImage4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.199+SCREENWIDTH*0.462*3, SCREENWIDTH, SCREENWIDTH*0.462)];
    [footImage4 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_bottom4.jpg"]];
    [footView addSubview:footImage4];
    
    UIImageView *footImage5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.199+SCREENWIDTH*0.462*4, SCREENWIDTH, SCREENWIDTH*0.462)];
    [footImage5 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_bottom5.jpg"]];
    [footView addSubview:footImage5];
    
    UIImageView *footImage6 = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.199+SCREENWIDTH*0.462*5, SCREENWIDTH, SCREENWIDTH*0.825)];
    [footImage6 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/le_bottom6.jpg"]];
    [footView addSubview:footImage6];
    
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
