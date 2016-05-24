//
//  useRulesViewController.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "useRulesViewController.h"
#import "useRulesTableViewCell.h"

@interface useRulesViewController ()
{
    NSArray *tempArray1;
    NSArray *tempArray2;

}

@end

@implementation useRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tempArray1 = [[NSArray alloc]initWithObjects:@"优惠卷可以干什么？",@"怎么获得优惠卷？",@"一张优惠卷能拆开多次使用吗？", nil];
    tempArray2 = [[NSArray alloc]initWithObjects:@"在线支付时抵扣商品金额。",@"在飞叉叉不定期退出的活动中获得\n从朋友分享的福利红包中获得",@"不能，一张优惠卷只能一次性使用，不能分开使用", nil];

    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGSize titleSize =[tempArray1[indexPath.row]  boundingRectWithSize:CGSizeMake(SCREENWIDTH-37, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGSize titleSize2 =[tempArray2[indexPath.row]  boundingRectWithSize:CGSizeMake(SCREENWIDTH-37, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
    
    return titleSize.height +titleSize2.height + 24;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"useRulesTableViewCell";
    useRulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"useRulesTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.questionLabel.text = tempArray1[indexPath.row];
    cell.answerLabel.text = tempArray2[indexPath.row];

    
    return cell;

    
}
- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
