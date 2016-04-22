//
//  luanchViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "luanchViewController.h"

@interface luanchViewController ()<UIScrollViewDelegate>
{
    NSArray *imageArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pages;

@end

@implementation luanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageArray = [[NSArray alloc]initWithObjects:@"loading@1242px2208px.jpg",@"loading2@1242px2208px.jpg",@"loading3@1242px2208px.jpg", nil];
    [_scrollView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHTIGHT)];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*2, 0, SCREENWIDTH, SCREENHTIGHT)];
    [image1 setImage:[UIImage imageNamed:imageArray[0]]];
    [image2 setImage:[UIImage imageNamed:imageArray[1]]];
    [image3 setImage:[UIImage imageNamed:imageArray[2]]];
    [_scrollView setContentSize:CGSizeMake(SCREENWIDTH*3, 0)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(SCREENWIDTH*2, 0, SCREENWIDTH, SCREENHTIGHT)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:button];
    [_scrollView addSubview:image1];
    [_scrollView addSubview:image2];
    [_scrollView addSubview:image3];

}
-(void)buttonClick:(UIButton*)sender{
    [self performSegueWithIdentifier:@"luanchViewToRootView" sender:self];
}

#pragma mark 动态轮播
- (void)nextImage
{
    int page = (int)self.pages.currentPage;
    if (page+1 == imageArray.count) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSInteger pageInt = _scrollView.contentOffset.x / _scrollView.frame.size.width;
        _pages.currentPage = pageInt;
        //    计算页码
        //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
        CGFloat scrollviewW =  scrollView.frame.size.width;
        CGFloat x = scrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        self.pages.currentPage = page;

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
