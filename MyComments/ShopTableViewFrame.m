//
//  NearbyTableViewFrame.m
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//


#import "ShopTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@implementation ShopTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat paddingY = 10;
    CGFloat paddingX = 10;
    
    
    CGFloat nameX = 90+paddingX*2;
    CGFloat nameY = paddingY;
    CGSize nameSize = [self sizeWithString:[data objectForKey:@"name"] font:NJNameFont maxSize:CGSizeMake(230, MAXFLOAT)];
    
    self.nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    CGFloat rateX = nameX;
    CGFloat rateY = nameY+nameSize.height + paddingY;
    CGFloat rateH = 15;
    CGFloat rateW = 91;
    
    self.rateF = CGRectMake(rateX, rateY, rateW, rateH);
    
    CGFloat priceX = rateX+rateW+paddingX;
    CGFloat priceY = rateY;
    CGFloat priceH = 20;
    self.priceF = CGRectMake(priceX, priceY, 80, priceH);
    
    
    CGFloat tagX = rateX;
    CGFloat tagY = rateY +rateH + paddingY;
    CGSize tagSize = [self sizeWithString:[data objectForKey:@"tags"] font:NJTextFont maxSize:CGSizeMake(200, MAXFLOAT)];
    
    self.tagF = CGRectMake(tagX, tagY, tagSize.width, tagSize.height);

    
    self.cellHeight =  MAX(90+paddingY*2, tagY + tagSize.height+paddingY);
    
    CGFloat distanceX = size.width - paddingY - 100;
    CGFloat distanceY = self.cellHeight - 30;
    self.distanceF = CGRectMake(distanceX, distanceY, 100, 20);
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
