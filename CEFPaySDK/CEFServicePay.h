
#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "CEFServiceManager.h"

#define CEFPayManager [CEFServicePay defaultManager]

typedef NS_ENUM(NSInteger, CEFServicePayResult){
    CEFServicePayResultSuccess,// 成功
    CEFServicePayResultFailure,// 失败
    CEFServicePayResultCancel  // 取消
};


typedef NS_OPTIONS(NSUInteger, Channel) {
    WeChat     = 1 << 0,
    Alipay     = 1 << 1,
};

typedef void(^QueryOrder)(NSDictionary*);

typedef void(^CEFServicePayResultCallBack)(CEFServicePayResult payResult, NSString *errorMessage, NSString *orderId);
typedef void(^CreateOrderCompletion)(NSString* prepayId,NSString* partnerid,NSString* noncestr,NSString* timestamp,NSString* sign);

@interface CEFServicePay : NSObject

@property(nonatomic,copy)CreateOrderCompletion createOrderCompletion;
@property(nonatomic,copy)QueryOrder queryOrder;

+ (instancetype)defaultManager;

- (void)registerPaymentWithEID:(NSString *)EID channel:(Channel)channel delegate:(id<CEFApiDelegate>) delegate;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)CEFServicePayWithEID:(NSString *)EID
                     channel:(Channel)channel
                     subject:(NSString *)subject
                 tradeNumber:(NSString *)tradeNumber
                      amount:(NSString *) amount
                    callBack:(CEFServicePayResultCallBack)callBack;

- (void)CEFServicePayWithParternerId:(NSString *)partnerId
                            prepayId:(NSString *)prepayId
                            nonceStr:(NSString *)nonceStr
                           timeStamp:(NSString *)timeStamp
                                sign:(NSString *)sign
                            callBack:(CEFServicePayResultCallBack)callBack;

- (void)CEFCheckingOrderWithOrderId:(NSString *)orderId order:(QueryOrder)order;

- (void)CEFServiceCloseOrder:(NSString *)orderId;

@end

