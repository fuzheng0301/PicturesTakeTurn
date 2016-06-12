//
//  ViewController.m
//  PicturesTakeTurn
//
//  Created by 聚财通 on 16/6/12.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "ViewController.h"
#import "FzhScrollViewAndPageView.h"

@interface ViewController ()<FzhScrollViewDelegate>

@property (nonatomic, strong) FzhScrollViewAndPageView *fzhView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建view（view中包含UIScrollView、UIPageControl，设置frame）
    _fzhView = [[FzhScrollViewAndPageView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 230)];
    
    //把n张图片放到imageView上
    NSMutableArray *tempAry = [NSMutableArray array];
    for (int i=1; i<5; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [tempAry addObject:imageView];
    }
    
    //把imageView数组存到fzhView里
    [_fzhView setImageViewAry:tempAry];
    //开启自动翻页
    [_fzhView shouldAutoShow:YES];
    //遵守协议
    _fzhView.delegate = self;
    //把图片展示的view加到当前页面
    [self.view addSubview:_fzhView];
    
}

#pragma mark --- 协议里面方法，点击某一页
-(void)didClickPage:(FzhScrollViewAndPageView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld页",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
