//
//  TestDelegateViewController.m
//  RAC
//
//  Created by thor on 16/7/12.
//  Copyright © 2016年 thor. All rights reserved.
//

#import "TestDelegateViewController.h"

@interface TestDelegateViewController ()

@end

@implementation TestDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)back:(UIButton *)sender {
    
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:@"1"];
    }
    // 返回
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)dealloc
{
    NSLog(@"TestDelegateViewController 销毁了");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
