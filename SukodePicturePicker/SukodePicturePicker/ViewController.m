//
//  ViewController.m
//  SukodePicturePicker
//
//  Created by RainHeroic Kung on 2017/11/27.
//  Copyright © 2017年 RainHeroic Kung. All rights reserved.
//

#import "ViewController.h"

#import "SudokuAddImageView.h" //头文件

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SudokuAddImageView * addImg_V = [[SudokuAddImageView alloc] init];
    //addImg_V.allowEdit = YES; //是否可编辑
    addImg_V.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    [self.view addSubview:addImg_V];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
