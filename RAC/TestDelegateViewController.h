//
//  TestDelegateViewController.h
//  RAC
//
//  Created by thor on 16/7/12.
//  Copyright © 2016年 thor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACSubject.h"

@interface TestDelegateViewController : UIViewController


@property (nonatomic, strong) RACSubject *delegateSignal;



@end
