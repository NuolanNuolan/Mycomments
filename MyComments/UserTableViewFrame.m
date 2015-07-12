//
//  FinanceTableViewFrame.m
//  hxm
//
//  Created by Bruce on 15-6-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "UserTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:12]


@implementation UserTableViewFrame

- (void)setData:(NSDictionary *) data{
    
    _data = data;
    
    
    CGSize textSize = [self sizeWithString:[data objectForKey:@"title"] font:NJNameFont maxSize:CGSizeMake(220, MAXFLOAT)];
    
    self.textF = CGRectMake(10, 10, textSize.width, textSize.height);
    
    self.valueF = CGRectMake(textSize.width + 62, 14, 200, 20);
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
