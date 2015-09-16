//
//  ServerListInfo.m
//  VPN Gate
//
//  Created by Steven on 15/8/24.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ServerListInfo.h"
#import <AFNetworking.h>
#import <NSObjectExtend.h>

#define SERVER_INFO_URL @"https://github.com/waylau/vpngate-mirrors/raw/master/README.md"

@implementation ServerListInfo

+ (void)getServerList:(void(^)(NSArray<ServerListInfo *> * list))block;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_INFO_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 存在数据解析，不可能执行到这里
        NSLog(@"成功");
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Json解析失败，回调到此
        
        // 解析
        NSString * dataString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n   " withString:@" "];
        NSArray <NSString *> * tmp = [dataString componentsSeparatedByString:@"##List 列表"];
        if (tmp.count != 2) { block(nil); return; }
        tmp = [tmp[1] componentsSeparatedByString:@"VPN Gate 源 (主) 网站 URL"];
        if (tmp.count != 2) { block(nil); return; }
        tmp = [tmp[0] componentsSeparatedByString:@"\n"];
        if (tmp.count == 0) { block(nil); return; }
        
        NSMutableArray * items = [NSMutableArray array];
        NSDate * updateDate = nil;
        NSString * name = nil;
        NSString * host = nil;
        ServerListInfo * info = nil;
        for (NSString * str in tmp)
        {
            
            if (str.length > 2)
            {
                if ([str rangeOfString:@"http://"].location != NSNotFound)
                {
                    // 获取镜像服务器列表
                    
                    name = nil;
                    host = nil;
                    
                    tmp = [str componentsSeparatedByString:@" (Location: "];
                    if (tmp.count == 2)
                    {
                        NSArray <NSString *> * arr = [tmp[0] componentsSeparatedByString:@". "];
                        if (arr.count == 2)
                        {
                            host = arr[1];
                        }
                        name = [tmp[1] stringByReplacingOccurrencesOfString:@")" withString:@""];
                    }
                    
                    info = [[ServerListInfo alloc] init];
                    info.name = name;
                    info.host = host;
                    info.updateDate = updateDate;
                    [items addObject:info];
                }
                else
                {
                    // 获取更新时间
                    tmp = [str componentsSeparatedByString:@"(更新于"];
                    if (tmp.count == 2)
                    {
                        updateDate = [NSDate dateWithString:tmp[1] withFormat:@"yyyy-MM-dd HH:mm)"];
                    }
                }
            }
        }
        
        block([NSArray arrayWithArray:items]);
    }];

}

@end
