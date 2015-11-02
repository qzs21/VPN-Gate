//
//  BottomPushOptionView.m
//  iAuto360
//
//  Created by Steven on 15/1/20.
//  Copyright (c) 2015年 YaMei. All rights reserved.
//

#import "BottomPushOptionView.h"
#import <ReactiveCocoa.h>
#import <NSObjectExtend.h>

@interface BottomPushOptionView()
@property (nonatomic, copy) BottomPushOptionViewViewBlock bottomPushOptionViewViewBlock;
@end


@implementation BottomPushOptionView


/**
 *  show Items
 *  @param  delegate            BottomViewDelegate
 *  @param  customView          自定定义视图
 *  @return
 */
+ (instancetype)showWithCustomView:(UIView *)customView block:(BottomPushOptionViewViewBlock)block;
{
    BottomPushOptionView * view = [[self.class alloc] initWithCustomView:customView block:block];
    [view show];
    return view;
}

/**
 *  init Items
 *  @param  delegate            BottomViewDelegate
 *  @param  customView          自定定义视图
 *  @return
 */
- (instancetype)initWithCustomView:(UIView *)customView block:(BottomPushOptionViewViewBlock)block;
{
    
    UIImageView * toolBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, getWindowWidth(), 44)];
    toolBar.userInteractionEnabled = YES;
    toolBar.image = nil;
    toolBar.backgroundColor = [UIColor clearColor];
    
    CGFloat btnW = 60;
    CGFloat btnH = 30;
    CGFloat btnY = 7;
    CGFloat s = 12; // 边距
    
    UIButton * determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.frame = CGRectMake(getWindowWidth() - btnW - s, btnY, btnW, btnH);
    [determineButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_N"].imageStretchableCenter
                               forState:UIControlStateNormal];
    [determineButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_H"].imageStretchableCenter
                               forState:UIControlStateHighlighted];
    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
    [determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    determineButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [determineButton addTarget:self action:@selector(pickerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:determineButton];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(s, btnY, btnW, btnH);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_N"].imageStretchableCenter
                            forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_H"].imageStretchableCenter
                            forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(pickerCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelButton];
    
    
    customView.Y = 44;
    
    CGFloat height = customView.Y + customView.height;
    UIView * rootView = [[UIView alloc] initWithFrame:CGRectMake(0, getWindowHeight(), getWindowWidth(), height)];
    rootView.backgroundColor = [UIColor whiteColor];
    [rootView addSubview:customView];
    [rootView addSubview:toolBar];
    
    self.bottomPushOptionViewViewBlock = block;
    
    
    @weakify(self);
    return [self initWithCustomView:rootView backgroundTouchBlock:^(BottomPushView *view)
    {
        @strongify(self);
        self.bottomPushOptionViewViewBlock(self, 0);
    }];
}

- (void)pickerButtonClick
{
    [self hide];
    if (self.bottomPushOptionViewViewBlock)
    {
        self.bottomPushOptionViewViewBlock(self, 1);
    }
}

- (void)pickerCancelButtonClick
{
    [self hide];
    if (self.bottomPushOptionViewViewBlock)
    {
        self.bottomPushOptionViewViewBlock(self, 0);
    }
}

@end
