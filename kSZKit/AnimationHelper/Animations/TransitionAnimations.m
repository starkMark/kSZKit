//
//  TransitionAnimations.m
//  JCProject
//
//  Created by starkShen on 16/6/15.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "TransitionAnimations.h"

@implementation TransitionAnimations

+ (void)transitionAnimations:(kSZTransitionMode)mode subType:(kSZTransitionSubType)subType beginWithView:(UIView *)kView0 toView:(UIView*)kView1 inSuperView:(UIView *)superView WithDuration:(CGFloat)kDuration{
  
  CATransition *animation = [CATransition animation];
  animation.delegate = self;
  animation.duration = kDuration;
  animation.timingFunction = UIViewAnimationCurveEaseInOut;
  
  switch (mode) {
    case kSZTransitionModeFade:
      /* 淡化 */
      animation.type = kCATransitionFade;
      break;
    case kSZTransitionModePush:
      /* 推挤 */
      animation.type = kCATransitionPush;
      break;
    case kSZTransitionModeReveal:
      /* 揭开 */
      animation.type = kCATransitionReveal;
      break;
    case kSZTransitionModeMoveIn:
      /* 覆盖 */
      animation.type = kCATransitionMoveIn;
      break;
    case kSZTransitionModeCube:
      /* 立方 */
      animation.type = @"cube";
      break;
    case kSZTransitionModeSuck:
      /* 吸收 */
      animation.type = @"suckEffect";
      break;
    case kSZTransitionModeOglFlip:
      /* 翻转 */
      animation.type = @"oglFlip";
      break;
    case kSZTransitionModeRipple:
      /* 波纹 */
      animation.type = @"rippleEffect";
      break;
    case kSZTransitionModePageCurl:
      /* 翻页 */
      animation.type = @"pageCurl";
      break;
    case kSZTransitionModePageUnCurl:
      /* 反翻页 */
      animation.type = @"pageUnCurl";
      break;
    case kSZTransitionModeCameraOpen:
      /* 镜头开 */
      animation.type = @"cameraIrisHollowOpen";
      break;
    case kSZTransitionModeCameraClose:
      /* 镜头关 */
      animation.type = @"cameraIrisHollowClose";
      break;
    default:
      break;
  }
  
  switch (subType) {
    case kSZTransitionSubTypeFromLeft:
      animation.subtype = kCATransitionFromLeft;
      break;
    case kSZTransitionSubTypeFromBottom:
      animation.subtype = kCATransitionFromBottom;
      break;
    case kSZTransitionSubTypeFromRight:
      animation.subtype = kCATransitionFromRight;
      break;
    case kSZTransitionSubTypeFromTop:
      animation.subtype = kCATransitionFromTop;
      break;
    default:
      animation.subtype = kCATransitionFromLeft;
      break;
  }
  
  NSUInteger beginIndex = [[superView subviews] indexOfObject:kView0];
  NSUInteger endIndex = [[superView subviews] indexOfObject:kView1];
  [superView exchangeSubviewAtIndex:beginIndex withSubviewAtIndex:endIndex];
  [[superView layer] addAnimation:animation forKey:@"animation"];
}

+ (void)transitionAnimations:(kSZAnimationTransition)mode beginWithView:(UIView *)kView0 toView:(UIView*)kView1 inSuperView:(UIView *)superView WithDuration:(CGFloat)kDuration{
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  [UIView beginAnimations:nil context:context];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:kDuration];
  switch (mode) {
    case kSZAnimationTransitionCurlDown:
       /* 下翻 */
      [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:superView cache:YES];
      break;
    case kSZAnimationTransitionCurlUp:
      /* 上翻 */
      [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:superView cache:YES];
      break;
    case kSZAnimationTransitionFlipFromLeft:
      /* 左转 */
      [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:superView cache:YES];
      break;
    case kSZAnimationTransitionFlipFromRight:
      /* 右转 */
      [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:superView cache:YES];
      break;
    default:
      break;
  }
  
  NSUInteger beginIndex = [[superView subviews] indexOfObject:kView0];
  NSUInteger endIndex = [[superView subviews] indexOfObject:kView1];
  [superView exchangeSubviewAtIndex:beginIndex withSubviewAtIndex:endIndex];
  
  [UIView setAnimationDelegate:self];
  // 动画完毕后调用某个方法
  //[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
  [UIView commitAnimations];
}

@end
