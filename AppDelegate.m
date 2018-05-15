







//微信开发者ID
#define URL_APPID @"wxa186d3f0aa51c56e"
#define URL_SECRET @"7c82bd6a2b1da97d78491a41c4166111"

#define IFM_SinaAPPKey      @"2161062029"
#define IFM_SinaAppSecret   @"8882ed1ca6c30b9b8794765ec3313a39"

#define QQ_APPID @"1105567034"
#define QQ_SECRET @"i9u9zTaunPX7JIzM"


#import "AppDelegate.h"
#import "AlipaySDK/AlipaySDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [CEFCredantial registerWeChatAppWithKey:URL_APPID Secret:URL_SECRET redirectURL:nil];
    
    CEFCredantial.weiboAppkey = IFM_SinaAPPKey;
    CEFCredantial.weiboSecret = IFM_SinaAppSecret;
    CEFCredantial.qqAppkey = QQ_APPID;
    CEFCredantial.qqSecret = QQ_SECRET;
    
    
    NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
    
    if (!EID) {
        EID = [CEFServiceManager createEIDwithTags:@[@"Beijing"] customId:@"storm"];
        [[NSUserDefaults standardUserDefaults]setObject:EID forKey:@"CUSTOM_EID"];
    }
    
    [[CEFServiceManager defaultManager] registerApp:(WeChat|Alipay)];
  
    return YES;
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
