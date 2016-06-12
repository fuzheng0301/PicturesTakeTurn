//
//  FzhScrollViewAndPageView.m
//  ceshi
//
//  Created by 宅客 on 15/8/24.
//  Copyright (c) 2015年 宅客. All rights reserved.
//

#import "FzhScrollViewAndPageView.h"

@interface FzhScrollViewAndPageView ()
{
    UIView *firstView;
    UIView *middleView;
    UIView *lastView;
    
    float viewWidth;
    float viewHeight;
    
    NSTimer *autoScrollTimer;
    
    UITapGestureRecognizer *_tap;
}

@end

@implementation FzhScrollViewAndPageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewWidth = self.frame.size.width;
        viewHeight = self.frame.size.height;
        
        //设置scrollView
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(viewWidth * 3, viewHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor cyanColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        //设置分页
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, viewHeight-30, viewWidth, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor orangeColor];
        [self addSubview:_pageControl];
        
        //设置单击手势
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        _tap.numberOfTouchesRequired = 1;
        _tap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:_tap];
        
    }
    return self;
}

#pragma mark ---- 单击手势实现
-(void)handleTap:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_currentPage+1];
    }
}

#pragma mark ---- 设置imageViewAry
-(void)setImageViewAry:(NSMutableArray *)imageViewAry
{
    if (imageViewAry) {
        _imageViewAry = imageViewAry;
        _currentPage = 0;//默认为第0页
        _pageControl.numberOfPages = _imageViewAry.count;
    }
    [self reloadData];
}

#pragma mark --- 刷新view页面
-(void)reloadData
{
    [firstView removeFromSuperview];
    [middleView removeFromSuperview];
    [lastView removeFromSuperview];
    
    //从数组中取到对应的图片view加到已定义的三个view中
    if (_currentPage == 0) {
        firstView = [_imageViewAry lastObject];
        middleView = [_imageViewAry objectAtIndex:_currentPage];
        lastView = [_imageViewAry objectAtIndex:_currentPage+1];
    }else if (_currentPage == _imageViewAry.count-1){
        firstView = [_imageViewAry objectAtIndex:_currentPage-1];
        middleView = [_imageViewAry objectAtIndex:_currentPage];
        lastView = [_imageViewAry firstObject];
    }else{
        firstView = [_imageViewAry objectAtIndex:_currentPage-1];
        middleView = [_imageViewAry objectAtIndex:_currentPage];
        lastView = [_imageViewAry objectAtIndex:_currentPage+1];
    }
    
    //设置三个view的frame，加到scrollView上
    firstView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    middleView.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight);
    lastView.frame = CGRectMake(viewWidth*2, 0, viewWidth, viewHeight);
    [_scrollView addSubview:firstView];
    [_scrollView addSubview:middleView];
    [_scrollView addSubview:lastView];
    
    //设置当前的分页
    _pageControl.currentPage = _currentPage;
    
    //显示中间页
    _scrollView.contentOffset = CGPointMake(viewWidth, 0);
    
}

#pragma mark ---- scrollView停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滑动时候暂停自动替换
    [autoScrollTimer invalidate];
    autoScrollTimer = nil;
    autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
    
    //得到当前页数
    float x = _scrollView.contentOffset.x;
    
    //往前翻
    if (x <= 0) {
        if (_currentPage - 1 < 0) {
            _currentPage = _imageViewAry.count - 1;
        }else{
            _currentPage --;
        }
    }
    
    //往后翻
    if (x > viewWidth) {
        if (_currentPage == _imageViewAry.count - 1) {
            _currentPage = 0;
        }else{
            _currentPage ++;
        }
    }
    
    [self reloadData];
    
}

#pragma mark --- 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart
{
    if (shouldStart) {//开启自动翻页
        if (!autoScrollTimer) {
            autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
        }
    }else{//关闭自动翻页
        if (autoScrollTimer.isValid) {
            [autoScrollTimer invalidate];
            autoScrollTimer = nil;
        }
    }
}

#pragma mark ---- 展示下一页
-(void)autoShowNextImage
{
    if (_currentPage == _imageViewAry.count - 1) {
        _currentPage = 0;
    }else{
        _currentPage ++;
    }
    [self reloadData];
}

@end
