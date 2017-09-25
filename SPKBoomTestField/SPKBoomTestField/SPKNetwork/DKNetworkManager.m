//
//  DKNetworkManager.m
//  DKNetwork
//
//  Created by 刘康09 on 2017/8/29.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "DKNetworkManager.h"
#import "NonZeroingURLCache.h"
#import "DKNetworkResponse.h"
#import "NSObject+JSON.h"

@interface DKNetworkManager ()  <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionStreamDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSOperationQueue *sessionDelegateQueue;

@end

@implementation DKNetworkManager

#pragma mark - public

+ (instancetype)manager {
    static DKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DKNetworkManager alloc] init];
    });
    return manager;
}

- (void)getRequestWithURLString:(NSString *_Nullable)URLString
                        success:(DKNetworkRequestSuccessBlock _Nullable)success
                           fail:(DKNetworkRequestFailBlock _Nullable)fail {
    //NSURLSessionDataTask不提供任何与NSURLSessionTask额外的 的功能和它的存在只是 为下载和上传任务提供词汇区分。
    //由会话创建会话任务 默认一开始创建的会话任务是暂停状态的，所以在创建后需要调用请求发起
    
    //去重的话 暂时用url来判断吧。。
    //使用代理operationQueue的话，每个请求都会创建一个operation放入其中，猜测上。
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:[self p_urlRequestWithURLString:URLString HTTPMethod:DKNetworkRequestHTTPMethodTypeGET paramDictionary:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //请求的回调的线程是在 自己设置的DelegateQueue中，这是被开创出来的一个子线程。
        //dingding! 果然是这样 在自己定制的子线程中进行请求，回调依旧在子线程内，NSURLSessionDataTask并没有把放回主线程，这样提供了更大的便利性
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (fail) {
                    fail(error);
                }
                return;
            }
            
            DKNetworkResponse *DKResponse = [[DKNetworkResponse alloc] initWithData:data URLResponse:response];
            if (DKResponse.error) {
                if (fail) {
                    fail(error);
                }
                return;
            }
            if (success) {
                success(DKResponse);
            }
        });
    }];
    [dataTask resume];
}

- (void)postRequestWithURLString:(NSString *_Nullable)URLString
                           param:(NSDictionary *)paramDictionary
                         success:(DKNetworkRequestSuccessBlock _Nullable )success
                            fail:(DKNetworkRequestFailBlock _Nullable )fail {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:[self p_urlRequestWithURLString:URLString HTTPMethod:DKNetworkRequestHTTPMethodTypePOST paramDictionary:paramDictionary] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (fail) {
                    fail(error);
                }
                return;
            }
            
            DKNetworkResponse *DKResponse = [[DKNetworkResponse alloc] initWithData:data URLResponse:response];
            if (DKResponse.error) {
                if (fail) {
                    fail(error);
                }
                return;
            }
            if (success) {
                success(DKResponse);
            }
        });
    }];
    [dataTask resume];
}

- (void)uploadRequestWithURLString:(NSString *_Nullable)URLString
                              data:(NSData *_Nullable)data
                           success:(DKNetworkRequestSuccessBlock _Nullable)success
                              fail:(DKNetworkRequestFailBlock _Nullable)fail {
    //还可以上传文件 另一个方法 理论上用POST？
    //NSURLSessionUploadTask目前不提供任何超过NSURLSessionDataTask的附加功能 功能，所有委托消息可能发送的引用NSURLSessionDataTask同样适用到NSURLSessionUploadTasks。
//    NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:[self p_urlRequestWithURLString:URLString HTTPMethod:DKNetworkRequestHTTPMethodTypePOST] fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            if (fail) {
//                fail(error);
//            }
//            return;
//        }
//        
//        if (success) {
//            success(data, response);
//        }
//    }];
//    [uploadTask resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    //遇到错误 无效
    NSLog(@"%@", error.description);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    //遇到挑战了。 需要用credential认证挑战响应 其用于创建信任，用户名/密码组合和客户端证书。
    //会话遇到验证
    //验证服务器通信
    //这里的端口号指定443 具体在6.1章 这里的验证就是 AuthenticationChallenge 方法里的了 这种特定的验证会确保应用只与指定的服务器进行通信，如果发现处于恶意网络之上，传输被重新路由到第三方服务器，那么保护空间验证就会因不匹配的主机而失败，后续的通信也会终止。更为重要的是，登录认证信息，银行账号等信息是绝不会传输的。
    //第六章
    NSURLProtectionSpace *defaultSpace = [[NSURLProtectionSpace alloc] initWithHost:@"yourNeedProtectDomain.com"
                                                                               port:443
                                                                           protocol:NSURLProtectionSpaceHTTPS
                                                                              realm:@"mobile"
                                                               authenticationMethod:NSURLAuthenticationMethodDefault];
    
    NSURLProtectionSpace *trustSpace = [[NSURLProtectionSpace alloc] initWithHost:@"yourNeedProtectDomain.com"
                                                                             port:443
                                                                         protocol:NSURLProtectionSpaceHTTPS
                                                                            realm:@"mobile"
                                                             authenticationMethod:NSURLAuthenticationMethodClientCertificate];
    NSArray *validSpaces = @[defaultSpace, trustSpace];
    if (![validSpaces containsObject:challenge.protectionSpace]) {
        //不安全的链接 做一些UI上的提示什么的
        
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
    else {
        //验证通过
//        completionHandler()
    }
    
    //针对 HTTP Basic HTTP Digest NTLM认证的响应逻辑是相同的 140
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic) {
        if (challenge.previousFailureCount == 0) {
            // CredentialPersistence 凭证持久性
            // Credential 凭证
            NSURLCredential *creds = [[NSURLCredential alloc] initWithUser:@"1" password:@"2" persistence:NSURLCredentialPersistenceForSession];
            [challenge.sender useCredential:creds forAuthenticationChallenge:challenge];
        }
        else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
            
            //失败过一次了
        }
    }
    
    NSLog(@"challenge");
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    //与后台任务有关
    
}

#pragma mark - NSURLSessionTaskDelegate <NSURLSessionDelegate>

/*
 HTTP请求正在尝试执行到另一个网址的重定向，你必须完成block（completionHandler）来允许重定向，或者通过赋值为nil来拒绝重定向，默认值是允许重定向。这里的翻译有点问题
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    //url的重定向
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    //API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
}

#pragma mark - NSURLSessionDataDelegate <NSURLSessionTaskDelegate>

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {}

#pragma mark - NSURLSessionDownloadDelegate <NSURLSessionTaskDelegate>

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {}

#pragma mark - NSURLSessionStreamDelegate <NSURLSessionTaskDelegate>

- (void)URLSession:(NSURLSession *)session readClosedForStreamTask:(NSURLSessionStreamTask *)streamTask {}

- (void)URLSession:(NSURLSession *)session writeClosedForStreamTask:(NSURLSessionStreamTask *)streamTask {}

- (void)URLSession:(NSURLSession *)session betterRouteDiscoveredForStreamTask:(NSURLSessionStreamTask *)streamTask {}

- (void)URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask
didBecomeInputStream:(NSInputStream *)inputStream
      outputStream:(NSOutputStream *)outputStream {}

#pragma mark -- private

- (NSURLSessionConfiguration *)p_defaultSessionConfiguration {
    //初始化会话配置
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    ///第一次运行 这里crash
    ///-[NSURLSessionConfiguration setRequestCachePolicy:]: unrecognized selector sent to instance 0x60800001e6c0
    ///原因是 sessionConfig一开始使用 alloc init 初始化，后更改为 defaultSessionConfiguration，看来这里不能使用通常的初始化方法
    sessionConfig.requestCachePolicy = NSURLRequestUseProtocolCachePolicy; //缓存策略
    sessionConfig.timeoutIntervalForRequest = 3000; //毫秒
    sessionConfig.timeoutIntervalForResource = 3000; //毫秒
    sessionConfig.networkServiceType = NSURLNetworkServiceTypeDefault; // 请求类型 eg:video background
    sessionConfig.allowsCellularAccess = YES; //允许蜂窝网络请求
    sessionConfig.discretionary = YES; //允许系统可以调度后台任务以获得最佳性能
    sessionConfig.HTTPShouldUsePipelining = NO; //http://blog.csdn.net/dongzhiquan/article/details/6114040
    sessionConfig.HTTPShouldSetCookies = NO; //https://zh.wikipedia.org/wiki/Cookie
    sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain;
    
    return sessionConfig;
}

- (NSOperationQueue *)p_createOperationQueue {
    if (!self.sessionDelegateQueue) {
        self.sessionDelegateQueue = [[NSOperationQueue alloc] init];
        self.sessionDelegateQueue.maxConcurrentOperationCount = 20;
        self.sessionDelegateQueue.name = @"spk_networkrequest_session_delegate_queue";
        self.sessionDelegateQueue.qualityOfService = NSQualityOfServiceDefault; // 8.0api
    }
    return self.sessionDelegateQueue;
}

- (NSURLRequest *)p_urlRequestWithURLString:(NSString *)urlString HTTPMethod:(DKNetworkRequestHTTPMethodType)HTTPMethodType paramDictionary:(NSDictionary *)paramDictionary {
    //请求包含散三部分 请求行 请求头 请求体
    /*
     请求行：HTTP请求方法(GET POST HEAD PUT DELETE)，请求URL HTTP版本
     */
    
    //请求行设置 : HTTP请求方法 请求URL HTTP版本
    NSURL *URL = [NSURL URLWithString:urlString];
    if (!URL) {
        NSAssert(nil, @"URL Invalid");
        return nil;
    }
    
    //这里初始化也可以设置缓存策略 与sessionConfig中的设置 以及超时时间 优先级是怎样的呢 我猜测 URLRequest内的设置优先级更高。
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15000];
    [URLRequest setHTTPMethod:[self p_HTTPMethodWithType:HTTPMethodType]];
    
    if (!URLRequest) {
        NSAssert(nil, @"URLRequest Invalid");
        return nil;
    }
    
    [URLRequest addValue:@"QYC" forHTTPHeaderField:@"server-name"];
    
    //请求ID
    NSString *a = [[NSString alloc] initWithBytes:[@"xxx" UTF8String] length:3 encoding:NSUTF8StringEncoding];
    [URLRequest addValue:a forHTTPHeaderField:@"App-RequestId"];
    
    //请求头设置 有几个HTTP头使用的比较多。
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"]; //希望返回JSON文档。 1
    
    /* 2
     NSString *basicBody = [NSString stringWithFormat:@"%@:%@", @"lk", @"123456"];
    NSData *authData = [basicBody dataUsingEncoding:NSASCIIStringEncoding];
    //对authData用Base64加密 变成另一个b64data
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", b64Data];
    [URLRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
     */
    
    //3 User-Agent 创建它的目的是为HTTP服务器识别出浏览器类型。在很多企业网络中，user agent用于根据浏览器类型将访问转向特定的服务器。有些HTTP服务器会根据User agent值修改响应内容。 默认情况下，来自应用的user agent 会包含应用产品名与版本，网络框架与版本，以及OS名与版本。
    
    //4 自定义头
    
    //请求体设置
    //有两种方式可以向NSURLRequst提供HTTP体，在内存中或者通过NSInputStream 代码可以通过输入流提供请求体而无须将整个体加载到内存中去。
    //输入流适合发送图片或者视频等大容量的内容。
//    NSInputStream *inputStream = [NSInputStream inputStreamWithData:nil];
//    [URLRequest setHTTPBodyStream:inputStream];
    
    if (paramDictionary) {
        // 字典-> 字符串拼接 -> dataUsingEncoding:
        
        NSString *jsonString = [paramDictionary JSONString];
        NSData *bodyData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
//        NSError *error = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDictionary options:NSJSONWritingPrettyPrinted error:&error];
//        if (error) {
//            NSAssert(nil, @"paramDictionary Invalid");
//            return nil;
//        }
        [URLRequest setHTTPBody:bodyData];
    }
    
    //开启管道支持 使用这种方式需要对目标服务器进行广泛测试，因为并非所有的服务器都支持HTTP管道 Apache 与 IIS 都支持管道，无需任何额外配置
    
    //p180 牛逼了 缓存的实质， 这里说的很透彻 设置缓存
    [URLRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    //在应用使用任何标准的iOS类创建网络请求时，系统都会创建NSURLCache实例，在默认情况下，该实例只会将数据缓存在RAM中，这意味着当程序退出时，其缓存的请求就会被清空，当设备处于低内存状态时也会清空RAM缓存。
    
    //创建1MB的内存缓存和20MB的持久化缓存，缓存数据库的位置位于应用的沙箱 在Library/Caches目录下，文件名为URLCache
    //PS iOS中有一个奇怪的现象，即在某些情况下，应用中的系统组件会将缓存的内容容量设为0MB，这就禁用了缓存，解决这个无法解释的行为的一种方式就是通过自己的实现子类化NSURLCache，拒绝讲内存缓存大小设置为0.
    NonZeroingURLCache *cache = [[NonZeroingURLCache alloc] initWithMemoryCapacity:1024 * 1024 diskCapacity:1024 * 1024 * 20 diskPath:@"URLCache"];
    [NSURLCache setSharedURLCache:cache];
    
    //管道是要看是否支持
//    [URLRequest setHTTPShouldUsePipelining:YES];
    
    return URLRequest;
}

//- (NSURLRequest *)p_uploadFileWithURLString:(NSString *)urlString HTTPMethod:(DKNetworkRequestHTTPMethodType)HTTPMethodType

- (void)p_logResponse:(NSURLResponse *)response {
    //响应体 包含三部分 状态行 状态投 响应体
    //状态行分为 响应的HTTP版本 以及表示请求结果的状态值 首先是一个三位数的整数值，包含请求的结果代码。最后是条说明短语，提供关于代码的简短文本说明。
    //响应头 包含了数据的上一次修改时间，客户端可以缓存数据多长时间，数据的编码方式以及在随后的请求中提交的状态信息。
    //响应体 可以包含任意数量的二进制字符。 与客户端通信的响应体的长度可以通过请求的Content-Lengtht头或通过编码提现。
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%d", (int)HTTPURLResponse.statusCode);
        NSLog(@"allHeaderFields = %@", HTTPURLResponse.allHeaderFields);
        NSLog(@"MIME : %@", HTTPURLResponse.MIMEType);
        NSLog(@"expectedContentLength : %@", @(HTTPURLResponse.expectedContentLength));
        NSLog(@"textEncodingName : %@", HTTPURLResponse.textEncodingName);
    }
}

- (NSString *)p_HTTPMethodWithType:(DKNetworkRequestHTTPMethodType)type {
    NSString *method = @"GET";
    switch (type) {
        case DKNetworkRequestHTTPMethodTypeGET:
            method = @"GET";
            break;
        case DKNetworkRequestHTTPMethodTypePOST:
            method = @"POST";
            break;
        case DKNetworkRequestHTTPMethodTypeHEAD:
            method = @"HEAD";
            break;
        case DKNetworkRequestHTTPMethodTypePUT:
            method = @"PUT";
            break;
        case DKNetworkRequestHTTPMethodTypeDELETE:
            method = @"DELETE";
            break;
        default:
            method = @"GET";
            break;
    }
    return method;
}

#pragma getter or setter

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[self p_defaultSessionConfiguration]
                                                                        delegate:self
                                                                   delegateQueue:[self p_createOperationQueue]];
        _session.sessionDescription = @"test_session_description";
    }
    return _session;
}

@end
