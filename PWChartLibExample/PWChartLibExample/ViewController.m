//
//  ViewController.m
//  PWChartLibExample
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ViewController.h"
#import <PWChartLib/ChartBaseView.h>

@interface ViewController ()

@property (nonatomic , weak) IBOutlet ChartBaseView *baseView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeSF:(id)sender{
    int num = _baseView.showFrame.size.width == _baseView.frame.size.width ? 2 : 1;
    _baseView.showFrame = CGRectMake(0, 0, _baseView.frame.size.width / num, _baseView.frame.size.height / num);
}

@end
