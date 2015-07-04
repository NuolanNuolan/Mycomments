//
//  ShopDelegate.h
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//


#import <Foundation/Foundation.h>

@protocol ShopDelegate <NSObject>

-(void) setValue: (NSUInteger) region_id cid: (NSUInteger) cid;

@end