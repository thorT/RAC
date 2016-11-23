//
//  ViewController.m
//  RAC
//
//  Created by thor on 16/7/12.
//  Copyright © 2016年 thor. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "TestDelegateViewController.h"



@interface ViewController ()

@property (nonatomic,strong) RACCommand *conmmand; //处理事件的类

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //  RACSignal
   // [self p_RACSignal];
    
    // 2. RACSubject:
  //  [self p_RACSubject];
    
    // 3.RACReplaySubject
  //  [self p_RACReplaySubject];
    
    // 4.RACSubject delegate
   // [self p_RACSubjectDelegate];
    
    // 5.RACTuple和RACSequence
  //  [self p_RACSequence];
    
    // 6.RACCommand
   // [self p_RACCommand];
    
    // 7.RACMulticastConnection 处理多次订阅的问题
    //8. map和flattenMap 的区别
    
    [self p_then];
    
    
}

#pragma mark - 核心类 RACSignal
- (void)p_RACSignal
{
    // 1.最核心的类 RACSignal
    // 信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
    
    
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
       // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 3. 发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            //5. 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
        
    }];
    
    // 2.订阅信号,才会激活信号.
    [signal subscribeNext:^(id x) {
        // 4. block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
    
}

#pragma mark -  p_RACSubject
- (void)p_RACSubject
{
    //RACSubject:信号提供者，自己可以充当信号，又能发送信号。
    //使用场景:通常用来代替代理，有了它，就不必要定义代理了。
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"1"];
    
    
}

#pragma mark -  p_RACReplaySubject
- (void)p_RACReplaySubject
{
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第三个订阅者接收到的数据%@",x);
    }];
    
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];

}

#pragma mark -  p_RACSubjectDelegate
- (IBAction)testRACSubjectDelegate:(UIButton *)sender {
    [self p_RACSubjectDelegate];
}
- (void)p_RACSubjectDelegate
{
    // 创建信号
    RACSubject *suject = [RACSubject subject];
    [suject subscribeNext:^(id x) {
        NSLog(@"textSubjectDelegate back == %@",x);
    }];
    
    // 跳转
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TestDelegateViewController *testVC = [storyboard instantiateViewControllerWithIdentifier:@"TestDelegateViewController"];
    testVC.delegateSignal = suject;
    [self presentViewController:testVC animated:YES completion:nil];
}

#pragma mark -  p_RACSequence
- (void)p_RACSequence
{
//    6.6RACTuple:元组类,类似NSArray,用来包装值.
//    6.7RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"rac_sequence numbers x= %@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
}

#pragma mark -  p_RACCommand
- (void)p_RACCommand
{
//    6.8RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程
//    使用场景:监听按钮点击，网络请求
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        NSLog(@"执行了命令 input = %@",input);
        
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _conmmand = command;
    
    
    
    // 3.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
        }];
        
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 5.执行命令
    [self.conmmand execute:@1];
    
}




#pragma Mark- 常见功能
//- (void)common
//{
//    // 1.代替代理
//    // 需求：自定义redView,监听红色view中按钮点击
//    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
//    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
//    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
//    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
//        NSLog(@"点击红色按钮");
//    }];
//    
//    // 2.KVO
//    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
//    // observer:可以传入nil
//    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//        
//    }];
//    
//    // 3.监听事件
//    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
//    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//        NSLog(@"按钮被点击了");
//    }];
//    
//    // 4.代替通知
//    // 把监听到的通知转换信号
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
//        NSLog(@"键盘弹出");
//    }];
//
//    // 5.监听文本框的文字改变
//    [_textField.rac_textSignal subscribeNext:^(id x) {
//        
//        NSLog(@"文字改变了%@",x);
//    }];
//    
//    // 6.处理多个请求，都返回结果的时候，统一做处理.
//    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        // 发送请求1
//        [subscriber sendNext:@"发送请求1"];
//        return nil;
//    }];
//    
//    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        // 发送请求2
//        [subscriber sendNext:@"发送请求2"];
//        return nil;
//    }];
//    
//    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
//    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
//}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

#pragma mark - 常见的宏
//8.1 RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
//
//// 只要文本框文字改变，就会修改label的文字
//RAC(self.labelView,text) = _textField.rac_textSignal;
//8.2 RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
//
//[RACObserve(self.view, center) subscribeNext:^(id x) {
//    
//    NSLog(@"%@",x);
//}];
//8.3  @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
//
//8.4 RACTuplePack：把数据包装成RACTuple（元组类）
//
//// 把参数中的数据包装成元组
//RACTuple *tuple = RACTuplePack(@10,@20);
//
//8.5 RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
//
//// 把参数中的数据包装成元组
//RACTuple *tuple = RACTuplePack(@"xmg",@20);
//
//// 解包元组，会把元组的值，按顺序给参数里面的变量赋值
//// name = @"xmg" age = @20
//RACTupleUnpack(NSString *name,NSNumber *age) = tuple;

#pragma mark - 8. map和flattenMap 的区别
- (void)flattenMap
{
//    1.FlatternMap中的Block返回信号。
//    2.Map中的Block返回对象。
//    3.开发中，如果信号发出的值不是信号，映射一般使用Map
//    4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
    
    // 创建信号中的信号
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    [[signalOfsignals flattenMap:^RACStream *(id value) {
        
        // 当signalOfsignals的signals发出信号才会调用
        
        return value;
        
    }] subscribeNext:^(id x) {
        
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        
        NSLog(@"%@aaa",x);
    }];
    
    // 信号的信号发送信号
    [signalOfsignals sendNext:signal];
    
    // 信号发送内容
    [signal sendNext:@1];
    
}

#pragma mark - 9. concat :按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
- (void)p_concat
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}


#pragma mark - 9. then: 用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
- (void)p_then
{
    // then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    // 注意使用then，之前信号的值会被忽略掉.
    // 底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@",x);
    }];
}

#pragma mark - 10. merge: 把多个信号合并为一个信号，任何一个信号有新值的时候就会调用。
- (void)p_merge
{
    // merge:把多个信号合并成一个信号
    //创建多个信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

#pragma mark - 11. zipWith: 把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
- (void)p_zipWith
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    
    
    // 压缩信号A，信号B
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 底层实现:
    // 1.定义压缩信号，内部就会自动订阅signalA，signalB
    // 2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出
}

#pragma mark - combineLatest 12. 将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
- (void)combineLatest
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 聚合
    // 常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    // reduce中的block简介:
    // reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    // reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA,signalB] reduce:^id(NSNumber *num1 ,NSNumber *num2){
        
        return [NSString stringWithFormat:@"%@ %@",num1,num2];
        
    }];
    
    [reduceSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end









































