//
//  BottomPickerView.h
//  iAuto360
//
//  Created by Steven on 14/12/26.
//  Copyright (c) 2014年 YaMei. All rights reserved.
//

#import "BottomPushOptionView.h"

/// Items 选择器
@interface BottomPickerView : BottomPushOptionView


@property (nonatomic, strong) UIPickerView * pickerView;

/**
 *  Items 选择器
 *  @param  pickerDelegate      UIPickerViewDelegate
 *  @param  pickerDataSource    UIPickerViewDataSource
 *  @param  block               回调
 *  @return
 */
+ (instancetype)showWithPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate
                      pickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource
                                 block:(BottomPushOptionViewViewBlock)block;



@end
