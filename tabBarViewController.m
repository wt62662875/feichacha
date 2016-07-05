//
//  tabBarViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "tabBarViewController.h"
#import "baseViewController.h"
#import "flashSmallSuperViewController.h"

@interface tabBarViewController ()
{
    UIView *tabbarView;
    
    UIImageView *image1;
    UIImageView *image2;
    UIImageView *image3;
    UIImageView *image4;
    UIImageView *image5;

    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;

    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;

}
@end

@implementation tabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden= YES;
    [self.tabBar removeFromSuperview];
    // Do any additional setup after loading the view.
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initFiveButton:) name:@"initFiveButton"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initFourButton:) name:@"initFourButton"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToFlashSmallSupper:) name:@"jumpToFlashSmallSupper"object:nil];
    
}

-(void)jumpToFlashSmallSupper:(NSNotification*)notification{
    [self btn2click:nil];
}
-(void)initFiveButton:(NSNotification*)notification{
    [tabbarView removeFromSuperview];
    [self initFiveButton];
}
-(void)initFourButton:(NSNotification*)notification{
    [tabbarView removeFromSuperview];
    [self initFourButton];
}
-(void)initFiveButton{
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHTIGHT-49, SCREENWIDTH, 49)];
    [tabbarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tabbarView];
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-10, 8, 20, 20)];
    [image1 setImage:[UIImage imageNamed:@"footer_nav1_1"]];
    image2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-10, 8, 20, 20)];
    [image2 setImage:[UIImage imageNamed:@"footer_nav2"]];
    image3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-10, 8, 20, 20)];
    [image3 setImage:[UIImage imageNamed:@"footer_nav3"]];
    image4 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-10, 8, 20, 20)];
    [image4 setImage:[UIImage imageNamed:@"footer_nav4"]];
    image5 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-10, 8, 20, 20)];
    [image5 setImage:[UIImage imageNamed:@"footer_nav5"]];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, SCREENWIDTH/5, 49);
    button2.frame = CGRectMake(SCREENWIDTH/5, 0, SCREENWIDTH/5, 49);
    button3.frame = CGRectMake(SCREENWIDTH/5*2, 0, SCREENWIDTH/5, 49);
    button4.frame = CGRectMake(SCREENWIDTH/5*3, 0, SCREENWIDTH/5, 49);
    button5.frame = CGRectMake(SCREENWIDTH/5*4, 0, SCREENWIDTH/5, 49);

    label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-15, 34, 30, 12)];
    label1.text = @"首页";
    label1.font = [UIFont boldSystemFontOfSize:10];
    label1.textColor = RGBCOLORA(155, 155, 155, 1);
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-30, 34, 60, 12)];
    label2.text = @"闪送小超";
    label2.font = [UIFont boldSystemFontOfSize:10];
    label2.textColor = RGBCOLORA(155, 155, 155, 1);
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-30, 34, 60, 12)];
    label3.text = @"新鲜预定";
    label3.font = [UIFont boldSystemFontOfSize:10];
    label3.textColor = RGBCOLORA(155, 155, 155, 1);
    label4 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-25, 34, 50, 12)];
    label4.text = @"购物车";
    label4.font = [UIFont boldSystemFontOfSize:10];
    label4.textColor = RGBCOLORA(155, 155, 155, 1);
    label5 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/5/2-15, 34, 30, 12)];
    label5.text = @"我的";
    label5.font = [UIFont boldSystemFontOfSize:10];
    label5.textColor = RGBCOLORA(155, 155, 155, 1);
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    label3.textAlignment = NSTextAlignmentCenter;
    label4.textAlignment = NSTextAlignmentCenter;
    label5.textAlignment = NSTextAlignmentCenter;

    
    [button1 addTarget:self action:@selector(btn1click:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(btn2click:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(btn3click:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(btn4click:) forControlEvents:UIControlEventTouchUpInside];
    [button5 addTarget:self action:@selector(btn5click:) forControlEvents:UIControlEventTouchUpInside];

    
    [tabbarView addSubview:button1];
    [tabbarView addSubview:button2];
    [tabbarView addSubview:button3];
    [tabbarView addSubview:button4];
    [tabbarView addSubview:button5];
    [button1 addSubview:image1];
    [button2 addSubview:image2];
    [button3 addSubview:image3];
    [button4 addSubview:image4];
    [button5 addSubview:image5];
    [button1 addSubview:label1];
    [button2 addSubview:label2];
    [button3 addSubview:label3];
    [button4 addSubview:label4];
    [button5 addSubview:label5];

}
-(void)initFourButton{
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHTIGHT-49, SCREENWIDTH, 49)];
    [tabbarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tabbarView];
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-10, 8, 20, 20)];
    [image1 setImage:[UIImage imageNamed:@"footer_nav1_1"]];
    image2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-10, 8, 20, 20)];
    [image2 setImage:[UIImage imageNamed:@"footer_nav2"]];
    image4 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-10, 8, 20, 20)];
    [image4 setImage:[UIImage imageNamed:@"footer_nav4"]];
    image5 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-10, 8, 20, 20)];
    [image5 setImage:[UIImage imageNamed:@"footer_nav5"]];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, SCREENWIDTH/4, 49);
    button2.frame = CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 49);
    button4.frame = CGRectMake(SCREENWIDTH/4*2, 0, SCREENWIDTH/4, 49);
    button5.frame = CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 49);
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-15, 34, 30, 12)];
    label1.text = @"首页";
    label1.font = [UIFont boldSystemFontOfSize:10];
    label1.textColor = RGBCOLORA(155, 155, 155, 1);
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-30, 34, 60, 12)];
    label2.text = @"闪送小超";
    label2.font = [UIFont boldSystemFontOfSize:10];
    label2.textColor = RGBCOLORA(155, 155, 155, 1);
    label4 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-25, 34, 50, 12)];
    label4.text = @"购物车";
    label4.font = [UIFont boldSystemFontOfSize:10];
    label4.textColor = RGBCOLORA(155, 155, 155, 1);
    label5 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/4/2-15, 34, 30, 12)];
    label5.text = @"我的";
    label5.font = [UIFont boldSystemFontOfSize:10];
    label5.textColor = RGBCOLORA(155, 155, 155, 1);
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    label4.textAlignment = NSTextAlignmentCenter;
    label5.textAlignment = NSTextAlignmentCenter;
    
    
    [button1 addTarget:self action:@selector(btn1click:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(btn2click:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(btn4click:) forControlEvents:UIControlEventTouchUpInside];
    [button5 addTarget:self action:@selector(btn5click:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [tabbarView addSubview:button1];
    [tabbarView addSubview:button2];
    [tabbarView addSubview:button4];
    [tabbarView addSubview:button5];
    [button1 addSubview:image1];
    [button2 addSubview:image2];
    [button4 addSubview:image4];
    [button5 addSubview:image5];
    [button1 addSubview:label1];
    [button2 addSubview:label2];
    [button4 addSubview:label4];
    [button5 addSubview:label5];
    
}

-(void)btn1click:(UIButton*)sender{
    self.selectedIndex = 0;
    [image1 setImage:[UIImage imageNamed:@"footer_nav1_1"]];
    [image2 setImage:[UIImage imageNamed:@"footer_nav2"]];
    [image3 setImage:[UIImage imageNamed:@"footer_nav3"]];
    [image4 setImage:[UIImage imageNamed:@"footer_nav4"]];
    [image5 setImage:[UIImage imageNamed:@"footer_nav5"]];
    [self toMakeAnApp:image1];
}
-(void)btn2click:(UIButton*)sender{
    self.selectedIndex = 1;
    [image1 setImage:[UIImage imageNamed:@"footer_nav1"]];
    [image2 setImage:[UIImage imageNamed:@"footer_nav2_1"]];
    [image3 setImage:[UIImage imageNamed:@"footer_nav3"]];
    [image4 setImage:[UIImage imageNamed:@"footer_nav4"]];
    [image5 setImage:[UIImage imageNamed:@"footer_nav5"]];
    [self toMakeAnApp:image2];
}
-(void)btn3click:(UIButton*)sender{
    self.selectedIndex = 2;
    [image1 setImage:[UIImage imageNamed:@"footer_nav1"]];
    [image2 setImage:[UIImage imageNamed:@"footer_nav2"]];
    [image3 setImage:[UIImage imageNamed:@"footer_nav3_1"]];
    [image4 setImage:[UIImage imageNamed:@"footer_nav4"]];
    [image5 setImage:[UIImage imageNamed:@"footer_nav5"]];
    [self toMakeAnApp:image3];
}
-(void)btn4click:(UIButton*)sender{
    if ([[USERDEFAULTS objectForKey:@"isRegister"] integerValue]) {
        self.selectedIndex = 3;
        [image1 setImage:[UIImage imageNamed:@"footer_nav1"]];
        [image2 setImage:[UIImage imageNamed:@"footer_nav2"]];
        [image3 setImage:[UIImage imageNamed:@"footer_nav3"]];
        [image4 setImage:[UIImage imageNamed:@"footer_nav4_1"]];
        [image5 setImage:[UIImage imageNamed:@"footer_nav5"]];
        [self toMakeAnApp:image4];
    }else{
        VerifyTheMobilePhoneViewController *VerifyTheMobilePhoneVC = [[VerifyTheMobilePhoneViewController alloc] initWithNibName:@"VerifyTheMobilePhoneViewController"   bundle:nil];
        [self.navigationController pushViewController:VerifyTheMobilePhoneVC animated:YES];
    }
}
-(void)btn5click:(UIButton*)sender{
    if ([[USERDEFAULTS objectForKey:@"isRegister"] integerValue]) {
        self.selectedIndex = 4;
        [image1 setImage:[UIImage imageNamed:@"footer_nav1"]];
        [image2 setImage:[UIImage imageNamed:@"footer_nav2"]];
        [image3 setImage:[UIImage imageNamed:@"footer_nav3"]];
        [image4 setImage:[UIImage imageNamed:@"footer_nav4"]];
        [image5 setImage:[UIImage imageNamed:@"footer_nav5_1"]];
        [self toMakeAnApp:image5];
    }else{
        VerifyTheMobilePhoneViewController *VerifyTheMobilePhoneVC = [[VerifyTheMobilePhoneViewController alloc] initWithNibName:@"VerifyTheMobilePhoneViewController"   bundle:nil];
        [self.navigationController pushViewController:VerifyTheMobilePhoneVC animated:YES];
    }

}
- (void)toMakeAnApp:(UIImageView *)view {
    /* 放大缩小 */
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.05; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.8]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        animation.duration = 0.08; // 动画持续时间
        animation.fromValue = [NSNumber numberWithFloat:1]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:1.3]; // 结束时的倍率
        
        // 添加动画
        [view.layer addAnimation:animation forKey:@"scale-layer"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.16 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            animation.duration = 0.04; // 动画持续时间
            animation.fromValue = [NSNumber numberWithFloat:1]; // 开始时的倍率
            animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
            // 添加动画
            [view.layer addAnimation:animation forKey:@"scale-layer"];
        });
    });
    
    
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
