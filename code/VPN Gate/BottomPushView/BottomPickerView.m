//
//  BottomPickerView.m
//  iAuto360
//
//  Created by Steven on 14/12/26.
//  Copyright (c) 2014年 YaMei. All rights reserved.
//

#import "BottomPickerView.h"

@implementation BottomPickerView

+ (instancetype)showWithPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate
                      pickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource
                                 block:(BottomPushOptionViewViewBlock)block;
{
    UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 180)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = pickerDataSource;
    pickerView.delegate = pickerDelegate;
    
    BottomPickerView * view = [self showWithCustomView:pickerView block:block];
    view.pickerView = pickerView;
    
    return view;
}


@end
