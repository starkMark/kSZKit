//
//  PresentTransitionAnimation.h
//  JCProject
//
//  Created by pg on 16/6/16.
//  Copyright © 2016年 Facebook. All rights reserved.
//
/**
 1.<kSZPesentedOneControllerDelegate>
 2.@property (nonatomic, strong) kSZInteractiveTransition *interactivePush;
 3.    _interactivePush = [kSZInteractiveTransition interactiveTransitionWithTransitionType:kSZInteractiveTransitionTypePresent GestureDirection:kSZInteractiveTransitionGestureDirectionUp];
 
 typeof(self)weakSelf = self;
 _interactivePush.presentConifg = ^(){
   [weakSelf present];
 };
 [_interactivePush addPanGestureForViewController:self.navigationController];
 
 4 presentedVC.delegate = self;
 5.- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent{
 return _interactivePush;
 }
 */
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, kSZPageCoverTransitionType) {
  kSZPageCoverTransitionTypePush = 0,
  kSZPageCoverTransitionTypePop
};


@protocol kSZPesentedOneControllerDelegate <NSObject>

- (void)presentedOneControllerPressedDissmiss;
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;

@end


@interface PresentTransitionAnimation : NSObject<
UIViewControllerAnimatedTransitioning>
/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) kSZPageCoverTransitionType type;
@property (nonatomic, assign, getter=isPopInitialized) BOOL popInitialized;
/**
 *  初始化动画过渡代理
 * @prama type 初始化pop还是push的代理
 */
+ (instancetype)transitionWithType:(kSZPageCoverTransitionType)type;
- (instancetype)initWithTransitionType:(kSZPageCoverTransitionType)type;
@end
