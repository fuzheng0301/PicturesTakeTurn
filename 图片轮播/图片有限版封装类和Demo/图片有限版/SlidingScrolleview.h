//
//  SlidingScrolleview.h
//  scrollView
//
//  Created by 付正 on 15-8-24.
//  Copyright (c) 2015年 付正. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlidingScrolleviewDelegate <NSObject>

@optional
/**
 *  图片点击事件
 *
 *  @param index 点击的图片
 */
-(void)slidingClickImage_index:(long)index;

@end

@interface SlidingScrolleview : UIView

/**
 *  代理
 */
@property (nonatomic,assign) id delegate;
/**
 *  设置图片的数目
 *
 *  @param arr 数组
 */
-(void)setImageArr:(NSArray *)arr ofType:(NSString *)ext;

/**
 *  开启timer
 */
-(void)startTimer;

/**
 *  关闭timer
 */
-(void)colseTimer;

@end



/*
 *使用方法：
 *1.导入本文件到工程中;
 *2.导入头文件SlidingScrolleview.h;
 *3.服从代理SlidingScrolleviewDelegate;
 *4.示例代码：
 *
 SlidingScrolleview *scrollview = [[SlidingScrolleview alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 230)];
 [scrollview setImageArr:@[@"1",@"2",@"3",@"4"] ofType:@".jpg"];
 scrollview.delegate = self;
 [self.view addSubview:scrollview];
 *
 -(void)slidingClickImage_index:(long)index
 {
 NSLog(@"你点击了第%ld张图片",index);
 }
 *
 */


