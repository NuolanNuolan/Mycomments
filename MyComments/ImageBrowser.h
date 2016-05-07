//
//  ImageBrowser.h
//  MyComments
//
//  Created by Bruce on 16/1/24.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageBrowser : NSObject
/**
 *  @brief  浏览头像
 *
 *  @param  oldImageView    头像所在的imageView
 */
+(void)showImage:(UIImageView *) avatarImageView;

@end