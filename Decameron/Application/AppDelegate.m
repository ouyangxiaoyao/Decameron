//
//  AppDelegate.m
//  Decameron
//
//  Created by 李璐 on 16/3/3.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import "AppDelegate.h"
#import "LLDecaRootController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //使用缓存策略，我们需要缓存路径
    NSString * pathRaw = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    //拼接路径
    NSString * path = [pathRaw stringByAppendingPathComponent:@"lCreateCache"];
    NSURLCache * cache = [[NSURLCache alloc]initWithMemoryCapacity:2 * 1024 * 1024 diskCapacity:100 * 1024 * 1024 diskPath:path];
    [NSURLCache setSharedURLCache:cache];
    
    
    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [window makeKeyAndVisible];
    
    LLDecaRootController * contrl = [[LLDecaRootController alloc]init];
    window.rootViewController = contrl;
    
    return YES;
}



@end
