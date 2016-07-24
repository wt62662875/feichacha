//
//  LuckyDrawViewController.m
//  feichacha
//
//  Created by wt on 16/4/24.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "LuckyDrawViewController.h"

@interface LuckyDrawViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LuckyDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://manage.feichacha.com/Lucky/Index?UserId=%@",[USERDEFAULTS objectForKey:@"UserID"]]];
    NSLog(@"%@",url);
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view.
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
//    NSString *urll = [NSString stringWithFormat:@"http://api.feichacha.com/api/ProClass/ListProClass"];
//    
//    [manager GET:urll parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
//            
//            
//        }else{
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        if (error.code==-1001) {
//            [SVProgressHUD showInfoWithStatus:@"请求超时" maskType:SVProgressHUDMaskTypeBlack];
//        }else{
//            [SVProgressHUD dismiss];
//        }
//    }];

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
