//
//  addressManageViewController.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "addressManageViewController.h"
#import "addressManageTableViewCell.h"
#import "editOrAddAddressViewController.h"
#import "addressManageToShopTableViewCell.h"
#import "baseViewController.h"

@interface addressManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL selectBool;                    //0送货上门   1门店自提
    NSString *editAddBool;              //1新增   0修改
    NSArray *deliveryDatas;             //送货上门列表
    NSString *sendAddressID;            //修改的地址ID
}
@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *DoorToDoor;
@property (weak, nonatomic) IBOutlet UIButton *ToTheShop;
@property (weak, nonatomic) IBOutlet UIView *positioningView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *positioningViewHeigh;

@end

@implementation addressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addAddressButton.layer.cornerRadius = 4;
    _titleView.layer.cornerRadius = 4;
    _titleView.layer.masksToBounds = YES;
    _titleView.layer.borderWidth = 1;
    _titleView.layer.borderColor = RGBCOLORA(255, 214, 0, 1).CGColor;
    if ([_whereToHere isEqualToString:@"perasonalCenter"]) {
        [_titleView removeFromSuperview];
        _positioningViewHeigh.constant = 0;
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self getDeliveryDatas];
}
-(void)getDeliveryDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] userAddressList:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            deliveryDatas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];

}
#pragma mark 有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (selectBool) {
        return 2;
    }else {
        return 1;
    }
}
#pragma mark 头有多高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (selectBool) {
        return 34;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 34)];
    [view setBackgroundColor:RGBCOLORA(237, 237, 237, 1)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 120, 18)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = RGBCOLORA(147, 147, 147, 1);
    if (section == 0) {
        label.text = @"附近的自提点";
    }else{
        label.text = @"历史自提点";
    }
    [view addSubview:label];
    return view;
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (selectBool) {
        if (section == 0) {
            return 5;
        }else{
            return 3;
        }
    }else{
        return deliveryDatas.count;
    }
    
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectBool) {
        return 73;
    }else{
        return 61;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectBool) {
        static NSString *cellIdentifier = @"addressManageToShopTableViewCell";
        addressManageToShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"addressManageToShopTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;

    }else{
        static NSString *cellIdentifier = @"addressManageTableViewCell";
        addressManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"addressManageTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.editButton.tag = indexPath.row;
        [cell.editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.name.text = [deliveryDatas[indexPath.row] objectForKey:@"Name"];
        cell.phoneNumber.text = [deliveryDatas[indexPath.row] objectForKey:@"Mobile"];
        cell.address.text = [NSString stringWithFormat:@"%@%@%@",[deliveryDatas[indexPath.row] objectForKey:@"CityName"],[deliveryDatas[indexPath.row] objectForKey:@"Address"],[deliveryDatas[indexPath.row] objectForKey:@"AddressDetail"]];

        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectBool) {
    }else{
        [USERDEFAULTS setObject:[deliveryDatas[indexPath.row] objectForKey:@"Address"] forKey:@"CurrentAddress"];
        [USERDEFAULTS setObject:[NSString stringWithFormat:@"%f",[[deliveryDatas[indexPath.row] objectForKey:@"Coordinate_x"] floatValue]] forKey:@"CurrentLatitude"];
        [USERDEFAULTS setObject:[NSString stringWithFormat:@"%f",[[deliveryDatas[indexPath.row] objectForKey:@"Coordinate_y"] floatValue]] forKey:@"CurrentLongitude"];
        [self.delegate positioningBackView:@"1"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 修改地址
-(void)editButton:(UIButton *)sender{
    editAddBool = @"0";
    
    sendAddressID = [deliveryDatas[sender.tag] objectForKey:@"Id"];
    [self performSegueWithIdentifier:@"addressManageToEditOrAddAddress" sender:self];
}
#pragma mark 新增地址
- (IBAction)addAddressClick:(id)sender {
    editAddBool = @"1";
    
    [self performSegueWithIdentifier:@"addressManageToEditOrAddAddress" sender:self];
}

#pragma mark 送货上门
- (IBAction)DoorToDoor:(id)sender {
    _DoorToDoor.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _ToTheShop.backgroundColor = [UIColor whiteColor];
    [_DoorToDoor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_ToTheShop setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];
    selectBool = NO;
    [_tableView reloadData];
}
#pragma mark 到店自提
- (IBAction)ToTheShop:(id)sender {
    _ToTheShop.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _DoorToDoor.backgroundColor = [UIColor whiteColor];
    [_ToTheShop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_DoorToDoor setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];
    selectBool = YES;
    [_tableView reloadData];
}
#pragma mark 定位倒当前位置
- (IBAction)positioning:(id)sender {
    [self.delegate positioningBackView:@"0"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addressManageToEditOrAddAddress"]) {
        editOrAddAddressViewController *editAddAddressVC = segue.destinationViewController;
        [editAddAddressVC setEditOrAddBool:editAddBool];
        [editAddAddressVC setAddressID:sendAddressID];
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
