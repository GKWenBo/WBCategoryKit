//
//  ViewController.m
//  WBCategories
//
//  Created by Admin on 2018/2/6.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "ViewController.h"
#import "UIView+WBBasicAnimation.h"

@interface ViewController ()
{
    UIView *redView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    redView.center = self.view.center;
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [redView wb_trans180DegreeAnimation];
}


@end
