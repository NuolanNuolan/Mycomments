//
//  HttpEngine.m
//  MyComments
//
//  Created by Eason on 17/1/18.
//
//

#import "HttpEngine.h"

@implementation HttpEngine
//删除评论
+(void)DeleteComments:(NSString * )username withcid:(NSInteger )cid complete:(void(^)(NSString * issucc))complete
{

    AFHTTPSessionManager *magager = [AFHTTPSessionManager manager];
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"deletecomment"];
    NSDictionary*parameters=@{@"username":username,@"cid":[NSNumber numberWithInteger:cid]};
    [magager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        MYLOG(@"%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            complete(@"succ");
        }else
        {
        
            complete(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MYLOG(@"%@",error);
        complete(@"Error,Please try again later");
    }];
    
    
}
@end
