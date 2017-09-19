//
//  ZJBrowserBonjour.m
//  BrowserBonjour
//
//  Created by zhijian on 16/8/23.
//  Copyright © 2016年 zhijian. All rights reserved.
//
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "ZJBrowserBonjour.h"
//不要修改此参数
static NSString *const kBrowserBonjourWebServiceType = @"_zhijian._tcp";
//不要修改此参数
static NSString *const kBrowserBonjourInitialDomain = @"local";
@interface ZJBrowserBonjour ()<NSNetServiceBrowserDelegate,NSNetServiceDelegate>
@property (nonatomic, strong) NSMutableArray *servicesArray;
@property (nonatomic, strong) NSNetServiceBrowser *netServiceBrowser;
@end
@implementation NSData (Additions)
- (NSString *)host
{
    struct sockaddr *addr = (struct sockaddr *)[self bytes];
    if(addr->sa_family == AF_INET) {
        char *address = inet_ntoa(((struct sockaddr_in *)addr)->sin_addr);
        if (address)
            return [NSString stringWithCString: address encoding: NSASCIIStringEncoding];
    }
    else if(addr->sa_family == AF_INET6) {
        struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
        char straddr[INET6_ADDRSTRLEN];
        inet_ntop(AF_INET6, &(addr6->sin6_addr), straddr,
                  sizeof(straddr));
        return [NSString stringWithCString: straddr encoding: NSASCIIStringEncoding];
    }
    return nil;
}
@end
@implementation ZJBrowserBonjour
- (instancetype)initWithDelegate:(id<ZJBrowserBonjourDelegate>)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
    }
    return self;
}
- (void)startSearchForService;
{
    [self stopSearchForService];
    
    self.servicesArray = [NSMutableArray arrayWithCapacity:5];
    
    [self.netServiceBrowser searchForServicesOfType:kBrowserBonjourWebServiceType
                                           inDomain:kBrowserBonjourInitialDomain];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.servicesArray.count)
        {
            if ([self.delegate respondsToSelector:@selector(browserBonjour:didResolveAddress:)])
            {
                [self.delegate browserBonjour:self didResolveAddress:nil];
            }
        }
    });
}
- (void)stopSearchForService
{
    [_netServiceBrowser stop];
    [_servicesArray removeAllObjects];
    _servicesArray = nil;
}
#pragma mark - NSNetServiceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)service
               moreComing:(BOOL)moreComing
{
    service.delegate = self;
    [service startMonitoring];
    [self.servicesArray addObject:service];
    [service resolveWithTimeout:5.0];
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
          didRemoveDomain:(NSString *)domainString
               moreComing:(BOOL)moreComing
{
    
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)service
               moreComing:(BOOL)moreComing
{
    if ([self.servicesArray containsObject:service])
    {
        [self.servicesArray removeObject:service];
        ZJBrowserDevice *model = [self transformationModel:service];
        if ([self.delegate respondsToSelector:@selector(browserBonjour:didRemoveService:)])
        {
            [self.delegate browserBonjour:self didRemoveService:model];
        }
    }
}

#pragma mark - NSNetServiceDelegate
/*
 * 解析成功
 */
- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    [sender stop];
    ZJBrowserDevice *model = [self transformationModel:sender];
    if ([self.delegate respondsToSelector:@selector(browserBonjour:didResolveAddress:)])
    {
        [self.delegate browserBonjour:self didResolveAddress:model];
    }
    
}
- (ZJBrowserDevice *)transformationModel:(NSNetService *)sender
{
    ZJBrowserDevice *model = [[ZJBrowserDevice alloc] init];
    model.deviceIP = [sender.addresses.lastObject host];
    NSRange range = [sender.name rangeOfCharacterFromSet:[NSCharacterSet
                                                          characterSetWithCharactersInString:@"#"]];
    model.deviceName = [sender.name substringToIndex:range.location];
    NSData *mac = [[NSNetService dictionaryFromTXTRecordData:[sender TXTRecordData]]
                   objectForKey:@"MAC"];
    model.deviceAddress = [[[NSString alloc] initWithData: mac
                                             encoding:NSASCIIStringEncoding]
                       stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    return model;
}
- (NSNetServiceBrowser *)netServiceBrowser
{
    if (!_netServiceBrowser)
    {
        _netServiceBrowser = [[NSNetServiceBrowser alloc] init];
        _netServiceBrowser.delegate = self;
    }
    return _netServiceBrowser;
}
- (void)dealloc
{
    [self stopSearchForService];
}
@end

@implementation ZJBrowserDevice

@end
