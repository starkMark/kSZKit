//
//  kSZInteractiveTransition.m
//  JCProject
//
//  Created by pg on 16/6/16.
//  Copyright © 2016年 StarkShen. All rights reserved.
//

#import "kSZInteractiveTransition.h"
@interface kSZInteractiveTransition ()

@property (nonatomic, weak) UIViewController *viewController;
/**手势方向*/
@property (nonatomic, assign) kSZInteractiveTransitionGestureDirection direction;
/**手势类型*/
@property (nonatomic, assign) kSZInteractiveTransitionType type;
@end

@implementation kSZInteractiveTransition
+ (instancetype)interactiveTransitionWithTransitionType:(kSZInteractiveTransitionType)type GestureDirection:(kSZInteractiveTransitionGestureDirection)direction{
  
  return [[self alloc]initWithTransitionType:type GestureDirection:direction];
}
- (instancetype)initWithTransitionType:(kSZInteractiveTransitionType)type GestureDirection:(kSZInteractiveTransitionGestureDirection)direction{
  self = [super init];
  if (self) {
    _direction = direction;
    _type = type;
  }
  return self;
}

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController{
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
  self.viewController = viewController;
  [viewController.view addGestureRecognizer:pan];
  
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
  //手势百分比
  CGFloat persent = 0;
  switch (_direction) {
    case kSZInteractiveTransitionGestureDirectionLeft:{
      CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
      persent = transitionX / panGesture.view.frame.size.width;
    }
      break;
    case kSZInteractiveTransitionGestureDirectionRight:{
      CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
      persent = transitionX / panGesture.view.frame.size.width;
    }
      break;
    case kSZInteractiveTransitionGestureDirectionUp:{
      CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
      persent = transitionY / panGesture.view.frame.size.width;
    }
      break; case kSZInteractiveTransitionGestureDirectionDown:{
        CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
        persent = transitionY / panGesture.view.frame.size.width;
        
      }
      break;
    default:
      break;
  }
  
  switch (panGesture.state) {
    case UIGestureRecognizerStateBegan:
      //手势开始状态
      self.interation = YES;
      [self startGesture];
      break;
    case UIGestureRecognizerStateChanged:
      //手势过程中 通过updateInteractiveTransition设置pop过程进行的百分比
      [self updateInteractiveTransition:persent];
      break;
    case UIGestureRecognizerStateEnded:
      //手势结束状态判断移动距离是否过半 跳转或取消
      self.interation = NO;
      if (persent > 0.5) {
        [self finishInteractiveTransition];
      }else{
        [self cancelInteractiveTransition];
      }
      break;
    default:
      break;
  }
  
}
- (void)startGesture{
  switch (_type) {
    case kSZInteractiveTransitionTypePresent:
      if (_presentConifg) {
        _presentConifg();
      }
      break;
    case kSZInteractiveTransitionTypeDissmiss:
      [_viewController dismissViewControllerAnimated:YES completion:nil];
      break;
    case kSZInteractiveTransitionTypePush:
      if (_pushConifg) {
        _pushConifg();
      }
      break;
    case kSZInteractiveTransitionTypePop:
      [_viewController.navigationController popToRootViewControllerAnimated:YES];
      break;
    default:
      break;
  }
}
@end
