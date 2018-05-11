//
//  CEFServiceManager.m
//  Authentication
//
//  Created by zhangDongdong on 2018/5/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "CEFServiceManager.h"

@implementation CEFServiceManager


+ (instancetype)defaultManager {
    static CEFServiceManager *CEFServiceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CEFServiceManager = [[self alloc] init];
    });
    return CEFServiceManager;
}


+(NSString *)createEIDwithTags:(NSArray *)tags customId:(NSString *)customId {
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    static NSString *EID = @"";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/users"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"tags":tags,
                                 @"customId":customId
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        EID = (NSString *)[dict objectForKey:@"eid"];
        
        dispatch_semaphore_signal(semaphore);
    }];
    [sessionDataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
    return EID;
}
@end
