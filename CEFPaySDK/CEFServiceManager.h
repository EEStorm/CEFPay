//
//  CEFServiceManager.h
//  Authentication
//
//  Created by zhangDongdong on 2018/5/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//


#import "CEFResponse.h"
#import <Foundation/Foundation.h>

@protocol CEFApiDelegate <NSObject>

@optional

- (void)onResopnse:(CEFResponse*) CEFResponse;
@end


@interface CEFServiceManager : NSObject<CEFApiDelegate>

@property(nonatomic,weak)id<CEFApiDelegate> CEFApiDel;

+ (instancetype)defaultManager;
+(NSString *)createEIDwithTags:(NSArray*)tags customId:(NSString*)customId;

@end


