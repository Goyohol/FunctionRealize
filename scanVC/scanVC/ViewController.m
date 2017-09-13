//
//  ViewController.m
//  scanVC
//
//  Created by RainHeroic Kung on 2017/9/12.
//  Copyright © 2017年 RainHeroic Kung. All rights reserved.
//

#import "ViewController.h"


#import "ZBarSDK.h" //扫描二维码，条形码
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController () <ZBarReaderDelegate>
{
    UILabel * _dataLB;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(30,70, 150,35)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"点击，扫描" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickToPresentZbarView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    _dataLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 200)];
    _dataLB.backgroundColor = [UIColor cyanColor];
    _dataLB.textAlignment = NSTextAlignmentCenter;
    _dataLB.numberOfLines = 0;
    _dataLB.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:_dataLB];
}
-(void)clickToPresentZbarView {
    ZBarReaderViewController * readerVC = [[ZBarReaderViewController alloc] init];
    readerVC.readerDelegate = self;
    
    readerVC.showsZBarControls = YES;//显示控制项
    readerVC.tracksSymbols = YES; //显示追踪框
    
    //设置识别范围
    //(距离左边/宽度，距离上边/高度，识别宽度/宽度，识别高度/高度)
//    float width = SCREEN_WIDTH*500.f/750.f;  //扫描宽度：屏幕宽度的2/3
//    float height = SCREEN_WIDTH*500.f/750.f; //扫描宽度：屏幕宽度的2/3
//    float scanV_X = (SCREEN_WIDTH-width)/2.f;
//    float scanV_Y = (SCREEN_HEIGHT-height)/2.f;
//    CGRect scanViewRect = CGRectMake(scanV_X/SCREEN_WIDTH, scanV_Y/SCREEN_HEIGHT, width/SCREEN_WIDTH, height/SCREEN_HEIGHT);
//    readerVC.scanCrop = scanViewRect;
    
    readerVC.scanCrop = CGRectMake(0, 0, 1, 1);//扫描范围：屏幕大小
    
    
    //设置识别的参数   根据需求调整，可以提高识别速度。
    ZBarImageScanner *scanner = readerVC.scanner;
    [scanner setSymbology:ZBAR_I25 //此参数和“to"后面的参数配合 确定了识别的编码范围
                   config:ZBAR_CFG_ENABLE
                       to:0];
    [self presentViewController:readerVC animated:YES completion:nil];
}

#pragma mark - ZBarReaderDelegate
-(void)imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info {
    id<NSFastEnumeration> results =[info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol =nil;
    for(symbol in results)
        break;
    NSLog(@"%@",symbol.data);//打印识别的数据
    [reader dismissViewControllerAnimated:YES completion:^{
        _dataLB.text = symbol.data;
    }];
    
}

-(void)sfa {
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
