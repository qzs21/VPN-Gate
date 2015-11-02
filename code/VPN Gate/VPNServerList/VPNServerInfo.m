//
//  VPNServerInfo.m
//  VPN Gate
//
//  Created by Steven on 15/8/20.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "VPNServerInfo.h"
#import <TFHpple.h>
#import "NSString+URLParams.h"

@implementation VPNServerInfo

+ (instancetype)objectWithTFHppleElement:(TFHppleElement *)element withURL:(NSURL *)url;
{
    VPNServerInfo * info = [[VPNServerInfo alloc] init];
 
    TFHppleElement * e = nil; // temp TFHppleElement
    
    NSArray * tdItems = [element childrenWithTagName:@"td"];
    
    if (tdItems.count != 10) { return nil; }
    
    for (NSInteger i = 0; i < 10; i++)
    {
        e = tdItems[i];
        switch (i)
        {
            case 0: // 国家/地区(物理位置)
            {
                NSString * path = [[e firstChildWithTagName:@"img"].attributes[@"src"] stringByRemovingPercentEncoding];
                // 没有国家logo，不是服务器配置信息
                if (path.length == 0) { return nil; }

                info.countryImageURL = [url URLByAppendingPathComponent:path];
                
                info.countryName = [e firstChildWithTagName:@"text"].content;
                
                break;
            }
            case 1: // DDNS 主机名 IP 地址 (ISP 主机名)
            {
                info.IP = [[[e firstChildWithTagName:@"b"] firstChildWithTagName:@"span"] firstChildWithTagName:@"text"].content;
                break;
            }
            case 2: // VPN 会话数 运行时间 累计用户数
            {
                break;
            }
            case 3: // 线路质量 吞吐量和 Ping 累积转移 日志策略
            {
                NSArray * bItems = [e childrenWithTagName:@"b"];
                
                if (bItems.count != 3)
                {
                    return nil;
                }
                info.bandwidth = [[bItems.firstObject firstChildWithTagName:@"span"] firstChildWithTagName:@"text"].content;
                NSString * ping = [[[bItems[1] firstChildWithTagName:@"text"] content] stringByReplacingOccurrencesOfString:@"ms" withString:@""];
                if ([ping isEqualToString:@"-"])
                {
                    info.ping = -1;
                }
                else
                {
                    info.ping = ping.integerValue;
                }
                info.cumulativeTransfer = [[bItems[2] firstChildWithTagName:@"text"] content];
                break;
            }
                case 4: // SSL-VPN Windows (合适的)
            {
                break;
            }
            case 5: // L2TP/IPsec Windows, Mac, iPhone, Android 无需 VPN 客户端
            {
                break;
            }
            case 6: // OpenVPN Windows, Mac, iPhone, Android
            {
                NSString * path = [[e firstChildWithTagName:@"a"].attributes[@"href"] stringByRemovingPercentEncoding];
                if (path.length == 0) { continue; }
                
                info.openVPN_URL = [url URLByAppendingPathComponent:path];
                
                // 解析下载地址参数
                NSDictionary * params = path.params;
                
                // TCP 方式链接，配置文件下载地址
                if ([params[@"tcp"] length])
                {
                    path = [NSString stringWithFormat:@"/common/openvpn_download.aspx?sid=%@&tcp=1&host=%@&port=%@&hid=%@&/vpngate_%@_tcp_%@.ovpn",
                            params[@"sid"],
                            params[@"ip"],
                            params[@"tcp"],
                            params[@"hid"],
                            params[@"ip"],
                            params[@"tcp"]];
                    
                    NSURLComponents * components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
                    components.path = path;
                    info.openVPN_TCP_OVPN_URL = components.URL;
                }
                
                // UDP 方式链接，配置文件下载地址
                if ([params[@"udp"] length])
                {
                    path = [NSString stringWithFormat:@"/common/openvpn_download.aspx?sid=%@&udp=1&host=%@&port=%@&hid=%@&/vpngate_%@_udp_%@.ovpn",
                            params[@"sid"],
                            params[@"ip"],
                            params[@"udp"],
                            params[@"hid"],
                            params[@"ip"],
                            params[@"udp"]];
                    
                    NSURLComponents * components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
                    components.path = path;
                    info.openVPN_UDP_OVPN_URL = components.URL;
                }
                break;
            }
            case 7: // MS-SSTP Windows Vista, 7, 8, RT 无需 VPN 客户端
            {
                break;
            }
            case 8: // 志愿者操作员的名字 (+ 操作员的消息)
            {
                break;
            }
            case 9: // 总分 (质量)
            {
                break;
            }
            default:
                break;
        }
    }
    return info;
}

/**
 *  解析服务器列表
 *
 *  @param htmlString   网站首页内容
 *  @param path         当前路径
 *
 *  @return VPN服务器列表
 */
+ (NSArray *)resloerServerList:(NSData *)htmlData withURL:(NSURL *)url;
{
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray * elements  = [doc searchWithXPathQuery:@"//table[@id='vg_hosts_table_id']/tr"];
    
    NSMutableArray * dataItems = [NSMutableArray array];
    
    // 遍历解析
    for (TFHppleElement * e in elements)
    {
        VPNServerInfo * info = [self objectWithTFHppleElement:e withURL:url];
        if (info)
        {
            [dataItems addObject:info];
        }
    }
    
    return [NSArray arrayWithArray:dataItems];
//    // 排序返回
//    return
//    [dataItems sortedArrayUsingComparator:^NSComparisonResult(VPNServerInfo * obj1, VPNServerInfo * obj2)
//     {
//         if (obj1.ping < 0)
//         {
//             return NSOrderedDescending;
//         }
//         if (obj2.ping < 0)
//         {
//             return NSOrderedAscending;
//         }
//         return obj1.ping < obj2.ping ? NSOrderedAscending : NSOrderedDescending;
//     }];
}


@end
