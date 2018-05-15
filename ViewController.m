

#import "ViewController.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrcode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)wechatpay:(id)sender {
    
    NSString *EID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_EID"];
    NSData *orderData = [CEFPayManager CEFServicePayWithEID:EID
                                channel:WeChat
                                subject:@"subject"
                            tradeNumber:@"DevTradeNumber001"
                                 amount:@"1"
                               callBack:^(NSError *errorMessage, NSString *orderId) {
                                   
                               }];
    [CEFPayManager CEFServicePayWithChannel:WeChat data:orderData callBack:^(CEFServicePayResult payResult, NSString *errorMessage, NSString *orderId) {
       
        
    }];
    
}

-(void)queryOrder {
    [CEFPayManager CEFCheckingOrder:@"" order:^(NSDictionary *order,NSError *errorMessage) {
       
        if (!errorMessage) {
            
        }
    }];
}

-(void)closeOrder{
    [CEFPayManager CEFServiceCloseOrder:@"" callBack:^(NSError *errorMessage) {
        if (!errorMessage) {
            
        }
    }];
}
/*--->
NSString *url = [NSString stringWithFormat:@"%@/api/parkOrder/getAlipayOrderInfo", kHTTP];
NSLog(@"支付宝___URL=== %@", url);
[XLNetworkManager POST:url token:nil params:@{@"platform":@(2), @"orderId":@(orderId)} success:^(NSURLSessionDataTask *task, NSDictionary *JSONDictionary, NSString *JSONString) {
    NSLog(@"%@", JSONString);
    
    //将签名成功字符串格式化为订单字符串
    NSString *orderSignString = [JSONDictionary objectForKey:@"data"];
    
    NSString *AppID = @"你的支付宝商户AppID";
    if (AppID.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    //调用支付的app注册在info.plist中对应的URL Schemes
    NSString *URLSchemes = AppID;
    
    //如果加签成功，则继续执行支付
    if (orderSignString != nil) {
        
        //调用支付结果开始支付
        //服务器 把订单签名后的字符串穿过来 然后在info URL Schemes里面配置统一的字符串
        //然后执行支付宝的 支付方法 在回调里面写支付结果的代码
        [[AlipaySDK defaultService] payOrder:orderSignString fromScheme:URLSchemes callback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic=== %@", resultDic);
            NSLog(@"memo=== %@", resultDic[@"memo"]);
            NSLog(@"result=== %@", resultDic[@"result"]);
            NSLog(@"resultStatus=== %@", resultDic[@"resultStatus"]);
            NSInteger result = 0;
            NSString *message = @"";
            NSString *resultStatus = resultDic[@"resultStatus"];
            
            switch (resultStatus.integerValue) {
                    
                case 9000:    //支付成功
                    result = 0;
                    message = @"支付成功";
                    break;
                    
                case 8000:
                    result = 10;
                    message = @"正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                    break;
                    
                case 4000:
                    result = 10;
                    message = @"订单支付失败";
                    break;
                    
                case 5000:
                    result = 10;
                    message = @"重复请求";
                    break;
                    
                case 6001:
                    result = 10;
                    message = @"用户中途取消";
                    break;
                    
                    
                case 6002:
                    result = 10;
                    message = @"网络连接出错";
                    break;
                    
                case 6004:
                    result = 10;
                    message = @"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                    break;
                    
                default:
                    result = 10;
                    message = @"支付失败";
                    break;
            }
            
            NSDictionary *messageAsDictionary = @{@"result":@(result), @"message":message};
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:messageAsDictionary]
                                        callbackId:callbackId];
        }];
    }
    
} failure:^(NSURLSessionDataTask *task, NSError *error, NSInteger statusCode, NSString *requestFailedReason) {
    NSLog(@"error= %@", error);
}];
*/
- (IBAction)alipay:(id)sender {
//    NSString *orderMessage = @"app_id=2015052600090779&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.02%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22314VYGIAGG7ZOYY%22%7D&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA&timestamp=2016-08-15%2012%3A12%3A15&version=1.0&sign=MsbylYkCzlfYLy9PeRwUUIg9nZPeN9SfXPNavUCroGKR5Kqvx0nEnd3eRmKxJuthNUx4ERCXe552EV9PfwexqW%2B1wbKOdYtDIb4%2B7PL3Pc94RZL0zKaWcaY3tSL89%2FuAVUsQuFqEJdhIukuKygrXucvejOUgTCfoUdwTi7z%2BZzQ%3D";
//
//
//    [CEFServiceManager CEFServicePayWithOrder:orderMessage callBack:^(CEFServicePayResult payResult, NSString *errorMessage) {
//        NSLog(@"errCode = %zd,errStr = %@",payResult, errorMessage);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
