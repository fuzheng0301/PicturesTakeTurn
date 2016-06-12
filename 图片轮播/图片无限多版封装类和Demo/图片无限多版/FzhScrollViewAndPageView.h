//
//  FzhScrollViewAndPageView.h
//  ceshi
//
//  Created by 宅客 on 15/8/24.
//  Copyright (c) 2015年 宅客. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FzhScrollViewDelegate;

@interface FzhScrollViewAndPageView : UIView<UIScrollViewDelegate>
{
    __unsafe_unretained id <FzhScrollViewDelegate> _delegate;
}

@property(nonatomic, assign)id <FzhScrollViewDelegate>delegate;

@property(nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)NSMutableArray *imageViewAry;
@property (nonatomic, readonly)UIScrollView *scrollView;
@property (nonatomic, readonly)UIPageControl *pageControl;

-(void)shouldAutoShow:(BOOL)shouldStart;


@end

@protocol FzhScrollViewDelegate <NSObject>

@optional
-(void)didClickPage:(FzhScrollViewAndPageView *)view atIndex:(NSInteger)index;

@end

/*
 *使用方法：
 *1.导入本文件到工程中;
 *2.导入头文件FzhScrollViewAndPageView.h;
 *3.服从FzhScrollViewDelegate代理
 *4.使用方法实例如下：
 *
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [self.navigationController.navigationBar setTranslucent:NO];
 
 //创建view（view中包含UIScrollView、UIPageControl，设置frame）
 _fzhView = [[FzhScrollViewAndPageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
 
 //把n张图片放到imageView上
 NSMutableArray *tempAry = [NSMutableArray array];
 for (int i=0; i<4; i++) {
 UIImageView *imageView = [[UIImageView alloc]init];
 imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpg",i]];
 [tempAry addObject:imageView];
 }
 
 //把imageView数组存到fzhView里
 [_fzhView setImageViewAry:tempAry];
 
 //把图片展示的view加到当前页面
 [self.view addSubview:_fzhView];
 
 //开启自动翻页
 [_fzhView shouldAutoShow:YES];
 
 //遵守协议
 _fzhView.delegate = self;
 }
 
 #pragma mark --- 协议里面方法，点击某一页
 -(void)didClickPage:(FzhScrollViewAndPageView *)view atIndex:(NSInteger)index
 {
 NSLog(@"点击了第%ld页",index);
 }
 */


