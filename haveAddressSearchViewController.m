//
//  haveAddressSearchViewController.m
//  feichacha
//
//  Created by wt on 16/6/20.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "haveAddressSearchViewController.h"
#import "haveAddressSerchTableViewCell.h"
#import "noAddressSerchTableViewCell.h"
#import "editOrAddAddressViewController.h"
#import "addressManageViewController.h"

@interface haveAddressSearchViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    __weak IBOutlet BMKMapView *_mapView;
    BMKGeoCodeSearch * _searcher;
    BMKPoiSearch *_poisearch;

    BOOL firstLoad;
    
    NSMutableArray *datasList;
}
@property (weak, nonatomic) IBOutlet UIView *serchView;
@property (weak, nonatomic) IBOutlet UITextField *serchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *fullTableView;

//@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation haveAddressSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serchView.layer.cornerRadius = 4;
    _serchView.layer.borderWidth = 1;
    _serchView.layer.borderColor = RGBCOLORA(235, 235, 235, 1).CGColor;
    // Do any additional setup after loading the view.
    _fullTableView.hidden = YES;

    BMKCoordinateRegion region ;//表示范围的结构体
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_lat floatValue];
    coordinate.longitude = [_lon floatValue];
    region.center = coordinate;//中心点
    region.span.latitudeDelta = 0.001;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.001;//纬度范围
    [_mapView setRegion:region animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //        发起反向地理编码检索
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    CLLocationCoordinate2D pt;
    if (firstLoad) {
        pt = (CLLocationCoordinate2D){mapView.region.center.latitude,mapView.region.center.longitude};
    }else{
        pt.latitude = [_lat floatValue];
        pt.longitude = [_lon floatValue];
    }
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        //          NSLog(@"反geo检索发送成功");
    }else
    {
//        NSLog(@"反geo检索发送失败");
    }

    firstLoad = YES;

}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        datasList = [[NSMutableArray alloc]init];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
            [tempDic setObject:poiInfo.name forKey:@"name"];
            [tempDic setObject:poiInfo.address forKey:@"address"];
            [tempDic setObject:[NSString stringWithFormat:@"%f",poiInfo.pt.latitude] forKey:@"latitude"];
            [tempDic setObject:[NSString stringWithFormat:@"%f",poiInfo.pt.longitude] forKey:@"longitude"];
            [datasList addObject:tempDic];
        }
        [_tableView reloadData];
        if (datasList.count>0) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }

    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (IBAction)changed:(id)sender {
    _fullTableView.hidden = NO;
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
        
        datasList = [[NSMutableArray alloc]init];
        for(BMKPoiInfo *poiInfo in poiResult.poiInfoList)
        {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
            [tempDic setObject:poiInfo.name forKey:@"name"];
            [tempDic setObject:poiInfo.address forKey:@"address"];
            [tempDic setObject:[NSString stringWithFormat:@"%f",poiInfo.pt.latitude] forKey:@"latitude"];
            [tempDic setObject:[NSString stringWithFormat:@"%f",poiInfo.pt.longitude] forKey:@"longitude"];
            [datasList addObject:tempDic];
        }
        [_fullTableView reloadData];
    }
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datasList.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView && indexPath.row == 0) {
        static NSString *cellIdentifier = @"haveAddressSerchTableViewCell";
        haveAddressSerchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"haveAddressSerchTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.name.text = [datasList[indexPath.row] objectForKey:@"name"];
        cell.address.text = [datasList[indexPath.row] objectForKey:@"address"];
        return cell;
    }else{
        static NSString *cellIdentifier = @"noAddressSerchTableViewCell";
        noAddressSerchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"noAddressSerchTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.name.text = [datasList[indexPath.row] objectForKey:@"name"];
        cell.address.text = [datasList[indexPath.row] objectForKey:@"address"];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_whereGo isEqualToString:@"3"]) {
        addressManageViewController *addressManageVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        [addressManageVC setSendDatas:datasList[indexPath.row]];
        [self.navigationController popToViewController:addressManageVC animated:YES];

    }else{
    editOrAddAddressViewController *editOrAddAddressVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    [editOrAddAddressVC setSendDatas:datasList[indexPath.row]];
    [self.navigationController popToViewController:editOrAddAddressVC animated:YES];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
    _poisearch.delegate = nil;
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
