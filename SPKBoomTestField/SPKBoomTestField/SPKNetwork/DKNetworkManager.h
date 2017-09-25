//
//  DKNetworkManager.h
//  DKNetwork
//
//  Created by 刘康09 on 2017/8/29.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKNetworkResponse.h"

// 模型与字典的互相转化。后期还是要加

typedef NS_ENUM(NSInteger, DKNetworkRequestHTTPMethodType) {
    DKNetworkRequestHTTPMethodTypeGET    = 1 << 1, // GET请求不应该包含HTTP体，只应该包含请求行与请求头。根据约定，GET请求不应该导致服务器上的数据发生任何变化
    DKNetworkRequestHTTPMethodTypePOST   = 1 << 2, // POST请求用来更新服务器上的数据 iOS通常使用POST请求向服务器发送XML或JSON数据。
    DKNetworkRequestHTTPMethodTypeHEAD   = 1 << 3, // HEAD请求会指示HTTP服务器只返回关于所请求资源的HTTP头信息。HEAD请求通常没有请求体，也没有响应体，也没有响应返回，它们常常用于验证缓存的数据与服务器上的数据，同时又不必获取缓存资源的整个内容。
    DKNetworkRequestHTTPMethodTypePUT    = 1 << 4, // PUT类似于POST，因为它总是有请求体，但是有如下重要差别：PUT请求用于向服务器添加新的资源，而POST只会用于更新服务器上的资源。
    DKNetworkRequestHTTPMethodTypeDELETE = 1 << 5
};

/*
 Cookie的处理暂时不加，以后需要加 从72页看。
 Cookie 72页 它是HTTP协议首个版本之后加入的一个重要组件。它向服务器提供了追踪回话状态的能力，同时又无须维持客户端与服务器之间的连接。
 应用经常用到cookie的3个地方：检索Cookie值，显示删除Cookie以及手工将Cookie添加到请求中。
 URL加载系统提供了两个重要对象以管理Cookie， NSHTTPCookie 与 NSHTTPCookieStorage。
 */

/*
 P77 管理从应用中发出的头信息是非常重要的 SOAP 与 REST架构，REST更适合移动端的传输
 负载 指的是在服务的请求响应事务中交换的数据。比如 POST请求中，负载指的就是请求体。
 XML iOS自带两种原生XML解析器 NSXMLParser libxml 这里XML与HTML数据的解析可以写出来 分别在 p93~97之间 后期可加 针对响应体的解析
 HTML 一个三方库 HTMLNode
 JSON iOS自带的 NSJSONSerialization P99里对type做了详细的解释。
 {
 NSJSONReadingAllowFragments : 告诉解析器处理既不是NSArray 也不是 NSDictionary的顶层对象，这个选项可以处理诸如{"user" : null} 这样的简单JSON结构。
 NSJSONReadingMutableContainers : 告诉解析器生成NSMutableArray 与 NSMutableDictionary对象。可变对象意味着可以通过方法修改它们。
 NSJSONReadingMutableLeaves : 告诉解析器生成NSMutableString对象，如果要在进一步处理前操纵被解析的响应中的某个特定值，那么可以使用该选项。
 }
 
 生成请求负载 -> P102 iOS5提供了一个原生API，用于从Foundation对象创建JSON数据。NSJSONSerialization 
 option NSJSONWritingPrettyPrinted 告诉方法通过添加空白来生成更易读的JSON。不指定该选项则会生成尽可能紧凑的JSON。
 P102写的很好
 
 XML iOS自带的用于生成XML的原生唯一API 跟随其后 暂时不研究。 跳过
 
 P111 网络错误的解析与原因。 -> 网络的分层。 这里其实算做一个小高潮，系统的讲解了传输的过程 请求错误的原因。
 P112 传递定制NSError 这里讲的很好。
 */

/*
 网络状态的检测 Reachability 能用它做的事是很多的，比如检测当前网络状态，查看网络上某个特定主机是否可达。(这个特性对目标主机的访问有个来回，如果每个请求都使用这个特性，会极大的增加应用的网络负载与延迟。)
 */

typedef void(^DKNetworkRequestSuccessBlock)(DKNetworkResponse * _Nullable response);
typedef void(^DKNetworkRequestFailBlock)(NSError * _Nullable error);

// 1.0:网络请求管理类
@interface DKNetworkManager : NSObject

//禁止使用init方法 有个宏定义 忘了 以后加
+ (instancetype _Nullable )manager;

- (void)getRequestWithURLString:(NSString *_Nullable)URLString
                        success:(DKNetworkRequestSuccessBlock _Nullable )success
                           fail:(DKNetworkRequestFailBlock _Nullable )fail;

- (void)postRequestWithURLString:(NSString *_Nullable)URLString
                           param:(NSDictionary *_Nullable)paramDictionary
                         success:(DKNetworkRequestSuccessBlock _Nullable )success
                            fail:(DKNetworkRequestFailBlock _Nullable )fail;

//- (void)headRequest

//上传文件
- (void)uploadRequestWithURLString:(NSString *_Nullable)URLString
                              data:(NSData *_Nullable)data
                           success:(DKNetworkRequestSuccessBlock _Nullable)success
                              fail:(DKNetworkRequestFailBlock _Nullable)fail;

@end
