//
//  ServerListInfo.h
//  VPN Gate
//
//  Created by Steven on 15/8/24.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  (镜像)服务器列表
 */
@interface ServerListInfo : NSObject

@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong) NSString * host;

@property (nonatomic, strong) NSDate * updateDate;

+ (void)getServerList:(void(^)(NSArray<ServerListInfo *>* list))block;

@end
