//
//  Credantial.m
//  CEFPay
//
//  Created by zhangDongdong on 2018/5/15.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "Credantial.h"

@implementation Credantial


+ (instancetype)defaultManager {
    static Credantial *credantial;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        credantial = [[self alloc] init];
    });
    return credantial;
}


-(void)registerQQAppWithKey:(NSString *)appkey Secret:(NSString *)secret redirectURL:(NSString *)redirectURL{
    
    self.qqAppkey = appkey;
    self.qqSecret = secret;
    self.qqRedirectURL = redirectURL;
}

-(void)registerWeChatAppWithKey:(NSString *)appkey Secret:(NSString *)secret redirectURL:(NSString *)redirectURL{
    
    self.wechatAppkey = appkey;
    self.wechatSecret = secret;
    self.wechatRedirectURL = redirectURL;
}

-(void)registerWeiboAppWithKey:(NSString *)appkey Secret:(NSString *)secret redirectURL:(NSString *)redirectURL{
    
    self.weiboAppkey = appkey;
    self.weiboSecret = secret;
    self.weiboRedirectURL = redirectURL;
}

@end
