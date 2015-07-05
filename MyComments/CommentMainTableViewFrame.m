//
//  CommentMainTableViewFrame.m
//  MyComments
//
//  Created by Bruce on 15-7-4.
//
//


#import "CommentMainTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@implementation CommentMainTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat paddingY = 10;
    CGFloat paddingX = 10;
    
    BOOL showShopName = [[data objectForKey:@"shop_name"] isEqualToString:@""] ? NO : YES;
    
    CGFloat nameX;
    CGFloat nameY;
    CGFloat usernameX;
    CGFloat usernameY;
    
    if(showShopName){
        nameX = paddingX;
        nameY = paddingY;
        CGSize nameSize = [BWCommon sizeWithString:[data objectForKey:@"shop_name"] font:NJNameFont maxSize:CGSizeMake(size.width - 20, MAXFLOAT)];
    
        self.nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
        
        usernameY = nameY+nameSize.height + paddingY;

    }
    else
    {
        usernameY = paddingY;
    }
    
    usernameX = 60 + paddingX;
    self.usernameF = CGRectMake(usernameX, usernameY, 160, 20);
    
    CGFloat rateX = usernameX;
    CGFloat rateY = usernameY + 20;
    CGFloat rateH = 15;
    self.rateF = CGRectMake(rateX, rateY, 91, rateH);
    
    CGFloat priceX = usernameX;
    CGFloat priceY = rateY + rateH ;
    CGFloat priceH = 20;
    self.priceF = CGRectMake(priceX, priceY, 200, priceH);
    
    
    CGFloat commentX = paddingX;
    CGFloat commentY = 50 + paddingY * 2;
    CGSize commentSize = [BWCommon sizeWithString:[data objectForKey:@"detail"] font:NJTextFont maxSize:CGSizeMake(size.width - 20, MAXFLOAT)];
    
    self.commentF = CGRectMake(commentX, commentY, commentSize.width, commentSize.height);
    
    CGFloat likeX = paddingX;
    CGFloat likeY = commentY + commentSize.height + paddingY;
    self.likeF = CGRectMake(likeX, likeY, 70, 15);
    
    CGFloat dateX = size.width - paddingY - 100;
    CGFloat dateY = likeY;
    self.dateF = CGRectMake(dateX, dateY, 100, 20);
    
    self.cellHeight =  50+paddingY*3 + commentSize.height + 25;
    
    
    
}

@end