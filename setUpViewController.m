//
//  setUpViewController.m
//  feichacha
//
//  Created by wt on 16/4/25.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "setUpViewController.h"

@interface setUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheNumber;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@end

@implementation setUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _exitButton.layer.cornerRadius = 5;
    _exitButton.layer.masksToBounds = YES;
    
    _cacheNumber.text = [NSString stringWithFormat:@"%.2fM",[self filePath]];

    // Do any additional setup after loading the view.
}
- (IBAction)exitButton:(id)sender {
    [USERDEFAULTS setObject:nil forKey:@"isRegister"];
    [USERDEFAULTS setObject:nil forKey:@"UserID"];
    [USERDEFAULTS setObject:nil forKey:@"telPhoneNumber"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToBaseView" object:nil];
}
- (IBAction)clearCache:(id)sender {
    //alert view
    [UIAlertView showWithTitle:@"确定要清除缓存吗？" message:@"" style:UIAlertViewStyleDefault cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            _cacheNumber.text = [NSString stringWithFormat:@"0.00M"];
            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
        }
    }];
}
- ( float )filePath{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
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
