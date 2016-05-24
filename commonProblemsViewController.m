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
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation commonProblemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    anFolding = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        [anFolding addObject:@"0"];
    }
    tempArray = [[NSArray alloc]initWithObjects:@"飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉", @"飞叉叉飞叉叉飞叉叉飞飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉叉叉飞叉叉飞叉叉",@"飞叉叉飞飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉叉叉飞叉叉飞叉叉飞叉叉飞叉叉",@"飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉",@"飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉",@"飞叉叉飞叉叉飞叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉叉飞叉叉飞叉叉飞叉叉",@"飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉",@"飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉",@"飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉",@"飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉飞叉叉",nil];

    // Do any additional setup after loading the view.
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([anFolding[indexPath.row] isEqualToString:@"0"]) {
        return 44;
    }else{
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize titleSize =[tempArray[indexPath.row]  boundingRectWithSize:CGSizeMake(SCREENWIDTH-16, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
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

        
        return cell;
    }else{
        static NSString *cellIdentifier = @"anTableViewCell";
        anTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"anTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        cell.message.text = tempArray[indexPath.row];
        
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
