//
//  goodsDetailsViewController.m
//  feichacha
//
//  Created by wt on 16/5/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "goodsDetailsViewController.h"
#import "goodsDetailsTableViewCell.h"

@interface goodsDetailsViewController ()<UIActionSheetDelegate,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation goodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_test);


    // Do any additional setup after loading the view.
    [self initHeadView];
    [self initFootView];
    
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 320;
    
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
    /**
     老价格加下划线
     **/
    NSString *oldPrice = @"¥17.8";
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
    [cell.goodsOldPrice setAttributedText:attri];

    
    return cell;
}

-(void)initHeadView{
    SDCycleScrollView * headView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*1.035)];
    headView.delegate = self;
    headView.imageURLStringsGroup = [[NSArray alloc]initWithObjects:@"http://manage.feichacha.com/html/shop/images/comm_img1.jpg",@"http://manage.feichacha.com/html/shop/images/comm_img1.jpg",@"http://manage.feichacha.com/html/shop/images/comm_img1.jpg", nil];
    headView.placeholderImage = [UIImage imageNamed:@"bg.png"];
    headView.autoScrollTimeInterval = 3.0;
    headView.currentPageDotColor = RGBCOLORA(225, 214, 0, 1);
    _tableView.tableHeaderView = headView;
}
-(void)initFootView{
    CGSize size =  [AppUtils getImageSizeWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/comm_img2.png"]];
    CGSize size2 =  [AppUtils getImageSizeWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/comm_img3.png"]];
    float height1 = (size.height/size.width)*SCREENWIDTH;
    float height2 = (size2.height/size2.width)*SCREENWIDTH;

    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, height1+height2)];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, height1)];
    [image sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/comm_img2.png"]];
    [footView addSubview:image];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0 , height1, SCREENWIDTH, height2)];
    [image2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/comm_img3.png"]];
    [footView addSubview:image2];
    
    _tableView.tableFooterView = footView;
                                                               
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
