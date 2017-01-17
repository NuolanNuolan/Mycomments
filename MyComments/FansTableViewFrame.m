//
//  NearbyTableViewFrame.m
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//


#import "FansTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@implementation FansTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    //CGRect rect = [[UIScreen mainScreen] bounds];
    //CGSize size = rect.size;
    
    CGFloat paddingY = 10;
    CGFloat paddingX = 10;
    
    
    CGFloat nameX = 50+paddingX*2;
    CGFloat nameY = paddingY;
    CGSize nameSize = [self sizeWithString:[data objectForKey:@"username"] font:NJNameFont maxSize:CGSizeMake(230, MAXFLOAT)];
    
    self.nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    CGFloat rateX = nameX;
    CGFloat rateY = nameY+nameSize.height + 5;
    CGFloat rateH = 15;
    CGFloat rateW = 91;
    
    self.rateF = CGRectMake(rateX, rateY, rateW, rateH);
    
    CGFloat introX = nameX;
    CGFloat introY = rateY + rateH + paddingY;
    
    
    if(![[data objectForKey:@"intro"] isEqual:[NSNull null] ] ){
        CGSize introSize = [self sizeWithString:[data objectForKey:@"intro"] font:NJTextFont maxSize:CGSizeMake(230,MAXFLOAT)];
        self.introF = CGRectMake(introX,introY,introSize.width,introSize.height);
        
        self.cellHeight =  MAX(50+paddingY*2, introY + introSize.height +paddingY);
        
    }else{
        self.introF = CGRectMake(introX, introY, 0, 0);
        
        self.cellHeight =  MAX(50+paddingY*2, introY  +paddingY);
    }
    
    

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
