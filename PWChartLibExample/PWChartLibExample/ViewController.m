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
    fxBridge.codeId = @"CNH";
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
    _baseView.fsConfig.isShowMA = YES;
}

- (void)setFtView:(ChartZBView *)ftView{
    _ftView = ftView;
    ftView.showFrame = CGRectMake(0, 0, ftView.frame.size.width, ftView.frame.size.height);
    ftView.enableTap = YES;
    ftView.enableDrag = YES;
}

- (void)setBaseView2:(ChartFXView *)baseView2{
    _baseView2 = baseView2;
    baseView2.showFrame = CGRectMake(0, 0, baseView2.frame.size.width, baseView2.frame.size.height);
    baseView2.enableTap = YES;
    baseView2.enableDrag = YES;
    baseView2.enableScale = YES;
}

- (void)setFtView2:(ChartZBView *)ftView2{
    _ftView2 = ftView2;
    ftView2.showFrame = CGRectMake(0, 0, ftView2.frame.size.width, ftView2.frame.size.height);
    ftView2.enableTap = YES;
    ftView2.enableDrag = YES;
    ftView2.enableScale = YES;
}

- (IBAction)changeSF:(id)sender{
    int num = _baseView.showFrame.size.width == _baseView.frame.size.width ? 2 : 1;
    _baseView.showFrame = CGRectMake(0, 0, _baseView.frame.size.width / num, _baseView.frame.size.height / num);
}

- (IBAction)loadFS:(id)sender{
    [fsBridge loadFS];
    [fxBridge loadFX:0];
}

- (IBAction)showHide:(id)sender{
    _baseView2.hidden = !_baseView2.hidden;
    _ftView2.hidden = !_ftView2.hidden;
    
    _baseView.hidden = !_baseView2.hidden;
    _ftView.hidden = !_ftView2.hidden;
}

@end
