//
//  ShopMainTableViewFrame.h
//  MyComments
//
//  Created by Bruce He on 15/7/4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShopMainTableViewFrame : NSObject

@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGRect rateF;
@property (nonatomic, assign) CGRect priceF;


@property (nonatomic, assign) CGRect rate1F;
@property (nonatomic, assign) CGRect rate2F;
@property (nonatomic, assign) CGRect rate3F;


@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end