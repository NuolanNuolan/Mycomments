//
//  NearbyTableViewFrame.h
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShopTableViewFrame : NSObject

@property (nonatomic, assign) CGRect nameF;

@property (nonatomic, assign) CGRect rateF;
@property (nonatomic, assign) CGRect priceF;


@property (nonatomic, assign) CGRect distanceF;

@property (nonatomic, assign) CGRect tagF;


@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end