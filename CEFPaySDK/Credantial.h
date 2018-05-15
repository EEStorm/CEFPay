//
//  Credantial.h
//  CEFPay
//
//  Created by zhangDongdong on 2018/5/15.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Credantial : NSObject

#define CEFCredantial [Credantial defaultManager]

#pragma mark - 微信
@property(assign,nonatomic)NSString* wechatAppkey;
@property(assign,nonatomic)NSString* wechatSecret;
@property(assign,nonatomic)NSString * wechatRedirectURL;

#pragma mark - 微博
@property(assign,nonatomic)NSString * weiboAppkey;
@property(assign,nonatomic)NSString * weiboSecret;
@property(assign,nonatomic)NSString * weiboRedirectURL;

#pragma mark - QQ
@property(assign,nonatomic)NSString * qqAppkey;
@property(assign,nonatomic)NSString * qqSecret;
@property(assign,nonatomic)NSString * qqRedirectURL;

#pragma mark - Alipay
@property(assign,nonatomic)NSString * alipayAppkey;


+ (instancetype)defaultManager;

-(void)registerWeChatAppWithKey:(NSString *)appkey Secret:(NSString *)secret redirectURL:(NSString *)redirectURL;
-(void)registerQQAppWithKey:(NSString *)appkey Secret:(NSString *)secret redirectURL:(NSString *)redirectURL;
-(void)registerWeiboAppWithKey:(NSString *)appkey Secret:(NSString *)secret redirectURL:(NSString *)redirectURL;


@end
