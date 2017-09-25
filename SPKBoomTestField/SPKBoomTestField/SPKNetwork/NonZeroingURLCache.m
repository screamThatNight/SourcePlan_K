//
//  NonZeroingURLCache.m
//  DKNetwork
//
//  Created by 刘康09 on 2017/9/1.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "NonZeroingURLCache.h"

@implementation NonZeroingURLCache

- (void)setMemoryCapacity:(NSUInteger)memoryCapacity {
    if (memoryCapacity == 0) {
        NSLog(@"Attempt to set cache size to 0");
        return;
    }
    [super setMemoryCapacity:memoryCapacity];
}

//网络的根本是Berkley 或 BSD Sockets。它执行大多数技术的网络任务：发送与接收一系列的二进制位。 在iOS上，Core Foundation networking 或 CFNetwork，它是对原始Socket的轻量级封装，不过它很快对大多数常见场景来说就变得非常笨重了，最后，添加了另一层(NSStream)来封装CGNetwork，并且作为最基础的Objective-C网络API。

//第八章 讲的非常好 TCP握手 第八章说了BSD Socket CFNetwork 与 NSSteam

//第九章 测试与操纵网络流量 观测网络流量的行为叫做嗅探或数据包分析。数据包分析器从网络早期就已经存在了，并且可以用于几乎每一种类型的物理互联与协议。通过HTTP代理来模拟错误
// 通过Charles抓包

//第十章 使用推送通知 本地通知与远程通知

//第十一章 应用件网络通信

//使用GameKit 实现设备间通信
@end
