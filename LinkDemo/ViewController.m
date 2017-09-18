//
//  ViewController.m
//  EasyLink
//
//  Created by 智鉴科技 on 2016/4/12.
//  Copyright © 2016年 com.bjzhijian.www. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"
#import "ZJLinkManager.h"
@interface ViewController ()<ZJLinkManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (nonatomic, strong) ZJLinkManager *linkManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHUD];
    self.linkManager = [[ZJLinkManager alloc] initWithDelegate:self];
    
    
}
- (void)configHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textFiled becomeFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //停止
    [self.linkManager stopTransmitting];
}

/**
 配网成功回调 不要过分依赖此功能,以印章蜂鸣声音判断配网成功与否

 @param manager <#manager description#>
 */
- (void)linkManagerPrepareLinkSuccress:(ZJLinkManager *)manager
{
    [SVProgressHUD showInfoWithStatus:@"配网成功"];
}
- (IBAction)startTransmitting:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"开始配网,请等待"];
    
    [self.textFiled resignFirstResponder];
    
    [self.linkManager startPrepareLinkWiFiPassword:self.textFiled.text];
    
}
- (IBAction)stopTransmitting:(id)sender
{
    [SVProgressHUD dismiss];
    
    [self.linkManager stopTransmitting];
}
@end
