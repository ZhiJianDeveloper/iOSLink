//
//  ZJBrowserBonjour.h
//  BrowserBonjour
//
//  Created by zhijian on 16/8/23.
//  Copyright © 2016年 zhijian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJBrowserBonjour;
@class ZJBrowserDevice;
@protocol ZJBrowserBonjourDelegate <NSObject>

/**
 发现设备服务

 @param browserBonjour 局域网内搜索到的设备信息
 @param servicesData 设备信息
 */
- (void)browserBonjour:(ZJBrowserBonjour *) browserBonjour
     didResolveAddress:(ZJBrowserDevice *)servicesData;

@optional
/**
 设备离开回调

 @param browserBonjour 设备离开局域网会出发此代理,不要过度依赖此功能,点击印章关机键无法触发此代理
 @param servicesData 设备信息
 */
- (void)browserBonjour:(ZJBrowserBonjour *) browserBonjour
      didRemoveService:(ZJBrowserDevice *)servicesData;
@end
@interface ZJBrowserBonjour : NSObject
@property (nonatomic, weak) id<ZJBrowserBonjourDelegate>delegate;

- (instancetype)initWithDelegate:(id<ZJBrowserBonjourDelegate>)delegate;
/**
 *  mDNS服务开启
 */
- (void)startSearchForService;


/**
 停止mDNS服务
 */
- (void)stopSearchForService;
@end

@interface ZJBrowserDevice : NSObject
@property (nonatomic, copy) NSString *deviceIP;
@property (nonatomic, copy) NSString *deviceAddress;
@property (nonatomic, copy) NSString *deviceName;
@end
