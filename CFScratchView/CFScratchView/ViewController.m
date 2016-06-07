//
//  ViewController.m
//  CFScratchView
//
//  Created by 于传峰 on 16/6/6.
//  Copyright © 2016年 于传峰. All rights reserved.
//

#import "ViewController.h"
#import "CFScratchView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage* image = [UIImage imageNamed:@"paint01-1"];
    UIImage* coverImage = [UIImage imageNamed:@"paint01-01blur"];
    CFScratchView* scratchView = [[CFScratchView alloc] initWithImage:image coverImage:coverImage];
    [self.view addSubview:scratchView];
    scratchView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 400);
    
    UIButton* clearButton = [[UIButton alloc] init];
    [self.view addSubview:clearButton];
    [clearButton setTitle:@"恢复" forState:UIControlStateNormal];
    clearButton.frame = CGRectMake(100, 50, 50, 25);
    clearButton.backgroundColor = [UIColor blueColor];
    [clearButton addTarget:scratchView action:@selector(recover) forControlEvents:UIControlEventTouchUpInside];
}


@end
