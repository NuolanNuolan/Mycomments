//
//  CommentMainTableViewFrame.h
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentMainTableViewFrame : NSObject

//内容区域
//@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGRect nameF;

@property (nonatomic, assign) CGRect rateF;
@property (nonatomic, assign) CGRect priceF;

@property (nonatomic, assign) CGRect commentF;

@property (nonatomic, assign) CGRect avatarF;

@property (nonatomic, assign) CGRect usernameF;

@property (nonatomic,assign) CGRect likeF;

@property (nonatomic,assign) CGRect removeF;

@property (nonatomic, assign) CGRect dateF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end