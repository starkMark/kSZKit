//
//  UIView+kSZCategory.h
//  JCProject
//
//  Created by pg on 16/6/16.
//  Copyright © 2016年 StarkShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (kSZCategory)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign, readonly) CGFloat bottomFromSuperView;

- (void)setAnchorPointTo:(CGPoint)point;

@end
