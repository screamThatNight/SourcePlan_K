//
//  SPKGGG.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/10/27.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "SPKGGG.h"

//class-Continuration分类，特殊的分类，与一般分类不同，其申明在实现文件内，并且其内申明的属性与方法均在主实现文件内实现。~ ~ 唔！终于知道你的学名了 我日，读书果然有用！！！

//与普通唯一不同的是，这是唯一可以申明实例变量的分类，普通创建的类的分类并不能申明实例变量，但是并不是不可以哦，借由runtime的运行时特性还是可以的。
@interface SPKGGG () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *sv;

- (void)p_aaa; //

@end

@implementation SPKGGG {
    NSArray *_aa;
}


- (void)p_aaa {
    ///
    _aa = @[];
}

//51

//所有类以及分类中被实现的load方法在程序启动都会被执行
//同一个类以及分类中都实现了load方法的话，优先执行类中load方法，再执行分类中的load方法 -> 这里与runtime息息相关
//类与父类分开，如果该类没有实现load方法，无论父类是否实现都不会执行。
//load方法中不要去调用其他的类，比如创建A类，因为每个类的load方法的调用时机是未知的
//load方法要尽可能精简，减少其中的操作，因为整个应用程式在执行load方法时会阻塞。

//什么时候用？？？
//一般用于调试用，比如在分类中编写该方法，用于判断该分类是否已经正确载入系统中。也许该方法一度很有用，但是时下编写OC代码时，不需要用到。

+ (void)load {
    //
    [super load];
    
    NSLog(@"11");
}

//对于每个类来说，该方法会在程序首次用该类之前调用，而且在整个程序生命周期之内只会调用一次。这个与load方法有极大的差别了，load是只要实现了就会调用，并且在程序启动后必执行一次，无论该类是否被调用。
//重要区别1：惰性调用 -> 只有程序用到这个类，才会调用它。而Load不同，应用程序必须阻塞并且等待所有的类的load都执行完，才能继续，注意 load是会阻塞的。
//重要区别2：运行期间执行该方法时是出于正常状态的，所以从运行系统完整度上讲，此时可以安全使用并且调用任意类中的任意方法，这与load区别大了，load中不能调用任意类的任意方法，因为load的加载顺序是未知的，如果在load里面调用A类，此时A类也许还没加载到系统里，会出问题。(我这样理解貌似有点不妥)
//区别3：如果子类中没有实现initialize方法，而父类中实现了，那么在调用子类的时候，也会调用到父类的initialize方法。比如父类A在该方法中打印1，其子类AA没有实现，在调用子类时也会打印出1.所以鉴于这个特性，一般而言只期望执行针对本类而做操作就需要做一层判断

//这里不需要调用super，一样会执行父类的initialize方法
+ (void)initialize {
    if ([self isKindOfClass:[SPKGGG class]]) {
        NSLog(@"SPKGGG");
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
    
}

- (void)setNeedsUpdateOfHomeIndicatorAutoHidden {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 48 Object-C 1.0特性 NSEnumerator
    //这种写法，虽然看起来跟for循环类似，甚至代码多一点，但是它的真正优势在与，不论遍历那种collection，都可以采用这套相似的语法。
//    NSArray *array = @[@"1", @"2", @"3", @"4", @"5"];
//    NSEnumerator *arrEnum = [array objectEnumerator]; //正序 reverseObjectEnumerator是反序
//    id arrObj;
//    while ((arrObj = [arrEnum nextObject]) != nil) {
//        //do sth with obj
//        NSLog(@"%@", arrObj);
//    }
//    NSLog(@"end");
    
//    NSDictionary *dic = @{@"a" : @"1",
//                          @"b" : @"2",
//                          @"c" : @"3",
//                          @"d" : @"4"};
//    NSEnumerator *dicEnum = [dic objectEnumerator];//在遍历字典时，不应当使用objectEnumerator
//    NSEnumerator *dicEnum = [dic keyEnumerator]; //去键遍历
//    id dicObj;
//    while ((dicObj = [dicEnum  nextObject]) != nil) {
//        NSLog(@"%@", dicEnum);
//    }
//    NSLog(@"end");

    //object 2.0语言中的for in
    //最终更为方便的块枚举 enumeratorObjectWithBlock:
    
    //
    //50:比NSDictionary更适合充当缓存的NSCache
//    NSCache
    
    //如果多个线程要执行同一份代码，要么有可能回出现问题，一般会使用锁来实现某种同步机制。
    //1
//    @synchronized(self) {
//        //safe
//    }
//
//    NSLock *lock = [[NSLock alloc] init];
//    [lock lock];
//    //safe
//    [lock unlock];
//
//    //递归锁
//    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc] init];
//    [recursiveLock lock];
//    //safe
//    [recursiveLock unlock];
//
//    //替代方案 GCD -> 串行同步队列 将读取操作与写入操作都安排在同一个队列里，即可保证数据同步。 C语言
//    //DISPATCH_QUEUE_CONCURRENT
//    dispatch_queue_t serialQueue = dispatch_queue_create("com.spk.syncQueue", NULL);
//    //
//    dispatch_sync(serialQueue, ^{
//        NSLog(@"1");
//    });
//    [serialQueue release]; //需要手动release 貌似已经不需要release了？
    
    //同步方法不会立刻返回，必须执行完后再执行接下来的代码
    //异步方法会立刻返回，不会阻塞接下来的代码执行。
    
    //串行队列 并行队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
    });
    NSLog(@"11");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2");
    });
    NSLog(@"22");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"3");
    });
    NSLog(@"33");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"4");
    });
    
    //calss-continuation分类 我草草草草草哦啊哦啊从！！这个是面试时候问到我的。首先这玩意是分类，其次与其他一般分类不同的时候，它是接续在.m实现文件里面的分类，也就是通常我写在上面的@interface，这也就解释了为什么一开始创建了类文件，在.m实现文件中并没有@interface而只有@implementation，它最重要的特性在与，这是唯一能声明实例变量的分类。而且此分类没有特定的实现文件，其中的方法都应该定义在类的主实现文件里。
    /*
    @interface a ()
    //aa
    @end
     */
    
    //栅栏block 不与其他块并行执行的块
//    dispatch_barrier_async_f(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), nil, <#dispatch_function_t  _Nonnull work#>)
    
    //在dealloc方法中只释放引用并解除监听
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    //
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    //只有在第一次有变化时才会触发viewSafeAreaInsetsDidChange 与 viewDidLayoutSubviews方法，后续如果设置了无变化，是不会继续触发第二次，第三次的。
//    self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    NSLog(@"viewDidLayoutSubviews");
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"%@", self.view.safeAreaLayoutGuide);
//    NSLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
//    NSLog(@"\n");
//
//    //safeAreaLayoutGuide中的layoutFrame是建议范围，里面已经根据safeAreaInsets计算好了应该布局的最大位置。
//}
//
//- (void)viewSafeAreaInsetsDidChange {
//    [super viewSafeAreaInsetsDidChange];
//    NSLog(@"----- log -----");
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"%@", self.view.safeAreaLayoutGuide);
//    NSLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
//}

@end
