//
//  ZJLinkManager.h
//  EasyLink
//
//  Created by 智鉴科技 on 2016/4/12.
//  Copyright © 2016年 com.bjzhijian.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZJLinkManager;
@protocol ZJLinkManagerDelegate <NSObject>

@optional
/**
 配置成功回调
 如WiFi密码输入错误,则无回调. 此方法不可依赖, 以印章蜂鸣器滴声响做判断配网成功依据
 */
- (void)linkManagerPrepareLinkSuccress:(ZJLinkManager *)manager;
@end

@interface ZJLinkManager : NSObject

/**
 设置代理
 */
@property (nonatomic, weak) id<ZJLinkManagerDelegate>delegate;

/**
 初始化LinkManager

 @param delegate "
 @return self
 */
- (instancetype)initWithDelegate:(id<ZJLinkManagerDelegate>)delegate;
/**
 配置WiFi信息
 WiFi账号由 ZJLinkManager内部自动获取,无需处理
 @param password WiFi密码,如传nil ZJLinkManager 内部自动判断WiFi密码为空
 */
- (void)startPrepareLinkWiFiPassword:(NSString *)password;

/**
 停止配网, 此方法必须配网结束后,或者离开Controller必须实现
 */
- (void)stopTransmitting;
@end
