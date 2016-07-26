//
//  Animations.h
//
//  Created by stark on 15/7/7.
//  Copyright (c) 2015年 Jame. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Animations : UIViewController{

}

+ (void)moveUp:(UIView *)view andAnimationDuration:(float) timeDuration viewCenter:(CGPoint *)center duration:(float) Duration;

+ (void)zoomIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;
+ (void)buttonPressAnimate: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;

+ (void)fadeIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;
+ (void)fadeOut: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;

+ (void) moveLeft: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;
+ (void) moveRight: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;

+ (void) moveUp: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;
+ (void) moveDown: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;

+ (void) rotate: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andAngle:(int) angle;

+ (void) frameAndShadow: (UIView *) view;
+ (void) shadowOnView: (UIView *) view andShadowType: (NSString *) shadowType;

+ (void) background: (UIView *) view andImageFileName: (NSString *) filename;
+ (void) roundedCorners: (UIView *) view;

/** 翻转 */
+ (void)rotateWithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount animationView:(UIView *)animationView;

@end
