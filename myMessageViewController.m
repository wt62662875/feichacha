//
//  myMessageViewController.m
//  feichacha
//
//  Created by wt on 16/4/25.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "myMessageViewController.h"
#import "myMessageTableViewCell.h"

@interface myMessageViewController ()
{
    NSArray *Message;

}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *systemMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *userMessage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation myMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleView.layer.cornerRadius = 4;
    _titleView.layer.masksToBounds = YES;
    _titleView.layer.borderWidth = 1;
    _titleView.layer.borderColor = RGBCOLORA(255, 214, 0, 1).CGColor;
    // Do any additional setup after loading the view.

    [self MessList:@"false"];
}
-(void)MessList:(NSString *)Type{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] MessList:Type success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            Message = [responseObject objectForKey:@"AppendData"];

            [_tableView reloadData];
            
        }else {
            Message = nil;
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
            _tableView.hidden = YES;
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Message.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGSize titleSize =[[Message[indexPath.row] objectForKey:@"Content"]  boundingRectWithSize:CGSizeMake(SCREENWIDTH-16, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return  titleSize.height+ 60;
    
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myMessageTableViewCell";
    myMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"myMessageTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.title.text = [Message[indexPath.row] objectForKey:@"Title"];
    cell.message.text = [Message[indexPath.row] objectForKey:@"Content"];
    
    return cell;
}
- (IBAction)systemMessageClick:(id)sender {
    _systemMessageButton.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _userMessage.backgroundColor = [UIColor whiteColor];
    [_systemMessageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_userMessage setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];

    _tableView.hidden = YES;
    [self MessList:@"false"];
}
- (IBAction)userMessageClick:(id)sender {
    _userMessage.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _systemMessageButton.backgroundColor = [UIColor whiteColor];
    [_userMessage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_systemMessageButton setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];

    _tableView.hidden = NO;
    [self MessList:@"true"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
