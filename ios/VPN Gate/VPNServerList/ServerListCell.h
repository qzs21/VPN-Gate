//
//  ServerListCell.h
//  VPN Gate
//
//  Created by Steven on 15/8/20.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *countryLogoImageView; // 国家logo
@property (weak, nonatomic) IBOutlet UILabel *countryNameLab; // 国家名字
@property (weak, nonatomic) IBOutlet UILabel *IPLab; // IP地址
@property (weak, nonatomic) IBOutlet UILabel *sportTypeLab; // 支持类型

@property (weak, nonatomic) IBOutlet UILabel *widthLab; // 带宽
@property (weak, nonatomic) IBOutlet UILabel *PingLab; // ping
@property (weak, nonatomic) IBOutlet UILabel *scoreLab; // 得分
@property (weak, nonatomic) IBOutlet UILabel *usersLab; // 用户数
@property (weak, nonatomic) IBOutlet UIButton *addBtn; // ＋ 按钮

@end
