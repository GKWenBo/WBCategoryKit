//
//  ViewController.m
//  WBCategories
//
//  Created by Admin on 2018/2/6.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "ViewController.h"
#import "UIDevice+WBUUID.h"
#import "UIWindow+WBHierarchy.h"
#import "WBMacroDefinition.h"

@interface ViewController ()
{
    UIView *redView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",kAPP_API_BASEURL);
    NSLog(@"%@",NSStringFromUIEdgeInsets(kWBVIEWSAFEAREAINSETS(self.view)));

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
