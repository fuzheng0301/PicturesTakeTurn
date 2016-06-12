//
//  SlidingScrolleview.m
//  scrollView
//
//  Created by 付正 on 15-8-24.
//  Copyright (c) 2015年 付正. All rights reserved.
//

#import "SlidingScrolleview.h"

@interface SlidingScrolleview ()<UIScrollViewDelegate>
{
    /**
     *  图片的个数
     */
    NSUInteger imageNumber;
    /**
     *  滑动的图片数
     */
    int currentPageIndex;
    /**
     *  是否启动timer
     */
    BOOL isTimerStart;
}
/**
 *  计时器
 */
@property (nonatomic,retain) NSTimer *timer;
/**
 *  UIPageControl
 */
@property (nonatomic,retain) UIPageControl *pageControl;
/**
 *  scrollview
 */
@property (nonatomic,retain) UIScrollView *scrollview;
/**
 *  图片数组
 */
@property (nonatomic,retain) NSArray *imageArray;

@end

@implementation SlidingScrolleview

//-(void)dealloc
//{
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//    self.pageControl = nil;
//    self.scrollview = nil;
//    self.imageArray = nil;
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark ---- 添加图片
-(void)setImageArr:(NSArray *)arr ofType:(NSString *)ext
{
    //设置滚动视图的属性
    self.imageArray = arr;
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    scrollview.scrollsToTop = NO;
    scrollview.userInteractionEnabled = YES;
    self.scrollview = scrollview;
    [self addSubview:scrollview];
//    [scrollview release];
    
    //深拷贝imageview上的控件
    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:arr];
    UIImageView *imageview1=[arr objectAtIndex:([arr count]-1)];
    UIImageView *imageview2=[arr objectAtIndex:0];
    NSData *data1=[NSKeyedArchiver archivedDataWithRootObject:imageview1];
    NSData *data2=[NSKeyedArchiver archivedDataWithRootObject:imageview2];
    UIImageView *imageview3=[NSKeyedUnarchiver unarchiveObjectWithData:data1];
    UIImageView *imageview4=[NSKeyedUnarchiver unarchiveObjectWithData:data2];
    [tempArray insertObject:imageview3 atIndex:0];
    [tempArray addObject:imageview4];
    imageNumber = tempArray.count;
    
    //循环添加图片
    for (int i=0; i<imageNumber; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageview.userInteractionEnabled = YES;
        imageview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[tempArray objectAtIndex:i] ofType:ext]];
        imageview.tag = 10 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewClick:)];
        [imageview addGestureRecognizer:tap];
//        [tap release];
        
        [self.scrollview addSubview:imageview];
//        [imageview release];
    }
    
    //添加分页控制器
    float pageControlWidth = (imageNumber-2) * 10.0f + 40.f;
    UIPageControl *pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width/2-pageControlWidth/2),self.frame.size.height-27, pageControlWidth, 20)];
    self.pageControl = pageControl;
    pageControl.currentPage = 0;
    pageControl.numberOfPages = imageNumber-2;
    pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:pageControl];
//    [pageControl release];
    
    self.scrollview.contentSize = CGSizeMake(self.frame.size.width * imageNumber, self.frame.size.height);
    [self.scrollview setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    [self startTimer];
}

#pragma mark --- 时间计时器
#pragma mark --- 开始计时
-(void)startTimer
{
    if(self.timer == nil){
        isTimerStart = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    }
}

#pragma mark --- 停止计时
-(void)colseTimer
{
    if (self.timer) {
        isTimerStart = NO;
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)timerStart
{
    CGPoint pt = self.scrollview.contentOffset;
    if(pt.x == self.frame.size.width * (imageNumber-2)){
        self.pageControl.currentPage = 0;
        [self.scrollview scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    }else{
        [self.scrollview scrollRectToVisible:CGRectMake(pt.x + self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    }
}

#pragma mark --- 手动滚动时停止计时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self colseTimer];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.scrollview.frame.size.width;
    int page = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = (page-1);
    currentPageIndex = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (0 == currentPageIndex) {
        [self.scrollview setContentOffset:CGPointMake([self.imageArray count]*self.frame.size.width, 0)];
    }
    if (([self.imageArray count]+1) == currentPageIndex) {
        [self.scrollview setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
    [self startTimer];
}

-(void)imageviewClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击的图片：%ld",tap.view.tag-10);
    if (_delegate && [_delegate respondsToSelector:@selector(slidingClickImage_index:)]) {
        [self.delegate slidingClickImage_index:tap.view.tag-10];
    }
}

@end
