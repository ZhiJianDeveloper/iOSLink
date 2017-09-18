//
//  ZJLinkManager.m
//  EasyLink
//
//  Created by 智鉴科技 on 2016/4/12.
//  Copyright © 2016年 com.bjzhijian.www. All rights reserved.
//

#import "ZJLinkManager.h"
#import "EasyLink.h"

@interface ZJLinkManager ()
@property (nonatomic, strong) EASYLINK *easyLink;
@end

@implementation ZJLinkManager

- (instancetype)init
{
    return [self initWithDelegate:nil];
}
- (instancetype)initWithDelegate:(id<ZJLinkManagerDelegate>)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
    }
    return self;
}
- (void)startPrepareLinkWiFiPassword:(NSString *)password;
{
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:20];
    
    //WIFI账号
    NSData *ssidData = [EASYLINK ssidDataForConnectedNetwork];
    
    [wlanConfig setObject:ssidData forKey:KEY_SSID];
    
    if (password.length)
    {
        [wlanConfig setObject:password forKey:KEY_PASSWORD];
    }
    //开启DHCP
    [wlanConfig setObject:[NSNumber numberWithBool:YES] forKey:KEY_DHCP];
    
    //发送
    [self.easyLink prepareEasyLink_withFTC:wlanConfig info:nil mode:EASYLINK_V2_PLUS];
    
    [self.easyLink transmitSettings];
    
}
- (void)stopTransmitting
{
    //停止Link 务必实现
    [self.easyLink stopTransmitting];
    [self.easyLink unInit];
    self.easyLink = nil;
}
#pragma mark - EasyLink delegate -

- (void)onFoundByFTC:(NSNumber *)ftcClientTag withConfiguration: (NSDictionary *)configDict
{
//    配网成功回调 ,时有时无,不要过分依赖
    [self stopTransmitting];
    if ([self.delegate respondsToSelector:@selector(linkManagerPrepareLinkSuccress:)])
    {
        [self.delegate linkManagerPrepareLinkSuccress:self];
    }
}
- (EASYLINK *)easyLink
{
    if (!_easyLink)
    {
        _easyLink = [[EASYLINK alloc] initWithDelegate:self];
    }
    return _easyLink;
}
- (void)dealloc
{
    [self stopTransmitting];
}
@end
