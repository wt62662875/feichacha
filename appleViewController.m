//
//  appleViewController.m
//  feichacha
//
//  Created by wt on 16/5/9.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "appleViewController.h"
#import "baseViewController.h"

@interface appleViewController ()
{
    UIImageView *Image3;
    NSArray* datas;
    
    UILabel * badgeLabel;
    
    UIButton *addShoppingCart;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;

@end

@implementation appleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *Image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*1.2)];
    [Image1 setImage:[UIImage imageNamed:@"apple_banner.jpg"]];
    UIImageView *Image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, Image1.frame.size.height, SCREENWIDTH*0.36, SCREENWIDTH*0.43)];
    [Image2 setImage:[UIImage imageNamed:@"apple_porl.png"]];
    Image3 = [[UIImageView alloc]initWithFrame:CGRectMake(Image2.frame.size.width, Image1.frame.size.height, SCREENWIDTH*0.54, SCREENWIDTH*0.43)];
//    [Image3 setImage:[UIImage imageNamed:@"apple_porr.png"]];
    UIButton *tempButtom = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempButtom setFrame:Image3.frame];
    [tempButtom addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *Image4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, Image3.frame.size.height+Image3.frame.origin.y, SCREENWIDTH , SCREENWIDTH*1.14)];
    [Image4 setImage:[UIImage imageNamed:@"apple_bottom_img1.jpg"]];
    
    UIImageView *Image5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, Image4.frame.size.height+Image4.frame.origin.y, SCREENWIDTH , SCREENWIDTH*1.14)];
    [Image5 setImage:[UIImage imageNamed:@"apple_bottom_img2.jpg"]];
    
    UIImageView *Image6 = [[UIImageView alloc]initWithFrame:CGRectMake(0, Image5.frame.size.height+Image5.frame.origin.y, SCREENWIDTH , SCREENWIDTH*1.14)];
    [Image6 setImage:[UIImage imageNamed:@"apple_bottom_img3.jpg"]];
    
    UIImageView *Image7 = [[UIImageView alloc]initWithFrame:CGRectMake(0, Image6.frame.size.height+Image6.frame.origin.y, SCREENWIDTH , SCREENWIDTH*0.46)];
    [Image7 setImage:[UIImage imageNamed:@"apple_bottom_img4.jpg"]];
    
    addShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
    [addShoppingCart setFrame:CGRectMake(SCREENWIDTH*0.052, Image2.frame.origin.y+Image2.frame.size.height-8-25, 80, 25)];
    addShoppingCart.titleLabel.font = [UIFont systemFontOfSize:15];
    addShoppingCart.layer.cornerRadius = 4;
    addShoppingCart.backgroundColor = RGBCOLORA(255, 246, 104, 1);
    [addShoppingCart setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addShoppingCart setTitle:@"立即购买" forState:UIControlStateNormal];
    [addShoppingCart addTarget:self action:@selector(addShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_backView addSubview:Image1];
    [_backView addSubview:Image2];
    [_backView addSubview:Image3];
    [_backView addSubview:Image4];
    [_backView addSubview:Image5];
    [_backView addSubview:Image6];
    [_backView addSubview:Image7];
    [_backView addSubview:tempButtom];
    [_backView addSubview:addShoppingCart];


    _backViewHeight.constant = Image7.frame.size.height+Image7.frame.origin.y;
    // Do any additional setup after loading the view.
    
    
    UIButton * shoopingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shoopingCartButton setFrame:CGRectMake(SCREENWIDTH-64, SCREENHTIGHT-64, 44, 44)];
    [shoopingCartButton setImage:[UIImage imageNamed:@"shop_cart_icon1.png"] forState:UIControlStateNormal];
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-36, SCREENHTIGHT-64, 16, 16)];
    badgeLabel.font = [UIFont systemFontOfSize:12];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.text = @"99";
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.layer.cornerRadius = 8;
    badgeLabel.layer.masksToBounds = YES;
    
    if ([[USERDEFAULTS objectForKey:@"PurchaseQuantity"] intValue] == 0) {
        badgeLabel.hidden = YES;
    }else{
        badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
    }
    [shoopingCartButton addTarget:self action:@selector(shoopingCartButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shoopingCartButton];
    [self.view addSubview:badgeLabel];
    [self ActivityListDatas];

}
-(void)ActivityListDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] ActivityList:[_getDatas objectForKey:@"Id"] ActType:[_getDatas objectForKey:@"ActType"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ActivityProduct"];
            [Image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[datas[0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"apple_porr.png"]];
            if ([[datas[0] objectForKey:@"Stock"] intValue] == 0) {
                addShoppingCart.backgroundColor = [UIColor lightGrayColor];
                [addShoppingCart setTitle:@"已抢光" forState:UIControlStateNormal];
                addShoppingCart.userInteractionEnabled = NO;
            }
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark 加入购物车
-(void)addShoppingCart:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
    [baseVC addProductsAnimation:Image3 selfView:self.view pointX:SCREENWIDTH-44 pointY:SCREENHTIGHT-44];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:datas[0]];
    badgeLabel.hidden = NO;
    badgeLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"PurchaseQuantity"]];
}
#pragma mark 点击购物车
-(void)shoopingCartButton:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToShoppingCart" object:nil];
}
-(void)goodsClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
     [goodsDetailsVC setIsAct:@"1"];
    [goodsDetailsVC setGetID:datas[0]];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];

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
