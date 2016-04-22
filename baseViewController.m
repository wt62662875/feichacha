//
//  baseViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "baseViewController.h"
#import "tabBarViewController.h"
#import "guideView.h"
#import "shufflingTableViewCell.h"
#import "classificationTableViewCell.h"
#import "headlinesTableViewCell.h"
#import "recommendFourTableViewCell.h"
#import "goodsProjectTableViewCell.h"

@interface baseViewController ()<SDCycleScrollViewDelegate>
{
    UIView *backView; //引导页背景
    
    BOOL isbool;
}
@property (weak, nonatomic) IBOutlet UILabel *deliveryTo;   //配送至
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
// 合作商家5按钮    [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];
// 非合作商家4按钮   [[NSNotificationCenter defaultCenter] postNotificationName:@"initFourButton" object:nil];
@implementation baseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];
    
    _deliveryTo.layer.borderColor = [UIColor blackColor].CGColor;
    _deliveryTo.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view.
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [self initGuideView];
    }

}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 125;
    }else if(indexPath.row == 1){
        return 70;
    }else if(indexPath.row == 2){
        return 145;
    }else if (indexPath.row == 3){
        return 120;
    }else if (indexPath.row >= 4 &&indexPath.row <= 12){
        return 365;
    }
    return 145;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"shufflingTableViewCell";
        shufflingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"shufflingTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.shufflingView.delegate = self;
        cell.shufflingView.imageURLStringsGroup = [[NSArray alloc]initWithObjects:@"http://manage.feichacha.com/html/shop/images/index_banner_top1.jpg",@"http://manage.feichacha.com/html/shop/images/f_index_banner_top1.jpg",@"http://banbao.chazidian.com/uploadfile/2016-01-25/s145368924044608.jpg", nil];
        cell.shufflingView.placeholderImage = [UIImage imageNamed:@"bg.png"];
        cell.shufflingView.autoScrollTimeInterval = 3.0;
        
        
        return cell;
    }else if(indexPath.row == 1){
        static NSString *cellIdentifier = @"classificationTableViewCell";
        classificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"classificationTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        return cell;
    }else if(indexPath.row == 2){
        static NSString *cellIdentifier = @"headlinesTableViewCell";
        headlinesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"headlinesTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg1.jpg"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg2.jpg"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg3.jpg"]];
        [cell.salesPromotionClick addTarget:self action:@selector(salesPromotionClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classClick1 addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classClick2 addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classClick3 addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if(indexPath.row == 3){
        static NSString *cellIdentifier = @"recommendFourTableViewCell";
        recommendFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"recommendFourTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg4.png"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg5.png"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg6.png"]];
        [cell.image4 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg7.png"]];
        [cell.button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if(indexPath.row >= 4 &&indexPath.row <= 12){
        static NSString *cellIdentifier = @"goodsProjectTableViewCell";
        goodsProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"goodsProjectTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row == 4) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom1.jpg"]];
        }else if(indexPath.row == 5) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom2.jpg"]];
        }else if(indexPath.row == 6) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom3.jpg"]];
        }else if(indexPath.row == 7) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom4.jpg"]];
        }else if(indexPath.row == 8) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom5.jpg"]];
        }else if(indexPath.row == 9) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom6.jpg"]];
        }else if(indexPath.row == 10) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom7.jpg"]];
        }else if(indexPath.row == 11) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom8.jpg"]];
        }else if(indexPath.row == 12) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom9.jpg"]];
        }
        
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img1.png"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img2.png"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img3.png"]];
        
        /**
         老价格加下划线
         **/
        NSString *oldPrice = @"¥ 99.9";
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
        [cell.goodsOldPrice1 setAttributedText:attri];
        [cell.goodsOldPrice2 setAttributedText:attri];
        [cell.goodsOldPrice3 setAttributedText:attri];

        
        return cell;
    }
    
    return nil;
}
#pragma mark 促销点击事件
-(void)salesPromotionClick:(UIButton *)sender{
    NSLog(@"促销");
}
#pragma mark 热卖的3件商品点击事件
-(void)classClick:(UIButton *)sender{
    if (sender.tag == 0) {
        NSLog(@"芒果");
    }else if (sender.tag == 1) {
        NSLog(@"酸奶");
    }else if (sender.tag == 2) {
        NSLog(@"草莓");
    }
}
#pragma mark 分类的4个  点击事件
-(void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            NSLog(@"分类1");
            break;
        case 1:
            NSLog(@"分类2");
            break;
        case 2:
            NSLog(@"分类3");
            break;
        case 3:
            NSLog(@"分类4");
            break;
        default:
            break;
    }
}


#pragma mark - SDCycleScrollViewDelegate 点击轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}
#pragma mark 搜索按钮
- (IBAction)serchClick:(id)sender {
    NSLog(@"serch");
}
#pragma mark 新手引导图
-(void)initGuideView{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    [backView setBackgroundColor:[UIColor blackColor]];
    backView.alpha = 0.6;
    
    guideView *guiView = [[NSBundle mainBundle] loadNibNamed:@"guideView" owner:self options:nil][0];
    [guiView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    [guiView.removeViewClick addTarget:self action:@selector(removeViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:guiView];
    [self.navigationController.view addSubview:backView];
}
#pragma mark 关闭新手引导页
-(void)removeViewClick:(UIButton *)sender{
    [backView removeFromSuperview];
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
