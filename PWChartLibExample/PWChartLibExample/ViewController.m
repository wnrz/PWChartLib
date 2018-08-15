//
//  ViewController.m
//  PWChartLibExample
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ViewController.h"
#import <PWChartLib/ChartBaseView.h>
#import "ChartFSView.h"
#import "ChartFXView.h"
#import "ChartZBView.h"

#import "FSDataBridge.h"
#import "FXDataBridge.h"

@interface ViewController (){
    
    FSDataBridge *fsBridge;
    FXDataBridge *fxBridge;
}

@property (nonatomic , weak) IBOutlet ChartFSView *baseView;
@property (nonatomic , weak) IBOutlet ChartZBView *ftView;

@property (nonatomic , weak) IBOutlet ChartFXView *baseView2;
@property (nonatomic , weak) IBOutlet ChartZBView *ftView2;

@property (nonatomic , weak) IBOutlet UILabel *fxzblabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _baseView.ftViews = [[NSMutableArray alloc] initWithObjects:_ftView, nil];
    
    fsBridge = [[FSDataBridge alloc] init];
    fsBridge.fsView = _baseView;
        fsBridge.codeId = @"AUTD";
        fsBridge.marketCode = @"SGE";
    
    //    fsBridge.codeId = @"EUR";
//    fsBridge.codeId = @"CNH";
//    fsBridge.marketCode = @"MSFX";
    
    fxBridge = [[FXDataBridge alloc] init];
    fxBridge.fxView = _baseView2;
    fxBridge.codeId = fsBridge.codeId;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBaseView:(ChartFSView *)baseView{
    _baseView = baseView;
    baseView.showFrame = CGRectMake(0, 0, _baseView.frame.size.width, _baseView.frame.size.height);
    baseView.enableTap = YES;
    baseView.enableDrag = YES;
    baseView.fsConfig.isShowMA = YES;
    _ftView.ztView = baseView;
}

- (void)setFtView:(ChartZBView *)ftView{
    _ftView = ftView;
    ftView.showFrame = CGRectMake(0, 0, ftView.frame.size.width, ftView.frame.size.height);
    ftView.enableTap = YES;
    ftView.enableDrag = YES;
    ftView.ztView = _baseView;
    ftView.config.ftZBName = @"KDJ";
}

- (void)setBaseView2:(ChartFXView *)baseView2{
    _baseView2 = baseView2;
    baseView2.showFrame = CGRectMake(0, 0, baseView2.frame.size.width, baseView2.frame.size.height);
    baseView2.enableTap = YES;
    baseView2.enableDrag = YES;
    baseView2.enableScale = YES;
    baseView2.fxConfig.ztZBName = @"MA";
    _ftView2.ztView = baseView2;
}

- (void)setFtView2:(ChartZBView *)ftView2{
    _ftView2 = ftView2;
    ftView2.showFrame = CGRectMake(0, 0, ftView2.frame.size.width, ftView2.frame.size.height);
    ftView2.enableTap = YES;
    ftView2.enableDrag = YES;
    ftView2.enableScale = YES;
    ftView2.ztView = _baseView2;
    ftView2.config.ftZBName = @"MACD";
}

- (IBAction)changeSF:(id)sender{
    int num = _baseView.showFrame.size.width == _baseView.frame.size.width ? 2 : 1;
    _baseView.showFrame = CGRectMake(0, 0, _baseView.frame.size.width / num, _baseView.frame.size.height / num);
}

- (IBAction)loadFS:(id)sender{
    [fsBridge loadFS];
    [fxBridge loadFX:0];
}

- (IBAction)clearFS:(id)sender{
    [_baseView clearData];
    [_ftView clearData];
}

- (IBAction)clearFX:(id)sender{
    [_baseView2 clearData];
    [_ftView2 clearData];
}

- (IBAction)changeFSZB:(id)sender{
    NSArray *arr = @[@"VOL",@"KDJ",@"MACD"];
    NSInteger index = [arr indexOfObject:_ftView.config.ftZBName];
    index = index + 1 >= arr.count ? 0 : index + 1;
    [_ftView changeZB:arr[index]];
}

- (IBAction)changeFXZB:(id)sender{
    NSArray *arr = @[@"VOL",@"MACD",@"CCI",@"KDJ",@"RSI",@"PSY",@"WR",@"ASI",@"OBV",@"ROC"];
    NSInteger index = [arr indexOfObject:_ftView2.config.ftZBName];
    index = index + 1 >= arr.count ? 0 : index + 1;
    _fxzblabel.text = arr[index];
    [_ftView2 changeZB:arr[index]];
}

- (IBAction)changeFXZQ:(id)sender{
    NSInteger kline = _baseView2.fxConfig.fxLinetype;
    kline = kline == KLineType_MONTH ? KLineType_1Min : kline + 1;
    [_baseView2 changeZQ:kline];
    [fxBridge loadFX:0];
}

- (IBAction)tszf:(id)sender{
    [_baseView2 changeZQ:KLineType_DAY];
    [fxBridge loadFX:0];
    NSArray *arr = @[@"MA",@"特色"];
    NSInteger index = [arr indexOfObject:_baseView2.fxConfig.ztZBName];
    index = index + 1 >= arr.count ? 0 : index + 1;
    _fxzblabel.text = arr[index];
    [_baseView2 changeZB:arr[index]];
}

- (IBAction)showHide:(id)sender{
    _baseView2.hidden = !_baseView2.hidden;
    _ftView2.hidden = !_ftView2.hidden;
    
    _baseView.hidden = !_baseView2.hidden;
    _ftView.hidden = !_ftView2.hidden;
}

@end
