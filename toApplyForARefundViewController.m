//
//  toApplyForARefundViewController.m
//  feichacha
//
//  Created by wt on 16/7/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "toApplyForARefundViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CityPicker.h"

@interface toApplyForARefundViewController ()<UITextViewDelegate,CityPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView *backView;
    UIImage *savedImage;
    NSString *RefundType;

}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureViewImage;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet UILabel *perLabel;

@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnOfTheGoodsButton;
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@property (weak, nonatomic) IBOutlet UILabel *numberAndPrice;


@end

@implementation toApplyForARefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = RGBCOLORA(188, 188, 188, 1).CGColor;
    _subButton.layer.cornerRadius = 4;
    _subButton.layer.masksToBounds = YES;
    [_pictureViewImage setImage:[AppUtils imageWithSize:_pictureView.frame.size borderColor:RGBCOLORA(188, 188, 188, 1) borderWidth:1]];

    NSArray *temparray = [_getDatas objectForKey:@"OrderList"];
    _numberAndPrice.text = [NSString stringWithFormat:@"共计%lu件商品 ￥%@",(unsigned long)temparray.count,[_getDatas objectForKey:@"Money"]];
    
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",_getDatas);
}
//隐藏默认字
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length <= 0) {
        _perLabel.hidden = NO;
    }else{
        _perLabel.hidden = YES;
    }
    //字数限制
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
}
- (IBAction)pickerClick:(id)sender {
    CityPicker *picker = [[[NSBundle mainBundle]loadNibNamed:@"CityPickerView" owner:self options:nil] objectAtIndex:0];
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:@"送货太慢 不想要了",@"产品包装 破损或损坏",@"商品变质 快过或已过保质期",@"假冒伪劣 非正品",@"实物与描述不相符",@"其它", nil];
    picker.cityArray = tempArray;
    [picker setCenter:CGPointMake( self.view.bounds.size.width/2.0,  self.view.bounds.size.height-130)];
    picker.delegate = self;
    //动画
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [picker setAlpha:1.0f];
    [picker.layer addAnimation:animation forKey:@"pushIn"];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    [self.navigationController.view addSubview:backView];
    [self.navigationController.view addSubview:picker];

}
//cityPicker代理
-(void)sendCity:(NSString *)city{
    if (![city isEqualToString:@""]) {
        [_pickerButton setTitle:city forState:UIControlStateNormal];
    }
    
    [backView removeFromSuperview];
}
#pragma mark 退款
- (IBAction)refund:(id)sender {
    RefundType = @"1";
    [_refundButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
    [_ReturnOfTheGoodsButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}
#pragma mark 退货
- (IBAction)ReturnOfTheGoods:(id)sender {
    RefundType = @"2";
    [_refundButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [_ReturnOfTheGoodsButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
}
#pragma mark 图片选择1
- (IBAction)picClick1:(id)sender {
    UIActionSheet *actionsheet =[[UIActionSheet alloc]initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:self.view];
}
#pragma mark 图片选择2
- (IBAction)picClick2:(id)sender {
}
#pragma mark 图片选择3
- (IBAction)picClick3:(id)sender {
}

#pragma mark 提交申请
- (IBAction)subButtonClick:(id)sender {
    if (!RefundType) {
        [SVProgressHUD showInfoWithStatus:@"请选择退款类型"];
    }else if([_pickerButton.titleLabel.text isEqualToString:@"请选择退款原因"]){
        [SVProgressHUD showInfoWithStatus:@"请选择退款原因"];
    }else{
    [SVProgressHUD showWithStatus:@"加载中..."];
        
    NSString *tempArray = [[NSString alloc]init];
    
    [[NetworkUtils shareNetworkUtils] ApplyOrder:[_getDatas objectForKey:@"OrderId"] RefundType:RefundType RefundReason:_pickerButton.titleLabel.text RefundRemark:_textView.text Images:tempArray success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            [SVProgressHUD showInfoWithStatus:@"退款申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
//            Timelist = [responseObject objectForKey:@"AppendData"];
//            [_tableView reloadData];
        }else {
//            Timelist = nil;
//            [_tableView reloadData];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceTape = 0;
    if (buttonIndex == 0) {
        NSLog(@"拍照");
        sourceTape = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1) {
        NSLog(@"相册");
        sourceTape = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(buttonIndex == 2) {
        NSLog(@"取消");
        return;
    }
    //点击后打开相机或相册
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceTape;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
//点击相册中的图片或照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    
    [[SDImageCache sharedImageCache]clearDisk];
    [[SDImageCache sharedImageCache]clearMemory];
}
//保存图片
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation([AppUtils callOriginImage:currentImage scaleToSize:CGSizeMake(120, 120)], 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [userDefaults objectForKey:@"key"];
    NSMutableDictionary * pas=[[NSMutableDictionary alloc]initWithObjectsAndKeys:key,@"key",nil];
    
    [AppUtils postRequestWithURL:@"http://api.feichacha.com/api/ImgFile/ImgUpload" postParems:nil picImage:currentImage picFileName:@"fileupload.jpg"];
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
