//
//  ViewController.m
//  PicturesTakeTurn
//
//  Created by 聚财通 on 16/6/12.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "ViewController.h"
#import "SlidingScrolleview.h"

@interface ViewController ()<SlidingScrolleviewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SlidingScrolleview *scrollview = [[SlidingScrolleview alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 230)];
    [scrollview setImageArr:@[@"1",@"2",@"3",@"4"] ofType:@".jpg"];
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    
}

-(void)slidingClickImage_index:(long)index
{
    NSLog(@"你点击了第%ld张图片",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
