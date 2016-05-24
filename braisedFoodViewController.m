//
//  braisedFoodViewController.m
//  feichacha
//
//  Created by wt on 16/5/12.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "braisedFoodViewController.h"
#import "braisedFoodTableViewCell1.h"
#import "braisedFoodTableViewCell2.h"
#import "baseViewController.h"

@interface braisedFoodViewController ()
{
    UIView *navigationView;
    
    float classHeadViewY1;
    float classHeadViewY2;
    float classHeadViewY3;
    float classHeadViewY4;
    float classHeadViewY5;

    UIButton *navButton1;
    UIButton *navButton2;
    UIButton *navButton3;
    UIButton *navButton4;
    UIButton *navButton5;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@end

@implementation braisedFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeLabel.layer.cornerRadius = 8;
    _badgeLabel.layer.masksToBounds = YES;
    
    [self initNavigationView];
    classHeadViewY1 = SCREENWIDTH*0.486;
    if (12 % 2 == 0) {
        classHeadViewY2 = classHeadViewY1 +61+132*4;
        classHeadViewY3 = classHeadViewY2 +61+(SCREENWIDTH/2+100)*2;
        classHeadViewY4 = classHeadViewY3 +61+(SCREENWIDTH/2+100)*2;
        classHeadViewY5 = classHeadViewY4 +61+(SCREENWIDTH/2+100)*2;

    }else{
        classHeadViewY2 = classHeadViewY1 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        classHeadViewY3 = classHeadViewY2 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        classHeadViewY4 = classHeadViewY3 +44+187+(SCREENWIDTH/2+74)*(12/2+1)+4;
        
    }
    // Do any additional setup after loading the view from its nib.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 2;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 132;
    }else{
        return SCREENWIDTH/2+100;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"braisedFoodTableViewCell1";
        braisedFoodTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"braisedFoodTableViewCell1" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/lw_img1.jpg"]];
        cell.buyButton.tag = indexPath.row;
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }else{
        static NSString *cellIdentifier = @"braisedFoodTableViewCell2";
        braisedFoodTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"braisedFoodTableViewCell2" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/lw_img1.jpg"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/lw_img1.jpg"]];

        [cell.buyButton1 addTarget:self action:@selector(buyButton1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buyButton2 addTarget:self action:@selector(buyButton2:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 61;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 92)];
    headView.backgroundColor = RGBCOLORA(248, 242, 226, 1);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-59, -4, 118, 61)];
    [image setImage:[UIImage imageNamed:@"cooked_title"]];
    [headView addSubview:image];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-59, 0, 118, 61)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBCOLORA(248, 242, 226, 1);
    if (section == 0) {
        label.text = @"小编热荐";
    }else if (section == 1) {
        label.text = @"陈麻麻";
    }else if (section == 2) {
        label.text = @"唯一卤味";
    }else if (section == 3) {
        label.text = @"紫燕百味鸡";
    }else if (section == 4) {
        label.text = @"廖记棒棒鸡";
    }
    [headView addSubview:label];
    
    return headView;
}

#pragma mark 横排购买
-(void)buyButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    braisedFoodTableViewCell1 *cell = (braisedFoodTableViewCell1 *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.image selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
}
#pragma mark 竖排购买1
-(void)buyButton1:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    braisedFoodTableViewCell2 *cell = (braisedFoodTableViewCell2 *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    
}
#pragma mark 竖排购买2
-(void)buyButton2:(UIButton *)sender{
    UIView *temp = [sender superview];
    UIView *temp1 = [temp superview];
    UITableViewCell *tempCell = (UITableViewCell *)[temp1 superview];//获取cell
    NSIndexPath *indexPath = [_tableView indexPathForCell:tempCell];//获取cell对应的section
    
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    braisedFoodTableViewCell2 *cell = (braisedFoodTableViewCell2 *)[_tableView cellForRowAtIndexPath:indexPath];
    [baseVC addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
}





// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    CGPoint point=scrollView.contentOffset;
    CGRect frame = [navigationView frame];
    if (point.y >= SCREENWIDTH*0.486) {
        frame.origin.y = 64;
    }else{
        frame.origin.y = SCREENWIDTH*0.486+64 - point.y;
    }
    navigationView.frame = frame;
    
    [navButton1 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton2 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton3 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton4 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton5 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];

    if (point.y >= classHeadViewY1 && point.y < classHeadViewY2) {
        [navButton1 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }else if (point.y >= classHeadViewY2 && point.y < classHeadViewY3){
        [navButton2 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }else if (point.y >= classHeadViewY3 && point.y < classHeadViewY4){
        [navButton3 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }else if (point.y >= classHeadViewY4 && point.y < classHeadViewY5){
        [navButton4 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }else if (point.y >= classHeadViewY5 ){
        [navButton5 setBackgroundColor:RGBCOLORA(177, 6, 32, 1)];
    }
    
}
-(void)initNavigationView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.486+78)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.486)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/lw_banner.jpg"]];
    [headView addSubview:imageView];
    _tableView.tableHeaderView = headView;
    
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.486+64, SCREENWIDTH, 78)];
    navigationView.backgroundColor = RGBCOLORA(150, 2, 25, 1);
    

    navButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton1 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton1 setFrame:CGRectMake(0, 0, SCREENWIDTH/3, 39)];
    [navButton1 setTitle:@"小编热荐" forState:UIControlStateNormal];
    
    navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton2 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton2 setFrame:CGRectMake(SCREENWIDTH/3, 0, SCREENWIDTH/3, 39)];
    [navButton2 setTitle:@"陈麻麻" forState:UIControlStateNormal];
    
    navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton3 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton3 setFrame:CGRectMake(SCREENWIDTH/3*2, 0, SCREENWIDTH/3, 39)];
    [navButton3 setTitle:@"唯一卤味" forState:UIControlStateNormal];
    
    navButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton4.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton4 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton4 setFrame:CGRectMake(0, 39, SCREENWIDTH/3, 39)];
    [navButton4 setTitle:@"紫燕百味鸡" forState:UIControlStateNormal];
    
    navButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navButton5.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navButton5 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
    [navButton5 setFrame:CGRectMake(SCREENWIDTH/3, 39, SCREENWIDTH/3, 39)];
    [navButton5 setTitle:@"廖记棒棒鸡" forState:UIControlStateNormal];
    
//    navButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [navButton6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [navButton6.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [navButton6 setBackgroundColor:RGBCOLORA(150, 2, 25, 1)];
//    [navButton6 setFrame:CGRectMake(0, 39, SCREENWIDTH/3, 39)];
//    [navButton6 setTitle:@"紫燕百味鸡" forState:UIControlStateNormal];
    
    navButton1.tag = 1;
    navButton2.tag = 2;
    navButton3.tag = 3;
    navButton4.tag = 4;
    navButton5.tag = 5;

    [navButton1 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton2 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton3 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton4 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton5 addTarget:self action:@selector(navButton:) forControlEvents:UIControlEventTouchUpInside];

    [navigationView addSubview:navButton1];
    [navigationView addSubview:navButton2];
    [navigationView addSubview:navButton3];
    [navigationView addSubview:navButton4];
    [navigationView addSubview:navButton5];

    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    line1.backgroundColor = [UIColor blackColor];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3, 0, 1, 78)];
    line2.backgroundColor = [UIColor blackColor];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3*2, 0, 1, 78)];
    line3.backgroundColor = [UIColor blackColor];
    [navigationView addSubview:line1];
    [navigationView addSubview:line2];
    [navigationView addSubview:line3];
    
    
    [self.view addSubview:navigationView];
    
}
-(void)navButton:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY1+1) animated:YES];
            break;
        case 2:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY2+1) animated:YES];
            break;
        case 3:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY3+1) animated:YES];
            break;
        case 4:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY4+1) animated:YES];
            break;
        case 5:
            [_tableView setContentOffset:CGPointMake(0, classHeadViewY5+1) animated:YES];
            break;
        default:
            break;
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
