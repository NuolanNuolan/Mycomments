//
//  NearbyTableViewFrame.m
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//


#import "CommentTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@implementation CommentTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat paddingY = 10;
    CGFloat paddingX = 10;
    
    
    CGFloat nameX = 90+paddingX*2;
    CGFloat nameY = paddingY;
    CGSize nameSize = [self sizeWithString:[data objectForKey:@"shop_name"] font:NJNameFont maxSize:CGSizeMake(230, MAXFLOAT)];
    
    self.nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    CGFloat rateX = nameX;
    CGFloat rateY = nameY+nameSize.height + paddingY;
    CGFloat rateH = 15;
    
    self.rateF = CGRectMake(rateX, rateY, 91, rateH);
    
    CGFloat priceX = nameX;
    CGFloat priceY = rateY + rateH + paddingY;
    CGFloat priceH = 20;
    self.priceF = CGRectMake(priceX, priceY, 80, priceH);
    
    
    CGFloat commentX = paddingX;
    CGFloat commentY = 90 + paddingY * 2;
    CGSize commentSize = [self sizeWithString:[data objectForKey:@"detail"] font:NJTextFont maxSize:CGSizeMake(size.width - 20, MAXFLOAT)];
    
    self.commentF = CGRectMake(commentX, commentY, commentSize.width, commentSize.height);
    
    CGFloat avatarW = 50;
    CGFloat avatarX = size.width - paddingY - avatarW;
    CGFloat avatarY = rateY;
    self.avatarF = CGRectMake(avatarX, avatarY, avatarW, avatarW);
    
    CGSize usernameSize = [self sizeWithString:[data objectForKey:@"username"] font:NJTextFont maxSize:CGSizeMake(100, MAXFLOAT)];
    
    CGFloat usernameX = size.width - avatarW - paddingY*2 - usernameSize.width;
    CGFloat usernameY = rateY + 35;
    self.usernameF = CGRectMake(usernameX, usernameY, usernameSize.width, usernameSize.height);

    
    self.cellHeight =  90+paddingY*3 + commentSize.height;
    
    
    
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
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
