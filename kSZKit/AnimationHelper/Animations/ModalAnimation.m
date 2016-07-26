//
//  ModalDismissAnimation.m
//  TransitionTest
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//  展现时抖动动画 消失时掉叶子动画

#import "ModalAnimation.h"

@implementation ModalAnimation {
    UIView *_coverView;
    NSArray *_constraints;
}

#pragma mark - Animated Transitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //The view controller's view that is presenting the modal view
    UIView *containerView = [transitionContext containerView];
    
    if (self.type == AnimationTypePresent) {
        //The modal view itself
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        //View to darken the area behind the modal view
        if (!_coverView) {
            _coverView = [[UIView alloc] initWithFrame:containerView.frame];
            _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.88];
            _coverView.alpha = 0.0;
        } else _coverView.frame = containerView.frame;
        [containerView addSubview:_coverView];
        
        //Using autolayout to position the modal view
        modalView.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:modalView];
        NSDictionary *views = NSDictionaryOfVariableBindings(containerView, modalView);
        //  弹窗自动布局宽度 add by shen.zheng
        NSString *visualFomat = [NSString stringWithFormat:@"H:|-%f-[modalView]-%f-|",(SCREEN_WIDTH-320)/2,(SCREEN_WIDTH-320)/2];
        _constraints = [[NSLayoutConstraint constraintsWithVisualFormat:visualFomat options:0 metrics:nil views:views] arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[modalView]-20-|" options:0 metrics:nil views:views]];
        [containerView addConstraints:_constraints];
        
        //Move off of the screen so we can slide it up
        CGRect endFrame = modalView.frame;
        modalView.frame = CGRectMake(endFrame.origin.x, containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
        [containerView bringSubviewToFront:modalView];
        
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
            modalView.frame = endFrame;
            _coverView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
//    else if (self.type == AnimationTypeDismiss) {
//        //获取动画视图 The modal view itself
//        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
//        //Grab a snapshot of the modal view for animating
//        UIView *snapshot = [modalView snapshotViewAfterScreenUpdates:NO];
//        snapshot.frame = modalView.frame;
//        [containerView addSubview:snapshot];
//        [containerView bringSubviewToFront:snapshot];
//        [modalView removeFromSuperview];
        
//        CGRect endFrame = modalView.frame;
//        modalView.frame = CGRectMake(endFrame.origin.x, containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
//        [containerView bringSubviewToFront:modalView];

//        CGRect endFrame = modalView.frame;
//        modalView.frame = CGRectMake(endFrame.origin.x, -containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
//        [containerView sendSubviewToBack:modalView];
//

//        //Animate using spring animation
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:1.0 options:0 animations:^{
//            modalView.frame = endFrame;
//            _coverView.alpha = 0.0;
//
//        } completion:^(BOOL finished) {
    
//    [modalView removeFromSuperview];
//            [_coverView removeFromSuperview];
//            [containerView removeConstraints:_constraints];
//            [transitionContext completeTransition:NO];

//        }];
        
       
//    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == AnimationTypePresent) return 1.0;
    else if (self.type == AnimationTypeDismiss) return 1.75;
    else return [super transitionDuration:transitionContext];
}

@end
