//
//  NearbyTableViewFrame.h
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentTableViewFrame : NSObject

//内容区域
//@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGRect nameF;

@property (nonatomic, assign) CGRect rateF;
@property (nonatomic, assign) CGRect priceF;

@property (nonatomic, assign) CGRect commentF;

@property (nonatomic, assign) CGRect avatarF;

@property (nonatomic, assign) CGRect usernameF;


@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end