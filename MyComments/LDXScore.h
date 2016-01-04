//
//  LDXScore.h
//  LDXSCore
//
//  Created by Leen on 14-10-30.
//  Copyright (c) 2014年 Hillsun Cloud Commerce Technology Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface LDXScore : UIView


/* 展示的星数 */
@property (nonatomic, assign) NSInteger show_star;
@property (nonatomic, assign) CGFloat show_score;
/* 星星之间的间隔 */
@property (nonatomic, assign) CGFloat space;


/* 距离左边的间距 */
@property (nonatomic, assign) CGFloat padding;
/* 最多的星数，默认为5 */
@property (nonatomic, assign) NSInteger max_star;
/* 是否支持选择星数 */
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIImage *normalImg;
@property (nonatomic, strong) UIImage *highlightImg;


@end
