//
//  feedbackViewController.m
//  feichacha
//
//  Created by wt on 16/4/25.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *goodsSpeciesButton;              //商品种类
@property (weak, nonatomic) IBOutlet UIButton *goodsQualityButton;              //商品品质
@property (weak, nonatomic) IBOutlet UIButton *goodsButton;                     //商品
@property (weak, nonatomic) IBOutlet UIButton *SalesPromotionActivityButton;    //促销活动
@property (weak, nonatomic) IBOutlet UIButton *shippingServiceButton;           //配送服务
@property (weak, nonatomic) IBOutlet UIButton *otherButton;                     //其他
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth2;
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonWidth1.constant = SCREENWIDTH/3-12;
    _buttonWidth2.constant = SCREENWIDTH/3-12;
    _submitButton.layer.cornerRadius = 4;
    _submitButton.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = RGBCOLORA(188, 188, 188, 1).CGColor;
    [self initButtonLayer];
    // Do any additional setup after loading the view.
}
//隐藏默认字
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length <= 0) {
        _defaultLabel.hidden = NO;
    }else{
        _defaultLabel.hidden = YES;
    }
    //字数限制
    if (textView.text.length > 300) {
        textView.text = [textView.text substringToIndex:300];
    }
}

//点击空白隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}
#pragma mark 商品种类点击
- (IBAction)goodsSpeciesButtonClick:(id)sender {
    [self initButtonLayer];
    [sender setBackgroundColor:RGBCOLORA(249, 216, 72, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _goodsSpeciesButton.layer.borderWidth = 0;
}
#pragma mark 商品品质点击
- (IBAction)goodsQualityButton:(id)sender {
    [self initButtonLayer];
    [sender setBackgroundColor:RGBCOLORA(249, 216, 72, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _goodsQualityButton.layer.borderWidth = 0;
}
#pragma mark 商品点击
- (IBAction)goodsButtonClick:(id)sender {
    [self initButtonLayer];
    [sender setBackgroundColor:RGBCOLORA(249, 216, 72, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _goodsButton.layer.borderWidth = 0;
}
#pragma mark 促销活动点击
- (IBAction)SalesPromotionActivityButtonClick:(id)sender {
    [self initButtonLayer];
    [sender setBackgroundColor:RGBCOLORA(249, 216, 72, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _SalesPromotionActivityButton.layer.borderWidth = 0;
}
#pragma mark 配送服务点击
- (IBAction)shippingServiceButtonClick:(id)sender {
    [self initButtonLayer];
    [sender setBackgroundColor:RGBCOLORA(249, 216, 72, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shippingServiceButton.layer.borderWidth = 0;
}
#pragma mark 其他点击
- (IBAction)otherButtonClick:(id)sender {
    [self initButtonLayer];
    [sender setBackgroundColor:RGBCOLORA(249, 216, 72, 1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _otherButton.layer.borderWidth = 0;
}
-(void)initButtonLayer{
    _goodsSpeciesButton.layer.cornerRadius = 13.5;
    _goodsSpeciesButton.layer.borderWidth = 1;
    _goodsSpeciesButton.layer.borderColor = RGBCOLORA(160, 160, 160, 1).CGColor;
    [_goodsSpeciesButton setBackgroundColor:[UIColor whiteColor]];
    [_goodsSpeciesButton setTitleColor:RGBCOLORA(160, 160, 160, 1) forState:UIControlStateNormal];
    
    _goodsQualityButton.layer.cornerRadius = 13.5;
    _goodsQualityButton.layer.borderWidth = 1;
    _goodsQualityButton.layer.borderColor = RGBCOLORA(160, 160, 160, 1).CGColor;
    [_goodsQualityButton setBackgroundColor:[UIColor whiteColor]];
    [_goodsQualityButton setTitleColor:RGBCOLORA(160, 160, 160, 1) forState:UIControlStateNormal];

    _goodsButton.layer.cornerRadius = 13.5;
    _goodsButton.layer.borderWidth = 1;
    _goodsButton.layer.borderColor = RGBCOLORA(160, 160, 160, 1).CGColor;
    [_goodsButton setBackgroundColor:[UIColor whiteColor]];
    [_goodsButton setTitleColor:RGBCOLORA(160, 160, 160, 1) forState:UIControlStateNormal];

    _SalesPromotionActivityButton.layer.cornerRadius = 13.5;
    _SalesPromotionActivityButton.layer.borderWidth = 1;
    _SalesPromotionActivityButton.layer.borderColor = RGBCOLORA(160, 160, 160, 1).CGColor;
    [_SalesPromotionActivityButton setBackgroundColor:[UIColor whiteColor]];
    [_SalesPromotionActivityButton setTitleColor:RGBCOLORA(160, 160, 160, 1) forState:UIControlStateNormal];

    _shippingServiceButton.layer.cornerRadius = 13.5;
    _shippingServiceButton.layer.borderWidth = 1;
    _shippingServiceButton.layer.borderColor = RGBCOLORA(160, 160, 160, 1).CGColor;
    [_shippingServiceButton setBackgroundColor:[UIColor whiteColor]];
    [_shippingServiceButton setTitleColor:RGBCOLORA(160, 160, 160, 1) forState:UIControlStateNormal];

    _otherButton.layer.cornerRadius = 13.5;
    _otherButton.layer.borderWidth = 1;
    _otherButton.layer.borderColor = RGBCOLORA(160, 160, 160, 1).CGColor;
    [_otherButton setBackgroundColor:[UIColor whiteColor]];
    [_otherButton setTitleColor:RGBCOLORA(160, 160, 160, 1) forState:UIControlStateNormal];

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
