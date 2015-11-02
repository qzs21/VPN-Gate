//
//  VPNServerInfo.h
//  VPN Gate
//
//  Created by Steven on 15/8/20.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFHppleElement;

@interface VPNServerInfo : NSObject

// 国家/地区(物理位置)
@property (nonatomic, strong) NSString * countryName;       ///< 国家名字
@property (nonatomic, strong) NSURL * countryImageURL;   ///< 国家logo

// DDNS 主机名 IP 地址 (ISP 主机名)
@property (nonatomic, strong) NSString * IP;                ///< 服务器IP

// VPN 会话数 运行时间 累计用户数
@property (nonatomic, assign) NSInteger sessionCount;       ///< 会话数
@property (nonatomic, assign) NSTimeInterval runningTime;   ///< 运行时间
@property (nonatomic, assign) NSInteger totalUsers;         ///< 累计用户


// 线路质量 吞吐量和 Ping 累积转移 日志策略
@property (nonatomic, strong) NSString * bandwidth;         ///< 带宽
@property (nonatomic, assign) NSInteger ping;               ///< ping值(ms), ping=-1：无ping值
@property (nonatomic, strong) NSString * cumulativeTransfer;///< 累积转移(数据总吞吐量)
//@property (nonatomic, strong) NSString * logStrategy; ///< 日志策略


// SSL-VPN Windows (合适的)


// L2TP/IPsec Windows, Mac, iPhone, Android 无需 VPN 客户端

// OpenVPN Windows, Mac, iPhone, Android
@property (nonatomic, strong) NSURL * openVPN_URL; ///< OpenVPN信息页面URL
@property (nonatomic, strong) NSURL * openVPN_TCP_OVPN_URL; ///< tcp配置信息
@property (nonatomic, strong) NSURL * openVPN_UDP_OVPN_URL; ///< udp配置信息

// MS-SSTP Windows Vista, 7, 8, RT 无需 VPN 客户端

// 志愿者操作员的名字 (+ 操作员的消息)
@property (nonatomic, strong) NSString * volunteerOperatorName;

// 总分 (质量)
@property (nonatomic, assign) double * score;

/**
 *  解析服务器列表
 *
 *  @param htmlString   网站首页内容
 *  @param path         当前路径
 *
 *  @return VPN服务器列表
 */
+ (NSArray *)resloerServerList:(NSData *)htmlData withURL:(NSURL *)url;

@end
