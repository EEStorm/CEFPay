//
//  CEFResponse.h
//  CEFPay
//
//  Created by zhangDongdong on 2018/5/11.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

enum  CEFRespType {
    WeChat_Pay           = 0,
    Alipay_Pay               = 1
};

@interface CEFResponse : NSObject
/** 错误码 */
@property (nonatomic, assign) int errCode;
/** 错误提示字符串 */
@property (nonatomic, retain) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) enum CEFRespType type;
/** 平台类型 */
@property (nonatomic, assign) int channel;

@end

