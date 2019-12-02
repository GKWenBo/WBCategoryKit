//
//  WBCategoryKitTests.m
//  WBCategoryKitTests
//
//  Created by wenmobo on 09/05/2018.
//  Copyright (c) 2018 wenmobo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WBUIFont.h>
#import <NSObject+WBAdditional.h>
#import <UISearchBar+WBAddition.h>
#import <WBPermission.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testFont {
    XCTAssertNotEqualObjects([UIFont systemFontOfSize:10], [UIFont systemFontOfSize:10 * 375 / [UIScreen mainScreen].bounds.size.width], @"已进行runtime字体适配");
    XCTAssertNotEqualObjects([UIFont systemFontOfSize:15], [UIFont systemFontOfSize:15 * 375 / [UIScreen mainScreen].bounds.size.width], @"已进行runtime字体适配");
}

- (void)testKVC {
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.scopeButtonTitles = @[@"A", @"B"];
    searchBar.showsCancelButton = YES;
    [searchBar sizeToFit];
    [searchBar wb_setValue:@"Test" forKey:@"_cancelButtonText"];
    // iOS13 crash : [searchBar setValue:@"Test" forKey:@"_cancelButtonText"];
    UIView *searchField = [searchBar  wb_valueForKey:@"_searchField"];
    // iOS13 crash : [searchBar valueForKey:@"_searchField"];

    XCTAssertTrue(searchBar.wb_backgroundView);
    XCTAssertTrue(searchBar.wb_cancelButton);
    XCTAssertTrue(searchBar.wb_segmentedControl);
    XCTAssertFalse([searchBar wb_valueForKey:@"_searchController"]);
}

//- (void)testPermission {
//    XCTestExpectation *ex = [self expectationWithDescription:@"test"];
//    [WBPermission wb_authorizeWithType:WBPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
//        XCTAssertTrue(granted);
//        [ex fulfill];
//    }];
//    
//    [self waitForExpectations:@[ex] timeout:20];
//}

@end

