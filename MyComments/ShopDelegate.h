//
//  ShopDelegate.h
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//


#import <Foundation/Foundation.h>

@protocol ShopDelegate <NSObject>

-(void) setValue: (NSUInteger) region_id cid: (NSUInteger) cid region_name: (NSString *) region_name cat_name:(NSString *) cat_name;

@end