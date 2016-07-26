//
//  kSZInteractiveTransition.h
//  JCProject
//
//  Created by pg on 16/6/16.
//  Copyright © 2016年 StarkShen. All rights reserved.
//  通过继承 UIPercentDrivenInteractiveTransition 实现交互式动画

#import <UIKit/UIKit.h>
typedef void (^GestureBlock)();
typedef NS_ENUM(NSUInteger,kSZInteractiveTransitionGestureDirection){
  //  手势方向
  kSZInteractiveTransitionGestureDirectionLeft = 0,
  kSZInteractiveTransitionGestureDirectionRight,
  kSZInteractiveTransitionGestureDirectionUp,
  kSZInteractiveTransitionGestureDirectionDown
  
};
typedef NS_ENUM(NSUInteger,kSZInteractiveTransitionType){
  //  手势控制哪种转场
  kSZInteractiveTransitionTypePresent = 0,
  kSZInteractiveTransitionTypeDissmiss,
  kSZInteractiveTransitionTypePush,
  kSZInteractiveTransitionTypePop
};

@interface kSZInteractiveTransition : UIPercentDrivenInteractiveTransition
/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureBlock presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureBlock pushConifg;


+ (instancetype)interactiveTransitionWithTransitionType:(kSZInteractiveTransitionType)type GestureDirection:(kSZInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(kSZInteractiveTransitionType)type GestureDirection:(kSZInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end
