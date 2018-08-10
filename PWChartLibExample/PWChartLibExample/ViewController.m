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
#import "ChartZBView.h"

#import "FSDataBridge.h"

@interface ViewController (){
    
    FSDataBridge *fsBridge;
}

@property (nonatomic , weak) IBOutlet ChartFSView *baseView;
@property (nonatomic , weak) IBOutlet ChartZBView *ftView;
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
}

- (void)setFtView:(ChartZBView *)ftView{
    _ftView = ftView;
    ftView.showFrame = CGRectMake(0, 0, ftView.frame.size.width, ftView.frame.size.height);
    ftView.enableTap = YES;
    ftView.enableDrag = YES;
}

- (IBAction)changeSF:(id)sender{
    int num = _baseView.showFrame.size.width == _baseView.frame.size.width ? 2 : 1;
    _baseView.showFrame = CGRectMake(0, 0, _baseView.frame.size.width / num, _baseView.frame.size.height / num);
}

- (IBAction)loadFS:(id)sender{
    [fsBridge loadFS];
}

@end
