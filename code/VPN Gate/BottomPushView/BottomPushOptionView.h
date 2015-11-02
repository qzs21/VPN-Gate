//
//  BottomPushOptionView.h
//  iAuto360
//
//  Created by Steven on 15/1/20.
//  Copyright (c) 2015年 YaMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomPushView.h"

@class BottomPushOptionView;

/**
 *  按下按钮时回调
 *  @param  view            BottomPushOptionView
 *  @param  buttonIndex     0：取消    1：确定
 */
typedef void (^BottomPushOptionViewViewBlock)(BottomPushOptionView * view, BOOL buttonIndex);


/// 底部弹出视图,包含确定取消按钮
@interface BottomPushOptionView : BottomPushView

/**
 *  底部弹出视图,包含确定取消按钮
 *  @param  customView          自定定义视图
 *  @param  block               回调
 *  @return
 */
+ (instancetype)showWithCustomView:(UIView *)customView block:(BottomPushOptionViewViewBlock)block;

/**
 *  底部弹出视图,包含确定取消按钮
 *  @param  customView          自定定义视图
 *  @param  block               回调
 *  @return
 */
- (instancetype)initWithCustomView:(UIView *)customView block:(BottomPushOptionViewViewBlock)block;

@end
