
#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "CEFServiceManager.h"

#define CEFPayManager [CEFServicePay defaultManager]

typedef NS_ENUM(NSInteger, CEFServicePayResult){
    CEFServicePayResultSuccess,// 成功
    CEFServicePayResultFailure,// 失败
    CEFServicePayResultCancel  // 取消
};


typedef void(^QueryOrder)(NSDictionary * orderString,NSError *errorMessage);
typedef void(^CloseOrder)(NSError *errorMessage);

typedef void(^CEFServicePayResultCallBack)(CEFServicePayResult payResult, NSString *errorMessage, NSString *orderId);
typedef void(^CEFServiceGetDataCallBack)(NSError *errorMessage,NSString *orderId);

@interface CEFServicePay : NSObject


+ (instancetype)defaultManager;

- (void)registerPaymentWithEID:(NSString *)EID channel:(Channel)channel delegate:(id<CEFApiDelegate>) delegate;

- (BOOL)handleOpenURL:(NSURL *)url;

- (NSData *)CEFServicePayWithEID:(NSString *)EID
                     channel:(Channel)channel
                     subject:(NSString *)subject
                 tradeNumber:(NSString *)tradeNumber
                      amount:(NSString *) amount
                    callBack:(CEFServiceGetDataCallBack)callBack;

//- (void)CEFServicePayWithParternerId:(NSString *)partnerId
//                            prepayId:(NSString *)prepayId
//                            nonceStr:(NSString *)nonceStr
//                           timeStamp:(NSString *)timeStamp
//                                sign:(NSString *)sign
//                            callBack:(CEFServicePayResultCallBack)callBack;

- (void)CEFServicePayWithChannel:(Channel)channel data:(NSData *)data callBack:(CEFServicePayResultCallBack)callBack;

- (void)CEFCheckingOrder:(NSString *)orderId order:(QueryOrder)order;

- (void)CEFServiceCloseOrder:(NSString *)orderId callBack:(CloseOrder)callback;

@end

