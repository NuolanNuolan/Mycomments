//
//  BWCommon.m
//  pinpintong
//
//  Created by Bruce He on 15-4-4.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "BWCommon.h"
#import "AFNetworkTool.h"

@implementation BWCommon

+(float) getSystemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


+(NSString *) getBaseInfo:(id) key{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"baseinfo" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString * value;
    
    value = [data objectForKey:key];
    
    return value;
}

+(void) setUserInfo:(NSString *) key value:(NSString *) value{
    
    NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
    [udata setObject:value forKey:key];
    [udata synchronize];

}

+(id) getUserInfo:(NSString *)key
{
    NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
    
    return [udata objectForKey:key];
}

+(void) logout{
    NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
    
    [udata removeObjectForKey:@"username"];
    [udata removeObjectForKey:@"uid"];
    [udata synchronize];
}

+(NSString *) getRegionById:(NSUInteger )region_id{
    
    NSArray *regions = [BWCommon getDataInfo:@"regions"];
    for (int i=0;i<[regions count];i++){
        NSDictionary *item = [[NSDictionary alloc] initWithDictionary:[regions objectAtIndex:i]];
        if ([[item objectForKey:@"region_id"] integerValue] == region_id) {
            return [item objectForKey:@"region_name"];
            //[data setObject:[item objectForKey:@"region_name"] forKey:[item objectForKey:@"region_id"]];
        }
    }
    
    return @"";
    
}


+(NSUInteger) getParentIdById:(NSUInteger )region_id{
    
    NSArray *regions = [BWCommon getDataInfo:@"regions"];
    for (int i=0;i<[regions count];i++){
        NSDictionary *item = [[NSDictionary alloc] initWithDictionary:[regions objectAtIndex:i]];
        if ([[item objectForKey:@"region_id"] integerValue] == region_id) {
            return [[item objectForKey:@"parent_id"] integerValue];

        }
    }
    
    return 0;
    
}

+(BOOL) isLoggedIn{
    
    return [self getUserInfo:@"uid"] != nil;
}

+(void) loadCommonData{
    [self setCommonData];
}
//实际还是从NSUserDefaults中获取
+(id) getDataInfo:(NSString *)key
{
    return [self getUserInfo:key];
}

+(void) setCommonData{
    //如果地区不存在 则重新加载
    if ([self getDataInfo:@"popular_city"] != nil) {
        return;
    }
    
    NSString *api_url = [self getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"index"];
    
    
    [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *common = [json objectForKey:@"data"];
            NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
            [udata setObject:[common objectForKey:@"popular_city"] forKey:@"popular_city"];
            [udata setObject:[common objectForKey:@"regions"] forKey:@"regions"];
            [udata setObject:[common objectForKey:@"category"] forKey:@"category"];
            [udata synchronize];
        }

    } fail:^{
        NSLog(@"common data 请求失败");
    }];
    
    
}


+(void) setRegionData{
    //如果地区不存在 则重新加载
    if ([self getDataInfo:@"regions"] != nil) {
        return;
    }
    
    NSString *api_url = [self getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"common/getRegions"];
    
    NSDictionary *postData = [BWCommon getCommonTokenData];

    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        if (errNo == 0) {
            NSArray *regions = [responseObject objectForKey:@"data"];
            NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
            [udata setObject:regions forKey:@"regions"];
            [udata synchronize];
        }
    } fail:^{
        
        NSLog(@"请求失败");
    }];
    
    
}


+(NSMutableArray *) loadRegions:(NSInteger) parent_id initData:(NSString *)name{
    NSArray *regions = [BWCommon getDataInfo:@"regions"];

    NSMutableArray * data = [[NSMutableArray alloc] init];
    if(![name isEqualToString:@""])
    {
        NSDictionary *item = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"region_name",0,@"region_id", nil];
        [data addObject:item];
    }
    for (int i=0;i<[regions count];i++){
        NSDictionary *item = [[NSDictionary alloc] initWithDictionary:[regions objectAtIndex:i]];
        if ([[item objectForKey:@"parent_id"] integerValue] == parent_id) {
            
            [data addObject:item];
            
            //[data setObject:[item objectForKey:@"region_name"] forKey:[item objectForKey:@"region_id"]];
            
        }
    }
    
    return data;
}




+(UIColor *) getBackgroundColor{
    
    return [UIColor colorWithRed:240/255.0f green:240/255.0f blue:250/255.0f alpha:1];
}

+(UIColor *) getMainColor{
    return [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1];
}
+(UIColor *) getBorderColor{
    return [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
}
+(UIColor *) getRedColor{
    return [UIColor colorWithRed:255/255.0f green:89/255.0f blue:24/255.0f alpha:1];
}

+(void) setTopBorder:(UIView *)view color:(UIColor *)color{

    [view sizeToFit];
    CALayer* layer = [view layer];
    CALayer *topBorder = [CALayer layer];
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1, 0, layer.frame.size.width, 1);
    [topBorder setBorderColor:color.CGColor];
    [layer addSublayer:topBorder];

}
+(void) setBottomBorder:(UIView *)view color:(UIColor *)color{
    
    [view sizeToFit];
    
    CALayer* layer = [view layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:color.CGColor];
    [layer addSublayer:bottomBorder];
}

+(void) setRightBorder:(UIView *)view color:(UIColor *)color{
    
    [view sizeToFit];
    
    CALayer* layer = [view layer];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(layer.frame.size.width-1, 0, 1, layer.frame.size.height);
    [rightBorder setBorderColor:color.CGColor];
    [layer addSublayer:rightBorder];
}

+(void) syncUserInfo{
    //如果地区不存在 则重新加载
    NSString *api_url = [self getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"user/getUserInfoById"];
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/getUserInfoById"];

    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        if (errNo == 0) {
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            //NSDictionary *userInfo = [responseObject objectForKey:@"data"];
            [BWCommon setUserInfo:@"link_mobile" value:[[responseObject objectForKey:@"data"] objectForKey:@"link_mobile"] ];
        }
    } fail:^{
        
        NSLog(@"请求失败");
    }];
}
+(NSMutableDictionary *) getCommonTokenData{


    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] ];
    
    NSString *seckey = [self md5:@"hwxappapi_2015_jw"];
    
    
    NSInteger timeintval = [timestamp integerValue];
    NSInteger s1 = timeintval % 11;
    NSInteger s2 = timeintval % 19;
    NSInteger start = MIN(s1,s2);
    NSInteger end = MAX(s1,s2);
    
    seckey = [self md5:[seckey substringWithRange:NSMakeRange(start,end)]];
    
    [data setValue:timestamp forKey:@"time"];
    [data setValue:seckey forKey:@"seckey"];
    
    return data;
    
}

+(NSMutableDictionary *) getTokenData:(NSString *) api
{
    //NSString *api_url = [self getBaseInfo:@"api_url"];
    //NSString *url =  [api_url stringByAppendingString:api];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] ];
    
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@",[api lowercaseString],timestamp,[self getUserInfo:@"user_key"]];
    
    NSString *seckey = [self md5:@"hwxappapi_2015_jw"];
    
    
    NSInteger timeintval = [timestamp integerValue];
    NSInteger s1 = timeintval % 11;
    NSInteger s2 = timeintval % 19;
    NSInteger start = MIN(s1,s2);
    NSInteger end = MAX(s1,s2);
    
    seckey = [self md5:[seckey substringWithRange:NSMakeRange(start,end)]];
    
    

    //init token
    NSString *token = [self md5:str];
    
    NSLog(@"%@",[self getUserInfo:@"user_key"]);
    NSLog(@"%@",timestamp);
    NSLog(@"%@",str);
    NSLog(@"%@",token);
    NSLog(@"%@",seckey);
    
    [data setValue:[BWCommon getUserInfo:@"hxm_uid"] forKey:@"user_id"];
    [data setValue:timestamp forKey:@"time"];
    [data setValue:token forKey:@"token"];
    [data setValue:seckey forKey:@"seckey"];

    return data;
}


+(UIColor *) getRGBColor:(NSInteger) rgbValue{
    return [UIColor \
                               colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                               green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
     blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str
{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}


/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+(MBProgressHUD *) getHUD{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[BWCommon getCurrentVC].view animated:YES];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
    UIImageView *loadingLogo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_home"]];
    loadingLogo.frame = CGRectMake(20, 0, 34, 24);
    [loadingView addSubview:loadingLogo];
    //loadingLogo.frame = CGRectMake(10, 0, 40, 40);
    /*UILabel *loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 60, 20)];
     [loadingText setTextAlignment:NSTextAlignmentCenter];
     [loadingText setTextColor:[UIColor whiteColor]];
     [loadingText setText:@"加载中.."];
     [loadingText setFont:[UIFont systemFontOfSize:12]];
     [loadingView addSubview:loadingText];*/
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [(UIActivityIndicatorView *)indicator startAnimating];
    
    indicator.frame = CGRectMake(35, 55, 10, 10);
    [loadingView addSubview:indicator];
    
    
    hud.customView = loadingView;
    hud.mode = MBProgressHUDModeCustomView;
    //hud.backgroundColor = [UIColor grayColor];
    //hud.opacity = 0.6;
    //hud.opaque = YES;
    
    return hud;
}


@end