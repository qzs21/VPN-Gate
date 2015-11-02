//
//  ServerListCell.m
//  VPN Gate
//
//  Created by Steven on 15/8/20.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ServerListCell.h"

@interface ServerListCell()
@property (weak, nonatomic) IBOutlet UIView *titlesView;
@property (weak, nonatomic) IBOutlet UIView *valuesView;
@end

@implementation ServerListCell

- (void)awakeFromNib {
    self.titlesView.backgroundColor = [UIColor whiteColor];
    self.valuesView.backgroundColor = [UIColor whiteColor];
}

@end
