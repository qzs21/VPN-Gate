//
//  BottomPushView.m
//  iAuto360
//
//  Created by Steven on 15/5/14.
//  Copyright (c) 2015年 Yamei. All rights reserved.
//

#import "BottomPushView.h"
#import <NSObjectExtend.h>
#import <POP.h>
#import <ReactiveCocoa.h>

@interface BottomPushView()
@property (nonatomic, copy) BottomPushViewBlock bottomPushViewBlock;
@property (nonatomic, strong) UIControl * backgroundView;
@property (nonatomic, strong) UIView * customView;
@end


@implementation BottomPushView

+ (instancetype)showWithCustomView:(UIView *)customView backgroundTouchBlock:(BottomPushViewBlock)block;
{
    BottomPushView * view = [[self.class alloc] initWithCustomView:customView backgroundTouchBlock:block];
    [view show];
    return view;
}

//- (instancetype)init
//{
//    if (self = [super init])
//    {
//        // 退出登录时，隐藏
//        @weakify(self);
//        [[NSNotificationCenter.defaultCenter rac_addObserverForName:NOTIFICATION_OTHER_WAY_LOGIN object:nil]
//         subscribeNext:^(id x)
//         {
//             @strongify(self);
//             [self hide];
//         }];
//    }
//    return self;
//}

- (instancetype)initWithCustomView:(UIView *)customView backgroundTouchBlock:(BottomPushViewBlock)block;
{
    if (self = [self init])
    {
        self.bottomPushViewBlock = block;
        
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.backgroundColor = [UIColor clearColor];
        
        
        self.backgroundView = [[UIControl alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [UIColor colorWithHexCode:@"#00000080"];
        [self.backgroundView addTarget:self action:@selector(onBackgroundTouch) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundView.alpha = 0.0;
        [self addSubview:self.backgroundView];
        
        self.customView = customView;
        customView.frame = CGRectMake(0,
                                      self.frame.size.height,
                                      customView.frame.size.width,
                                      customView.frame.size.height);
        [self addSubview:customView];
        
        @weakify(self);
        [RACObserve([UIApplication sharedApplication].keyWindow, frame) subscribeNext:^(id x)
         {
             @strongify(self);
             [self updateFrames];
         }];
    }
    return self;
}

- (void)updateFrames
{
    self.backgroundView.frame = [UIApplication sharedApplication].keyWindow.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateFrames];
}

- (void)setIsShow:(BOOL)isShow
{
    if (isShow)
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    [self.customView.layer pop_removeAllAnimations];
    [self.backgroundView.layer pop_removeAllAnimations];
    
    // Custom View 动画
    id value1 = [NSNumber numberWithFloat:self.frame.size.height+self.customView.frame.size.height/2.0];
    id value2 = [NSNumber numberWithFloat:self.frame.size.height-self.customView.frame.size.height/2.0];
    POPSpringAnimation *scaleAnimation  = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    scaleAnimation.springBounciness     = isShow ? 0 : 0;
    scaleAnimation.springSpeed          = isShow ? 20 : 20;
    scaleAnimation.fromValue            = isShow ? value1 : value2;
    scaleAnimation.toValue              = isShow ? value2 : value1;
    [scaleAnimation setCompletionBlock:^(POPAnimation *p, BOOL c)
     {
         if (!isShow)
         {
             [self removeFromSuperview];
         }
     }];
    [self.customView.layer pop_addAnimation:scaleAnimation forKey:@"ShareView.spring"];
    
    // Background View 动画
    value1 = @(0.0);
    value2 = @(1.0);
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue          = isShow ? value1 : value2;
    opacityAnimation.toValue            = isShow ? value2 : value1;
    [self.backgroundView.layer pop_addAnimation:opacityAnimation forKey:@"ShareView.opacity"];
}

- (void)show
{
    [self setIsShow:YES];
}

- (void)hide
{
    [self setIsShow:NO];
}

- (void)onBackgroundTouch
{
    [self hide];
    if (self.bottomPushViewBlock)
    {
        self.bottomPushViewBlock(self);
    }
}


@end
