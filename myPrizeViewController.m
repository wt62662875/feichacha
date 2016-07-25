//
//  myPrizeViewController.m
//  feichacha
//
//  Created by wt on 16/7/22.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "myPrizeViewController.h"
#import "myPrizeTableViewCell.h"

@interface myPrizeViewController ()
{
    NSArray *datas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation myPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDatas];
}
-(void)getDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] UserLuckyList:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
        }else {
            datas = nil;
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datas.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myPrizeTableViewCell";
    myPrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"myPrizeTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDateFormatter *imputForMatter = [[NSDateFormatter alloc]init];
    [imputForMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tempDate = [imputForMatter dateFromString:[datas[indexPath.row] objectForKey:@"AddDates"]];
    
    NSDateFormatter *imputForMatter2 = [[NSDateFormatter alloc]init];
    [imputForMatter2 setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    cell.label2.text = [NSString stringWithFormat:@"有效期：%@-%@",[imputForMatter2 stringFromDate:[imputForMatter dateFromString:[datas[indexPath.row] objectForKey:@"AddDates"]]],[imputForMatter2 stringFromDate:[NSDate dateWithTimeInterval:24*60*60 sinceDate:[imputForMatter dateFromString:[datas[indexPath.row] objectForKey:@"AddDates"]]]]];
    
    cell.label3.text = [datas[indexPath.row] objectForKey:@"LuckyProductName"];
    
        NSTimeInterval interval = [[imputForMatter dateFromString:[imputForMatter stringFromDate:[NSDate date]]] timeIntervalSinceDate:tempDate];
    
    if (interval/60/60/24 > 1.0) {
//        NSLog(@"1");
        cell.bigNumber.hidden = YES;
        cell.roundView.backgroundColor = RGBCOLORA(214, 214, 214, 1);
    }else{
        cell.smallNumber.hidden = YES;
        cell.canUse.hidden = YES;
        cell.overdue.hidden = YES;
        cell.roundView.backgroundColor = RGBCOLORA(250, 224, 74, 1);

    }
    return cell;
}
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
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
