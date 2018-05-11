
#import "CEFServicePay.h"

#import <CommonCrypto/CommonDigest.h>
/**
 *  此处必须保证在Info.plist 中的 URL Types 的 Identifier 对应一致
 */
#define WeChat_URLTypesIdentifier @"wechatpay"
#define Alipay_URLTypesIdentifier @"alipay"
#define WeChat_Package @"Sign=WXPay"

#define callBackURL @"url地址不能为空！"

#define orderMessage_nil @"订单信息不能为空！"

#define addURLTypes @"请先在Info.plist 添加 URLTypes"

#define addURLSchemes(URLTypes) [NSString stringWithFormat:@"请先在Info.plist对应的 URLTypes 添加 %@ 对应的 URL Schemes", URLTypes]

@interface CEFServicePay () <WXApiDelegate>

// 支付结果缓存回调
@property (nonatomic, copy) CEFServicePayResultCallBack callBack;

@property (nonatomic, strong)NSString *orderId;
// 保存URL_Schemes到字典里面
@property (nonatomic, strong) NSMutableDictionary *URL_Schemes_Dic;

@end

@implementation CEFServicePay


+ (instancetype)defaultManager {
    static CEFServicePay *CEFServicePay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CEFServicePay = [[self alloc] init];
    });
    return CEFServicePay;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    NSAssert(url, callBackURL);
    if ([url.host isEqualToString:@"pay"]) {// 微信
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return NO;
    }
}

- (void)registerPaymentWithEID:(NSString *)EID channel:(Channel)channel delegate:(id<CEFApiDelegate>)delegate{
    
    [CEFServiceManager defaultManager].CEFApiDel = delegate;
    
    NSString *Info_plist_path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *Info_plist_dic = [NSDictionary dictionaryWithContentsOfFile:Info_plist_path];
    NSArray *URL_Types_Array = Info_plist_dic[@"CFBundleURLTypes"];
    NSAssert(URL_Types_Array, addURLTypes);
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"PAYSUCCESS"];
    for (NSDictionary *URL_Type_Dic in URL_Types_Array) {
        NSString *URL_Name = URL_Type_Dic[@"CFBundleURLName"];
        NSArray *URL_Schemes_Array = URL_Type_Dic[@"CFBundleURLSchemes"];
        NSAssert(URL_Schemes_Array.count, addURLSchemes(URL_Name));
        NSString *URL_Schemes = URL_Schemes_Array.lastObject;
        
        if ([URL_Name isEqualToString:WeChat_URLTypesIdentifier]) {//微信支付
            if (channel & WeChat) {
                [self.URL_Schemes_Dic setValue:URL_Schemes forKey:WeChat_URLTypesIdentifier];
                NSLog(@"WeChat_URL_Schemes=appid 微信开发者ID= %@", URL_Schemes);
                [WXApi registerApp:URL_Schemes];
            }
            
        } else if ([URL_Name isEqualToString:Alipay_URLTypesIdentifier]){//支付宝
            if (channel & Alipay) {
                
                NSLog(@"Alipay_URL_Schemes= %@", URL_Schemes);
                [self.URL_Schemes_Dic setValue:URL_Schemes forKey:Alipay_URLTypesIdentifier];
            }
            
        } else{
            
        }
    }
}

#pragma mark - Create PrepayID
-(void)CEFServicePayWithEID:(NSString *)EID channel:(Channel)channel subject:(NSString *)subject tradeNumber:(NSString *)tradeNumber amount:(NSString *)amount callBack:(CEFServicePayResultCallBack)callBack{
    
    self.callBack = callBack;
    
    [CEFPayManager requestOrderPrepayId: EID channel:channel subject:subject tradeNumber:tradeNumber amount:amount createOrderCompletion:^(NSString *prepayId,NSString* partnerid,NSString* noncestr,NSString* timestamp,NSString* sign) {
        
        
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = partnerid;
        req.prepayId= prepayId;
        req.package = @"Sign=WXPay";
        req.nonceStr= noncestr;
        req.timeStamp= timestamp.intValue;
        
        req.sign= sign;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [CEFPayManager CEFServicePayWithOrder:req callBack:callBack];
        });
    }];
}


-(void)requestOrderPrepayId:(NSString *)EID channel:(Channel)channel subject:(NSString *)subject tradeNumber:(NSString *)tradeNumber amount:(NSString *) amount createOrderCompletion:(CreateOrderCompletion)createOrder{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xzshengpaymentstaging.eastasia.cloudapp.azure.com/serviceProviders/payment/createOrder"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"eid":EID,
                                 @"channel":@"WeChat",
                                 @"subject":subject,
                                 @"tradeNumber":tradeNumber,
                                 @"amount":amount
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        NSDictionary *properties = (NSDictionary *)[dict objectForKey:@"properties"];
        
        NSString *prepayId = [properties objectForKey:@"prepayid"];
        NSString *partnerid = [properties objectForKey:@"partnerid"];
        NSString *noncestr = [properties objectForKey:@"noncestr"];
        NSString *timestamp = [properties objectForKey:@"timestamp"];
        NSString *sign = [properties objectForKey:@"sign"];
        NSString *orderId = [properties objectForKey:@"orderId"];
        self.orderId = orderId;
        createOrder(prepayId,partnerid,noncestr,timestamp,sign);
        NSLog(@"%@",prepayId);
        
        
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"PAYSUCCESS"];
    }];
    [sessionDataTask resume];
    
}

- (void)CEFServicePayWithOrder:(id)order callBack:(CEFServicePayResultCallBack)callBack {
    NSAssert(order, orderMessage_nil);
    
    self.callBack = callBack;
    
    if ([order isKindOfClass:[PayReq class]]) {
        
        NSAssert(self.URL_Schemes_Dic[WeChat_URLTypesIdentifier], addURLSchemes(WeChat_URLTypesIdentifier));
        
        [WXApi sendReq:(PayReq *)order];
    }
}

#pragma mark With Parameter
-(void)CEFServicePayWithParternerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign callBack:(CEFServicePayResultCallBack)callBack {
    
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = partnerId;
    req.prepayId= prepayId;
    req.package = WeChat_Package;
    req.nonceStr= nonceStr;
    req.timeStamp= timeStamp.intValue;
    
    req.sign= sign;
    
    self.callBack = callBack;
    
    NSAssert(self.URL_Schemes_Dic[WeChat_URLTypesIdentifier], addURLSchemes(WeChat_URLTypesIdentifier));
    
    [WXApi sendReq:(PayReq *)req];
    
}

#pragma mark - Checking Order

-(void)CEFCheckingOrderWithOrderId:(NSString *)orderId order:(QueryOrder)order{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xzshengpaymentstaging.eastasia.cloudapp.azure.com/serviceProviders/payment/queryOrder"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"orderId":orderId};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        NSDictionary *properties = (NSDictionary *)[dict objectForKey:@"properties"];

        NSLog(@"%@",properties);
        order(properties);
    }];
    [sessionDataTask resume];
}

#pragma mark - Close Order
-(void)CEFServiceCloseOrder:(NSString *)orderId {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://xzshengpaymentstaging.eastasia.cloudapp.azure.com/serviceProviders/payment/closeOrder"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"orderId":orderId};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [sessionDataTask resume];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    //
    CEFResponse *cefresp = [[CEFResponse alloc]init];
    cefresp.errCode = resp.errCode;
    cefresp.errStr = resp.errStr;
    
    if([resp isKindOfClass:[PayResp class]]){
        
        cefresp.type = WeChat_Pay;
        [[CEFServiceManager defaultManager].CEFApiDel onResopnse:cefresp];
        
        CEFServicePayResult errorCode = CEFServicePayResultSuccess;
        NSString *errStr = resp.errStr;
        switch (resp.errCode) {
            case 0:
                errorCode = CEFServicePayResultSuccess;
                errStr = @"订单支付成功";
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"PAYSUCCESS"];
                break;
            case -1:
                errorCode = CEFServicePayResultFailure;
                errStr = resp.errStr;
                break;
            case -2:
                errorCode = CEFServicePayResultCancel;
                errStr = @"用户中途取消";
                break;
            default:
                errorCode = CEFServicePayResultFailure;
                errStr = resp.errStr;
                break;
        }
        if (self.callBack) {
            self.callBack(errorCode,errStr,self.orderId);
        }
    }
}

#pragma mark -- Setter & Getter

- (NSMutableDictionary *)URL_Schemes_Dic {
    if (_URL_Schemes_Dic == nil) {
        _URL_Schemes_Dic = [NSMutableDictionary dictionary];
    }
    return _URL_Schemes_Dic;
}

@end


