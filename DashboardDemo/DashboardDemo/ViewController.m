//
//  ViewController.m
//  DashboardDemo
//
//  Created by FuNing on 2021/4/27.
//

#import "ViewController.h"
#import "TestView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestView *tv = [[TestView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    tv.endValue = 0.8;
    tv.countNum = @"12.11";
    [self.view addSubview:tv];
    
}


@end
