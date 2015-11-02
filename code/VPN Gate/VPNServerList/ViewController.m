//
//  ViewController.m
//  VPN Gate
//
//  Created by Steven on 15/8/20.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ViewController.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <NSObjectExtend.h>
#import <BlocksKit+UIKit.h>
#import <ReactiveCocoa.h>

#import "ServerListCell.h"
#import "VPNServerInfo.h"
#import "ServerListInfo.h"
#import "BottomPickerView.h"

#import "STDPingServices.h"


#define OPEN_VPN_APP_STORE_URL @"https://itunes.apple.com/cn/app/openvpn-connect/id590379981"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger mTempMirrorsIndex;
}
@property (nonatomic, strong) NSArray * vpnServerItems;

@property (nonatomic, strong) NSArray <ServerListInfo *> * mirrorsServerItems; // 镜像服务器列表
@property (nonatomic, assign) NSInteger mirrorsServerIndex; // 当前镜像服务器

@property (nonatomic, weak) IBOutlet UITableView * tableView;

- (IBAction)onTopRightButtonTouch:(UIButton *)sender;

- (IBAction)onSelectMrrorsServerTouch:(id)sender;

@property (nonatomic, strong) AFHTTPRequestOperationManager * manager;

@property (nonatomic, strong) STDPingServices * serviece;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mirrorsServerIndex = 0;
    [self getMirrorsServerList];
    
//    for test
//    self.serverItems = [ServerInfo resloerServerList:[NSData dataWithContentsOfFile:@"/Users/steven/vpngate.html"]
//                                            withURL:self.host];

//    @weakify(self);
//    self.serviece = [STDPingServices startPingAddress:@"baidu.com" callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
//        @strongify(self);
//        if (pingItem.status != STDPingStatusFinished) {
//            NSLog(@"%@", pingItem.description);
//        } else {
//            NSLog(@"%@", [STDPingItem statisticsWithPingItems:pingItems]);
////            [self.textView appendText:[STDPingItem statisticsWithPingItems:pingItems]];
////            [button setTitle:@"Ping" forState:UIControlStateNormal];
////            button.tag = 10001;
////            self.pingServices = nil;
//        }
//    }];
}

- (AFHTTPRequestOperationManager *)manager
{
    if (_manager == nil)
    {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer.timeoutInterval = 5;
    }
    return _manager;
}

- (void)getMirrorsServerList
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [SVProgressHUD showWithStatus:@"正在更新镜像服务器列表"];
    });
    
    [ServerListInfo getServerList:^(NSArray<ServerListInfo *> *list)
     {
         // 列表为空结束获取
         if (list.count == 0)
         {
             [SVProgressHUD showErrorWithStatus:@"获取服务器镜像失败"];
             return;
         }
         
         self.mirrorsServerItems = list;
         self.mirrorsServerIndex = 0;
         [self reloadListVPNData];
     }];
}

- (void)reloadListVPNData
{
    if (self.mirrorsServerItems.count <= self.mirrorsServerIndex)
    {
        [SVProgressHUD showErrorWithStatus:@"未获取到镜像服务器列表"];
        return;
    }
    
    NSString * host = self.mirrorsServerItems[self.mirrorsServerIndex].host;
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在从镜像服务器:\n%@\n获取VPN列表", host]];
    
    [self.manager GET:host parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 存在数据解析，不可能执行到这里
        NSLog(@"成功");
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // Json解析失败，回调到此
        
        // 解析，返回已排序好的列表
        NSArray * items = [VPNServerInfo resloerServerList:operation.responseData withURL:operation.response.URL];
        
        if (items.count == 0)
        {
            // 获取失败，自动获取下一个
            if (self.mirrorsServerIndex < self.mirrorsServerItems.count - 1)
            {
                self.mirrorsServerIndex++;
                [self reloadListVPNData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"VPN列表失败"];
            }
            return;
        }
        else
        {
            // 刷新列表
            [SVProgressHUD dismiss];
            self.vpnServerItems = items;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vpnServerItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServerListCell * cell= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    VPNServerInfo * info = self.vpnServerItems[indexPath.row];
    
    [cell.countryLogoImageView sd_setImageWithURL:info.countryImageURL];
    cell.countryNameLab.text = NO_EMPTY_STRING(info.countryName);
    cell.IPLab.text = NO_EMPTY_STRING(info.IP);
    cell.widthLab.text = NO_EMPTY_STRING(info.bandwidth);
    cell.PingLab.text = IntToString(info.ping);
    cell.scoreLab.text = IntToString(info.score);
    cell.usersLab.text = IntToString(info.totalUsers);
    
    [[[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        if (info.openVPN_TCP_OVPN_URL && info.openVPN_UDP_OVPN_URL)
        {
            UIActionSheet * sheet = [UIActionSheet bk_actionSheetWithTitle:@"Plase choose TCP/UDP."];
            [sheet bk_addButtonWithTitle:[NSString stringWithFormat:@"TCP(%@)", info.openVPN_TCP_OVPN_URL.port] handler:^{
                [self openURL:info.openVPN_TCP_OVPN_URL];
            }];
            [sheet bk_addButtonWithTitle:[NSString stringWithFormat:@"UDP(%@)", info.openVPN_UDP_OVPN_URL.port] handler:^{
                [self openURL:info.openVPN_UDP_OVPN_URL];
            }];
            [sheet bk_addButtonWithTitle:@"如果未安装OpenVPN请点击安装" handler:^{
                [self openURL:[NSURL URLWithString:OPEN_VPN_APP_STORE_URL]];
            }];
            
            [sheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
            [sheet showInView:self.view];
        }
        else
        {
            if (info.openVPN_TCP_OVPN_URL)
            {
                [self openURL:info.openVPN_TCP_OVPN_URL];
            }
            if (info.openVPN_UDP_OVPN_URL)
            {
                [self openURL:info.openVPN_UDP_OVPN_URL];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"此服务器不包含OpenVPN配置"];
            }
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)openURL:(NSURL *)URL
{
    NSString * urlString = [URL.absoluteString stringByRemovingPercentEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


- (IBAction)onTopRightButtonTouch:(UIButton *)sender
{
    [self reloadListVPNData];
}

- (IBAction)onSelectMrrorsServerTouch:(id)sender
{
    BottomPickerView * view = [BottomPickerView showWithPickerDelegate:self pickerDataSource:self block:^(BottomPushOptionView *view, BOOL buttonIndex)
    {
        if (buttonIndex)
        {
            NSInteger oldIndex = _mirrorsServerIndex;
            self.mirrorsServerIndex = mTempMirrorsIndex;
            if (oldIndex != _mirrorsServerIndex)
            {
                [self reloadListVPNData];
            }
        }
    }];
    if (self.mirrorsServerItems.count >= self.mirrorsServerIndex)
    {
        [view.pickerView selectRow:self.mirrorsServerIndex inComponent:0 animated:NO];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return self.mirrorsServerItems.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * name = self.mirrorsServerItems[row].name;
    NSURL * url = [NSURL URLWithString:self.mirrorsServerItems[row].host];
    return [NSString stringWithFormat:@"%@(%@)", name, url.host];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    mTempMirrorsIndex = row;
}

@end
