//
//  NSString+URLParams.h
//  iAuto360
//
//  Created by Steven on 15/7/27.
//  Copyright © 2015年 Yamei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NSString_URLParams)

/**
 *  获取URL里面的参数
 */
@property (nonatomic, readonly) NSDictionary * params;

/**
 *  给URL拼接参数
 *
 *  @param param 参数
 *  @param url   URL
 *
 *  @return 拼接好的URL
 */
+ (NSString *)setGetParam:(NSDictionary *)param withURL:(NSString *)url;

@end
