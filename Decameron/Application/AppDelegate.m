//
//  AppDelegate.m
//  Decameron
//
//  Created by 李璐 on 16/3/3.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import "AppDelegate.h"
#import "LLDecaRootController.h"

//网络监控
#import "AFNetworking.h"
#import "SVProgressHUD.H"
//微信
#import "WXApi.h"

//环信

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //launchimage

    //使用缓存策略，我们需要缓存路径
    NSString * pathRaw = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    //拼接路径
    NSString * path = [pathRaw stringByAppendingPathComponent:@"lCreateCache"];
    NSURLCache * cache = [[NSURLCache alloc]initWithMemoryCapacity:2 * 1024 * 1024 diskCapacity:100 * 1024 * 1024 diskPath:path];
    [NSURLCache setSharedURLCache:cache];
    
    
    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    self.window = window;
    //启动控制器
    LLDecaRootController * contrl = [[LLDecaRootController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:contrl];
    nav.navigationBar.hidden = YES;
    nav.navigationBarHidden  = NO;
    window.rootViewController = nav;
    
    [self setupLaunchImage];

    // 注册微信
    [WXApi registerApp:@"wxcb7317378313570d"];
    

    

    return YES;
}

- (void)setupLaunchImage
{
    NSString *launchImage = @"launchimg";
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = self.window.bounds;
    launchView.contentMode = UIViewContentModeScaleToFill;
    [self.window addSubview:launchView];
    [UIView animateWithDuration:3.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [launchView removeFromSuperview];
                     }];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}


@end
