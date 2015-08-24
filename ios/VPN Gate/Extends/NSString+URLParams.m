//
//  NSString+URLParams.m
//  iAuto360
//
//  Created by Steven on 15/7/27.
//  Copyright © 2015年 Yamei. All rights reserved.
//

#import "NSString+URLParams.h"

@implementation NSString(NSString_URLParams)

// 给URL拼接参数
+ (NSString *)setGetParam:(NSDictionary *)param withURL:(NSString *)url
{
    NSString * s = nil;
    if ([url rangeOfString:@"?"].location == NSNotFound)
    {
        s = @"?";
    }
    else
    {
        s = @"&";
    }
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * key in param.allKeys)
    {
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, param[key]]];
    }
    return [NSString stringWithFormat:@"%@%@%@", url, s, [array componentsJoinedByString:@"&"]];
}

// 读取URL的参数 如: @"status=2&tag=3" ==> 返回: @{@"status": @"2", @"tag": @"3"}
- (NSDictionary *)params
{
    // 获取参数字符串
    NSArray * items = [self componentsSeparatedByString:@"?"];
    NSString * paramString = nil;;
    if (items.count == 1)
    {
        paramString = self;
    }
    if (items.count >= 2)
    {
        paramString = items[1];
    }

    // 获取参数
    items = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSArray * tmp = nil;
    NSString * value = nil;
    for (NSString * p in items)
    {
        tmp = [p componentsSeparatedByString:@"="];
        value = @"";
        if (tmp.count == 2)
        {
            value = tmp[1];
        }
        [params setObject:value forKey:tmp[0]];
    }
    return [NSDictionary dictionaryWithDictionary:params];
}


@end
