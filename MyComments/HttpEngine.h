//
//  HttpEngine.h
//  MyComments
//
//  Created by Eason on 17/1/18.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface HttpEngine : NSObject


//删除评论
+(void)DeleteComments:(NSString * )username withcid:(NSInteger )cid complete:(void(^)(NSString * issucc))complete;
@end
