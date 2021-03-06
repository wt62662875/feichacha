//
//  flashSmallSuperViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "flashSmallSuperViewController.h"
#import "leftClassNameTableViewCell.h"
#import "headTitleTableViewCell.h"
#import "footTitleTableViewCell.h"
#import "flashGoodsTableViewCell.h"
#import "baseViewController.h"
#import "goodsDetailsViewController.h"

@interface flashSmallSuperViewController ()<UITableViewDataSource,UITableViewDelegate,positioningDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    int page;
    NSString *defaultRightStr;
    
    NSInteger selectCellTag;                //选中cell
    
    NSArray *leftDatas;
    NSMutableArray *rightDatas;

    BMKLocationService *_locService;
    BMKGeoCodeSearch * _searcher;
}
@property (weak, nonatomic) IBOutlet UILabel *deliveryTo;   //配送至

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property(nonatomic,strong)NSMutableArray<CALayer *> *animationLayers;

@property (weak, nonatomic) IBOutlet UIButton *titleAddress;
@property (weak, nonatomic) IBOutlet UIButton *changeAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleAddressWidth;         //地址宽度

@end

@implementation flashSmallSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _changeAddress.layer.borderColor = RGBCOLORA(115, 113, 114, 1).CGColor;
    _changeAddress.layer.borderWidth = 1;
    _changeAddress.layer.cornerRadius = 4;
    _deliveryTo.layer.borderColor = [UIColor blackColor].CGColor;
    _deliveryTo.layer.borderWidth = 0.5;
    
    if ([USERDEFAULTS objectForKey:@"shopID"]) {
        _leftTableView.hidden = NO;
        _rightTableView.hidden = NO;
//        [self getStores:[USERDEFAULTS objectForKey:@"CurrentLongitude"] lon:[USERDEFAULTS objectForKey:@"CurrentLatitude"]];
    }else{
        _leftTableView.hidden = YES;
        _rightTableView.hidden = YES;
    }
    
//    [self tableView:_leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];

}
-(void)viewWillAppear:(BOOL)animated{
    if (![_titleAddress.titleLabel.text isEqualToString:[USERDEFAULTS objectForKey:@"CurrentAddress"]]) {
        [self getStores:[USERDEFAULTS objectForKey:@"CurrentLatitude"] lon:[USERDEFAULTS objectForKey:@"CurrentLongitude"]];
        [_titleAddress setTitle:[USERDEFAULTS objectForKey:@"CurrentAddress"] forState:UIControlStateNormal];
        [self initAddressTitleWidth:[USERDEFAULTS objectForKey:@"CurrentAddress"]];
    }
    
    if (leftDatas && [USERDEFAULTS objectForKey:@"ChooseClass"]) {
        for (int i = 0; i<leftDatas.count; i++) {
            if ([[leftDatas[i]objectForKey:@"Name"] isEqualToString:[USERDEFAULTS objectForKey:@"ChooseClass"]]) {
                [self tableView:_leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
    }
    
    if ([[USERDEFAULTS objectForKey:@"DeliveryType"] intValue] == 2) {
        _deliveryTo.text = @"自提点";
    }else{
        _deliveryTo.text = @"配送至";
    }
    [_rightTableView reloadData];
    
}
//获取当前地址
-(void)getCurrentAddress{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation) {
        //        发起反向地理编码检索
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                                BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            //          NSLog(@"反geo检索发送成功");
            NSString *latString = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
            NSString *lonString = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
            [USERDEFAULTS setObject:lonString forKey:@"CurrentLongitude"];
            [USERDEFAULTS setObject:latString forKey:@"CurrentLatitude"];
            [self getStores:latString lon:lonString];
            _locService.delegate = nil;
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
}
#pragma mark 根据坐标获取门店
-(void)getStores:(NSString *)lat lon:(NSString *)lon{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[NetworkUtils shareNetworkUtils] companyDetail:lat lon:lon Type:@"0" success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            [USERDEFAULTS setObject:[[responseObject objectForKey:@"AppendData"] objectForKey:@"Id"] forKey:@"shopID"];
            _leftTableView.hidden = NO;
            _rightTableView.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFlashSmallSupper" object:nil];

            [self getleftDatas];
        }else {
            _leftTableView.hidden = YES;
            _rightTableView.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initFourButton" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFlashSmallSupper" object:nil];

            [USERDEFAULTS setObject:nil forKey:@"shopID"];
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray * tempArray = [[NSMutableArray alloc]init];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            [tempArray addObject:poiInfo.name];
        }
        [_titleAddress setTitle:tempArray[0] forState:UIControlStateNormal];
        [self initAddressTitleWidth:tempArray[0]];
        [USERDEFAULTS setObject:tempArray[0] forKey:@"CurrentAddress"];
        [self initAddressTitleWidth:tempArray[0]];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark 地址管理定位当前位置返回重新获取坐标
-(void)positioningBackView:(NSString *)sender{
    if ([sender isEqualToString:@"0"]) {
        [self getCurrentAddress];
    }else if([sender isEqualToString:@"1"]){
        [_titleAddress setTitle:[USERDEFAULTS objectForKey:@"CurrentAddress"] forState:UIControlStateNormal];
        [self getStores:[USERDEFAULTS objectForKey:@"CurrentLatitude"] lon:[USERDEFAULTS objectForKey:@"CurrentLongitude"]];
        [self initAddressTitleWidth:[USERDEFAULTS objectForKey:@"CurrentAddress"]];
    }
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"initFiveButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"initFourButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToFlashSmallSupper" object:nil];
    [USERDEFAULTS setObject:nil forKey:@"ChooseClass"];
}
- (IBAction)loginAddress:(id)sender {
    if ([[USERDEFAULTS objectForKey:@"isRegister"] integerValue]) {
        [self performSegueWithIdentifier:@"flashSmallToAddress" sender:self];
    }else{
        VerifyTheMobilePhoneViewController *VerifyTheMobilePhoneVC = [[VerifyTheMobilePhoneViewController alloc] initWithNibName:@"VerifyTheMobilePhoneViewController"   bundle:nil];
        [self.navigationController pushViewController:VerifyTheMobilePhoneVC animated:YES];
    }
}
- (IBAction)changeAddress:(id)sender {
    [self performSegueWithIdentifier:@"flashSmallToAddress" sender:self];
}

-(void)getleftDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] listProClass:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            page = 1;
            rightDatas = [[NSMutableArray alloc]init];
            leftDatas = [[NSArray alloc]init];
            leftDatas = [responseObject objectForKey:@"AppendData"];
            [_leftTableView reloadData];
            if ([USERDEFAULTS objectForKey:@"ChooseClass"]) {
                for (int i = 0; i<leftDatas.count; i++) {
                    if ([[leftDatas[i]objectForKey:@"Name"] isEqualToString:[USERDEFAULTS objectForKey:@"ChooseClass"]]) {
                        [self tableView:_leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    }
                }
            }else{
                defaultRightStr = [leftDatas[0] objectForKey:@"StringId"];
                [self getRightDatas:[leftDatas[0] objectForKey:@"StringId"] page:1];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)getRightDatas:(NSString *)classId page:(int)pages{
    if (pages == 1) {
        [SVProgressHUD showWithStatus:@"加载中..."];
        rightDatas = [[NSMutableArray alloc]init];
    }
    [[NetworkUtils shareNetworkUtils] ClassProductList:[USERDEFAULTS objectForKey:@"shopID"] classId:classId page:[NSString stringWithFormat:@"%d",pages] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            NSMutableArray *tempArray =[responseObject objectForKey:@"AppendData"];
            for (int i = 0; i<tempArray.count; i++) {
                [rightDatas addObject:tempArray[i]];
            }

            if (pages == 1) {
                [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            [_rightTableView reloadData];
        }else {
//            rightDatas = [[NSMutableArray alloc]init];
            [_rightTableView reloadData];
//            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return leftDatas.count;
    }else{
        if (rightDatas.count >0) {
            return rightDatas.count+2;
        }else{
            return rightDatas.count+1;
        }
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 50;
    }else if (indexPath.row == 0) {
        return 22;
    }else if (indexPath.row == rightDatas.count){
        return 95;
    }else{
        return 90;
    }
    
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        static NSString *cellIdentifier = @"leftClassNameTableViewCell";
        leftClassNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"leftClassNameTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == selectCellTag) {
            [cell.name setTintColor:[UIColor blackColor]];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }else{
            [cell.name setTintColor:RGBCOLORA(166, 166, 166, 1)];
            [cell setBackgroundColor:RGBCOLORA(248, 248, 248, 1)];
        }
        cell.name.text = [leftDatas[indexPath.row] objectForKey:@"Name"];
       
        return cell;
    }else if(indexPath.row == 0){
        static NSString *cellIdentifier = @"headTitleTableViewCell";
        headTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"headTitleTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.titleName.text = [leftDatas[selectCellTag] objectForKey:@"Name"];
        
        return cell;
    }else if (indexPath.row == rightDatas.count+1){
        static NSString *cellIdentifier = @"footTitleTableViewCell";
        footTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"footTitleTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;

    }else{
        static NSString *cellIdentifier = @"flashGoodsTableViewCell";
        flashGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"flashGoodsTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.addShoppingCartButton.tag = indexPath.row;
        cell.minShoppingCartButton.tag = indexPath.row;

        if (page == 1 && indexPath.row > 15) {
            
        }else{
            cell.minShoppingCartButton.hidden = YES;
            cell.numberLbael.hidden = YES;
//            NSLog(@"%@",[USERDEFAULTS objectForKey:@"FlashShoppingCartGoods"]);
            NSArray *tempArray = [USERDEFAULTS objectForKey:@"FlashShoppingCartGoods"];
            for (int i= 0; i<tempArray.count; i++) {
                if ([[rightDatas[indexPath.row-1] objectForKey:@"Fguid"] isEqualToString:[tempArray[i] objectForKey:@"Fguid"]]) {
                    cell.minShoppingCartButton.hidden = NO;
                    cell.numberLbael.hidden = NO;
                    cell.numberLbael.text = [tempArray[i] objectForKey:@"PurchaseQuantity"];
                }
            }
           
            NSString *imageURL = [IMGURL stringByAppendingString:[rightDatas[indexPath.row-1] objectForKey:@"ImageUrl"]];
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:imageURL]];
            [cell.addShoppingCartButton addTarget:self action:@selector(addShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.minShoppingCartButton addTarget:self action:@selector(minShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
            cell.goodsName.text = [rightDatas[indexPath.row-1] objectForKey:@"Name"];
            cell.goodsPrice.text = [NSString stringWithFormat:@"￥%.1f",[[rightDatas[indexPath.row-1] objectForKey:@"Price"] floatValue]];
            cell.goodsMessage.text = [rightDatas[indexPath.row-1] objectForKey:@"Size"];
            if ([[rightDatas[indexPath.row-1] objectForKey:@"IsDirect"] boolValue]) {
                cell.goodsDescribe.hidden = YES;
            }else{
                cell.goodsDescribe.hidden = NO;
            }
            if ([[rightDatas[indexPath.row-1] objectForKey:@"IsImport"] boolValue]) {
                cell.goodsDescribe2.hidden = NO;
            }else{
                cell.goodsDescribe2.hidden = YES;
            }
            cell.goodsDescribe3.hidden = YES;
            
            if ([[rightDatas[indexPath.row-1] objectForKey:@"Stock"] intValue] <= 0) {
                [cell.addShoppingCartButton setImage:nil forState:UIControlStateNormal];
                [cell.addShoppingCartButton setTitle:@"补货中" forState:UIControlStateNormal];
                cell.addShoppingCartButton.userInteractionEnabled = NO;
                cell.minShoppingCartButton.hidden = YES;
                cell.numberLbael.hidden = YES;
            }
        }
        /**
         老价格加下划线
         **/
        cell.goodsOldPrice.hidden = YES;
        
        return cell;
    }
    
}
#pragma mark 处理加载更多
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (page*10 == indexPath.row) {
        page ++;
        [self getRightDatas:defaultRightStr page:page];
    }
}

#pragma mark 加入购物车
-(void)addShoppingCartButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    baseViewController *baseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"baseViewController"];
     flashGoodsTableViewCell *cell = (flashGoodsTableViewCell *)[_rightTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [baseVC addProductsAnimation:cell.goodsImage selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:rightDatas[sender.tag-1]];
    [_rightTableView reloadData];
 }
#pragma mark 减
-(void)minShoppingCartButton:(UIButton *)sender{
    NSArray *tempArray = [USERDEFAULTS objectForKey:@"FlashShoppingCartGoods"];
    for (int i=0; i<tempArray.count; i++) {
        if ([[tempArray[i] objectForKey:@"Fguid"] isEqualToString:[rightDatas[sender.tag-1] objectForKey:@"Fguid"]]) {
            if ([[tempArray[i] objectForKey:@"PurchaseQuantity"] intValue] <= 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsDelete" object:tempArray[i]];
            }
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsMin" object:rightDatas[sender.tag-1]];
    [_rightTableView reloadData];

}
#pragma mark 重置titleAddress宽度
-(void)initAddressTitleWidth:(NSString *)str{
    CGSize titleSize =[str  boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
    if (titleSize.width > SCREENWIDTH-170) {
        _titleAddressWidth.constant = SCREENWIDTH-170;
    }else{
        _titleAddressWidth.constant = titleSize.width;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        selectCellTag = indexPath.row;
        [_leftTableView reloadData];
        page = 1;
        defaultRightStr = [leftDatas[indexPath.row] objectForKey:@"StringId"];
        NSLog(@"%@",[leftDatas[indexPath.row] objectForKey:@"StringId"]);
        [self getRightDatas:[leftDatas[indexPath.row] objectForKey:@"StringId"] page:page];
    }else{
        if (indexPath.row !=0 && indexPath.row != rightDatas.count+1) {
            UIStoryboard *stroyBoard = GetStoryboard(@"Main");
            goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
            [goodsDetailsVC setGetID:rightDatas[indexPath.row-1]];
            [self.navigationController pushViewController:goodsDetailsVC animated:YES];
        }
       
    }
   
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"flashSmallToAddress"]){
        addressManageViewController *addressManageVC = segue.destinationViewController;
        addressManageVC.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
