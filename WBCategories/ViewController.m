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
#import "NSString+WBPredicate.h"


@interface ViewController ()
{
    UIView *redView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 测试数组
    NSArray *arr = @[@"1",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2"];
    NSMutableArray *tableArray = [[NSMutableArray alloc] initWithArray:arr];
    NSLog(@"arr====%@   tableArray====%@",arr[100],tableArray[100]);
    NSLog(@"arr====%@   tableArray====%@",[arr objectAtIndex:100],tableArray[100]);
    
    // 测试字典
    NSDictionary *dict = @{@"name":@"",@"age":@"20"};
    NSMutableDictionary *tableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSLog(@"dict---name====%@   tableDict---age====%@",[dict objectForKey:@"name"],[tableDict objectForKey:@"age"]);
    NSLog(@"dict---name====%@   tableDict---age====%@",[dict objectForKey:@"name"],[tableDict objectForKey:@"age"]);
    
//    // 测试字符串
    NSMutableString *tableString = [[NSMutableString alloc] initWithFormat:@"防止项目数组字典越界崩溃"];
    NSLog(@"%@",[tableString substringFromIndex:100]);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
