//
//  goodsDetailsViewController.m
//  feichacha
//
//  Created by wt on 16/5/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "goodsDetailsViewController.h"
#import "goodsDetailsTableViewCell.h"

@interface goodsDetailsViewController ()<UIActionSheetDelegate,SDCycleScrollViewDelegate,UIWebViewDelegate>
{
    id datas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation goodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDatas];

    // Do any additional setup after loading the view.s

}
-(void)getDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSLog(@"%@",_getID);
    [[NetworkUtils shareNetworkUtils] ProDetail:[_getID objectForKey:@"Fguid"] ActType:[_getID objectForKey:@"Library"] IsAct:@"0" success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [responseObject objectForKey:@"AppendData"];
            _titleLabel.text = [datas objectForKey:@"Name"];
            
            [self initHeadView];
            [self initFootView];
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
    return 1;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 340;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"goodsDetailsTableViewCell";
    goodsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"goodsDetailsTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    /**
//     老价格加下划线
//     **/
//    NSString *oldPrice = @"¥17.8";
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
//    [cell.goodsOldPrice setAttributedText:attri];
    cell.goodsOldPrice.hidden = YES;

    cell.goodsName.text = [datas objectForKey:@"Name"];
    cell.goodsPrice.text = [NSString stringWithFormat:@"￥%@",[datas objectForKey:@"Price"]];
    cell.goodsBrand.text = [datas objectForKey:@"BrandId"];
    cell.goodsSpecifications.text = [datas objectForKey:@"Size"];
    cell.shelfLife.text = [NSString stringWithFormat:@"%d个月",[[datas objectForKey:@"Days"] intValue]/30];
    
    return cell;
}

-(void)initHeadView{
    SDCycleScrollView * headView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*1.035)];
    headView.delegate = self;
    NSMutableArray * imageURL = [[NSMutableArray alloc]init];
    NSArray *tempArray = [[NSArray alloc]initWithArray:[datas objectForKey:@"Images"]];
    for (int i = 0; i < tempArray.count; i++) {
        [imageURL addObject:[NSString stringWithFormat:@"%@%@",IMGURL,[tempArray[i] objectForKey:@"ImageUrl"]]];
    }
    NSLog(@"%@",imageURL);
    headView.imageURLStringsGroup = imageURL;
    headView.placeholderImage = [UIImage imageNamed:@"bg.png"];
    headView.autoScrollTimeInterval = 3.0;
    headView.currentPageDotColor = RGBCOLORA(225, 214, 0, 1);
    _tableView.tableHeaderView = headView;
}
-(void)initFootView{
    UIWebView *footView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://manage.feichacha.com/Products/Detail?FguId=%@&Type=%@",[_getID objectForKey:@"Fguid"],[_getID objectForKey:@"Library"]]]];
    footView.delegate = self;
    
    
    _tableView.tableFooterView = footView;
    [footView loadRequest:request];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    _tableView.tableFooterView = webView;
}

#pragma mark 分享
- (IBAction)shareButton:(id)sender {
    UIActionSheet *actionsheet =[[UIActionSheet alloc]initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ空间", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"微信好友");
    }else if (buttonIndex == 1){
        NSLog(@"微信朋友圈");
    }else if (buttonIndex == 2){
        NSLog(@"新浪微博");
    }else if (buttonIndex == 3){
        NSLog(@"QQ空间");
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
