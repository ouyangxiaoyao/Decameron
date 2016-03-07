//
//  QFNetHelp.h
//  jianzhi
//
//  Created by 王广威 on 16/2/20.
//  Copyright © 2016年 北京千锋-王广威. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QFNetHelp : AFHTTPSessionManager

// 封装 Get 请求，成功和失败分开处理
+ (void)getDataWithParam:(NSDictionary *)params andPath:(NSString *)path andComplete:(void (^)(BOOL success, id result))complete;

// 封装 Post 请求，成功和失败在一个 block 里面处理
+ (void)postWithParam:(NSDictionary *)params andPath:(NSString *)path andComplete:(void (^)(BOOL success, id result))complete;

@end

