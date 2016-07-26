//
//  TransitionAnimations.h
//  JCProject
//
//  Created by starkShen on 16/6/15.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger,kSZTransitionMode){
  kSZTransitionModeFade = 0,/* 淡化 */
  kSZTransitionModePush,/* 推挤 */
  kSZTransitionModeReveal,/* 揭开 */
  kSZTransitionModeMoveIn,/* 覆盖 */
  kSZTransitionModeCube,/* 立方 */
  kSZTransitionModeSuck,/* 吸收 */
  kSZTransitionModeOglFlip,/* 翻转 */
  kSZTransitionModeRipple,/* 波纹 */
  kSZTransitionModePageCurl,/* 翻页 */
  kSZTransitionModePageUnCurl,/* 反翻页 */
  kSZTransitionModeCameraOpen,/* 镜头开 */
  kSZTransitionModeCameraClose,/* 镜头关 */

};


typedef NS_ENUM(NSUInteger,kSZTransitionSubType){
  kSZTransitionSubTypeFromLeft = 0,
  kSZTransitionSubTypeFromBottom,
  kSZTransitionSubTypeFromRight,
  kSZTransitionSubTypeFromTop,

};

typedef NS_ENUM(NSUInteger,kSZAnimationTransition){
  kSZAnimationTransitionCurlDown = 0,
  kSZAnimationTransitionCurlUp,
  kSZAnimationTransitionFlipFromLeft,
  kSZAnimationTransitionFlipFromRight,
};

@interface TransitionAnimations : NSObject

/** 经典转场动画 */
+ (void)transitionAnimations:(kSZTransitionMode)mode subType:(kSZTransitionSubType)subType beginWithView:(UIView *)kView0 toView:(UIView*)kView1 inSuperView:(UIView *)superView WithDuration:(CGFloat)kDuration;

+ (void)transitionAnimations:(kSZAnimationTransition)mode beginWithView:(UIView *)kView0 toView:(UIView*)kView1 inSuperView:(UIView *)superView WithDuration:(CGFloat)kDuration;


/** 翻页效果 */

@end
