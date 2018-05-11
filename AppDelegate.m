//
//  AppDelegate.m
//  CEFServicePayManager
//
//  Created by XLsn0w on 2017/4/21.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

#import "AppDelegate.h"
#import "AlipaySDK/AlipaySDK.h"

@interface AppDelegate ()<CEFApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
    
    if (!EID) {
        EID = [CEFServiceManager createEIDwithTags:@[@"Beijing"] customId:@"storm"];
        [[NSUserDefaults standardUserDefaults]setObject:EID forKey:@"CUSTOM_EID"];
    }
    
    [CEFPayManager registerPaymentWithEID:EID channel:(WeChat|Alipay) delegate:self];
    
    return YES;
}

-(void)onResopnse:(CEFResponse *)CEFResponse {
    
    if (CEFResponse.type == WeChat_Pay) {
        
        switch (CEFResponse.errCode) {
            case 0:
//                订单支付成功
                break;
            case -1:
//                订单支付失败
                break;
            case -2:
//                用户中途取消
                break;
            default:
                break;
        }
    }
}
#pragma mark - 微信支付&支付宝SDK
////
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    return [CEFPayManager handleOpenURL:url];
}
//
////iOS 9.0 之前 会调用
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//
//    return [CEFServicePayManager handleOpenURL:url];
//}
//
////iOS 9.0 以上（包括iOS9.0）
//- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
//
//    return [CEFServicePayManager handleOpenURL:url];
//}

#pragma mark - 

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
