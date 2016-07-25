//
//  commonProblemsViewController.m
//  feichacha
//
//  Created by wt on 16/4/25.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "commonProblemsViewController.h"
#import "foldingTableViewCell.h"
#import "anTableViewCell.h"

@interface commonProblemsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *anFolding;     //1 展开 0 折叠
    NSArray * tempArray;
    NSArray * tempArray2;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation commonProblemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    anFolding = [[NSMutableArray alloc]init];
    tempArray = [[NSArray alloc]initWithObjects:@"飞叉叉的服务时间？",@"可配送哪些区域？",@"如何在飞叉叉下单购买商品？",@"如何新增、编辑和删除收货地址？",@"什么是“叉叉精选”商品？",@"什么是进口商品？",@"优惠券怎么使用？",@"如何查询历史订单？",@"退款流程?",nil];
    tempArray2 = [[NSArray alloc]initWithObjects:@"飞叉叉人工客服的服务时间是9：00一24：00，飞叉叉的配送时间：一、如果你购买的是“闪送小超”类商品，配送时间视商家的营业时间而定，一般配送时间在9：00一24：00，24小时店一般可随时配送。二、如果客户购买的是“新鲜预定”类商品，配送时间统一为，次日10：00一18：00配送员会电话联系你告之具体送达时间。",@"目前只暂时配送重庆主城，其它区县陆续开通配送服务。",@"进入商城后，你可以进入“送货方式”界面，在“送货上门”下面添加或选择某个收货地址，然后选择商品，付款，生成订单后，我们就会立刻送货上门，你也可以选择“到店自提”下面的某个自提点，你选择商品，付款，生成订单，然后到选择的商家店内取货。",@"你可以在“送货上门”下面点击新增新的收货地址，也可以对某个收货地址进行编辑和删除处理。",@"所有商品名称前带有“精”标志的，全部为叉叉精选商品。",@"所有商品名称前带有“进”标志的，全部为进口商品。",@"优惠券可购买带有“精”标志商品和“新鲜预定”里面的商品，根据优惠券的优惠面值来决定优惠多少。",@"可在“我的”里面的查询相应的订单情况。",@"客户可在“我的”里面申请退款，如遇不能解决问题，请立即联系客服电话4000172819  我们将在第一时间处理。",nil];


    for (int i = 0; i < tempArray.count; i++) {
        [anFolding addObject:@"0"];
    }


    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tempArray.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([anFolding[indexPath.row] isEqualToString:@"0"]) {
        return 44;
    }else{
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize titleSize =[tempArray2[indexPath.row]  boundingRectWithSize:CGSizeMake(SCREENWIDTH-16, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return titleSize.height + 60;
    }

}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([anFolding[indexPath.row] isEqualToString:@"0"]) {
        static NSString *cellIdentifier = @"foldingTableViewCell";
        foldingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"foldingTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.title.text = tempArray[indexPath.row];
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"anTableViewCell";
        anTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"anTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.title.text = tempArray[indexPath.row];
        cell.message.text = tempArray2[indexPath.row];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([anFolding[indexPath.row] isEqualToString:@"0"]) {
        [anFolding replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else{
        [anFolding replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    [_tableView reloadData];
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
