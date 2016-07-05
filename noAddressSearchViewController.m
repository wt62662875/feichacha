//
//  noAddressSearchViewController.m
//  feichacha
//
//  Created by wt on 16/6/15.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "noAddressSearchViewController.h"
#import "noAddressSerchTableViewCell.h"
#import "editOrAddAddressViewController.h"

@interface noAddressSearchViewController ()<BMKPoiSearchDelegate>
{
    BMKPoiSearch *_poisearch;
    NSMutableArray *datas;
}
@property (weak, nonatomic) IBOutlet UIView *serchView;
@property (weak, nonatomic) IBOutlet UITextField *serchTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation noAddressSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serchView.layer.cornerRadius = 4;
    _serchView.layer.borderWidth = 1;
    _serchView.layer.borderColor = RGBCOLORA(235, 235, 235, 1).CGColor;

    [self.serchTextField becomeFirstResponder];
    // Do any additional setup after loading the view.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)changed:(id)sender {
    //初始化检索对象
    _poisearch =[[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    BMKCitySearchOption* option = [[BMKCitySearchOption alloc] init];
    option.city = _city;
    option.keyword = _serchTextField.text;
    option.pageCapacity = 20;
    BOOL flag = [_poisearch poiSearchInCity:option];

    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }
}
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {

        datas = [[NSMutableArray alloc]init];
        for (int i = 0 ; i <poiResult.poiInfoList.count; i++) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
            BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc]init];
            poiInfo = poiResult.poiInfoList[i];
            [tempDic setObject:poiInfo.name forKey:@"name"];
            [tempDic setObject:poiInfo.address forKey:@"address"];
            [tempDic setObject:[NSString stringWithFormat:@"%f",poiInfo.pt.latitude] forKey:@"latitude"];
            [tempDic setObject:[NSString stringWithFormat:@"%f",poiInfo.pt.longitude] forKey:@"longitude"];
            [datas insertObject:tempDic atIndex:i];
        }
        [_tableView reloadData];
    }
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    _poisearch.delegate = nil;
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datas.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"noAddressSerchTableViewCell";
    noAddressSerchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"noAddressSerchTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.name.text = [datas[indexPath.row] objectForKey:@"name"];
    cell.address.text = [datas[indexPath.row] objectForKey:@"address"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    editOrAddAddressViewController *editOrAddAddressVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    [editOrAddAddressVC setSendDatas:datas[indexPath.row]];
    [self.navigationController popToViewController:editOrAddAddressVC animated:YES];
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
