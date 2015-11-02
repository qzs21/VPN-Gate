//
//  BottomPushView.h
//  iAuto360
//
//  Created by Steven on 15/5/14.
//  Copyright (c) 2015年 Yamei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottomPushView;

/**
 *  点击背景后回调
 *
 *  @param view BottomPushView
 */
typedef void (^BottomPushViewBlock)(BottomPushView * view);


/// 底部弹出视图
@interface BottomPushView : UIControl

/**
 *  底部弹出视图
 *  @param  customView          自定定义视图
 *  @param  block               回调
 *  @return
 */
+ (instancetype)showWithCustomView:(UIView *)customView backgroundTouchBlock:(BottomPushViewBlock)block;



/**
 *  底部弹出视图init
 *  @param  customView          自定定义视图
 *  @param  block               回调
 *  @return
 */
- (instancetype)initWithCustomView:(UIView *)customView backgroundTouchBlock:(BottomPushViewBlock)block;

- (void)show;
- (void)hide;

@end
