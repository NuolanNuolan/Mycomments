//
//  BWCommon.h
//  pinpintong
//
//  Created by Bruce He on 15-4-4.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#ifndef pinpintong_BWCommon_h
#define pinpintong_BWCommon_h


#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"

@interface BWCommon : NSObject

+(float) getSystemVersion;
+(NSString *) getBaseInfo:(NSString *) key;

+(id) getUserInfo:(NSString *) key;

+(void) syncUserInfo;

+(BOOL) isLoggedIn;
+(void) logout;

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

+(void) loadCommonData;

+(void) setCommonData;

+(void) setRegionData;

+(NSMutableArray *) loadRegions:(NSInteger) parent_id initData:(NSString *) name;

//+(NSMutableArray *) loadCategory:(NSInteger) parent_id initData:(NSString *) name;

+(NSString *) getRegionById:(NSUInteger ) region_id;
+(NSUInteger) getParentIdById: (NSUInteger) region_id;

+(id) getDataInfo:(NSString *) key;
+(void) setUserInfo:(NSString *) key value:(NSString *) value;

+(UIColor *) getRGBColor: (NSInteger) rgbValue;
+(UIColor *) getBackgroundColor;
+(UIColor *) getMainColor;
+(UIColor *) getBorderColor;
+(UIColor *) getRedColor;
+(void) setTopBorder:(UIView *)view color:(UIColor *)color;
+(void) setBottomBorder:(UIView *)view color:(UIColor *)color;
+(void) setRightBorder:(UIView *)view color:(UIColor *)color;


+(NSMutableDictionary *) getCommonTokenData;
+(NSMutableDictionary *) getTokenData:(NSString *) api;

+(NSString *) md5: (NSString *) str;

+ (UIViewController *)getCurrentVC;

+(MBProgressHUD *)getHUD;

@end
