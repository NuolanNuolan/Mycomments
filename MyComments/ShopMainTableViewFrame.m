//
//  ShopMainTableViewFrame.m
//  MyComments
//
//  Created by Bruce He on 15/7/4.
//
//

#import "ShopMainTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@implementation ShopMainTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat paddingY = 10;
    CGFloat paddingX = 10;
    
    
    CGFloat nameX = paddingX;
    CGFloat nameY = paddingY;
    CGSize nameSize = [BWCommon sizeWithString:[data objectForKey:@"name"] font:NJNameFont maxSize:CGSizeMake(size.width - 20, MAXFLOAT)];
    
    self.nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    CGFloat imageX = paddingX;
    CGFloat imageY = nameY + nameSize.height + paddingY;
    CGFloat imageW = 125;
    self.imageF = CGRectMake(imageX, imageY, imageW, 83);
    
    CGFloat rateX = 125 + paddingX*2;
    CGFloat rateY =nameSize.height + paddingY *2;
    CGFloat rateH = 15;
    CGFloat rateW = 91;
    self.rateF = CGRectMake(rateX, rateY, rateW, rateH);
    
    CGFloat priceX = rateX;
    CGFloat priceY = rateY + rateH;
    self.priceF = CGRectMake(priceX, priceY, 100, 20);
    
    CGFloat rate1X = priceX;
    CGFloat rate1Y = priceY + 20;
    CGFloat rate1H = 20;
    CGFloat rate1W = size.width - paddingY*3 - imageW;
    self.rate1F = CGRectMake(rate1X, rate1Y, rate1W, rate1H);
    
    CGFloat rate2Y = rate1Y + rate1H;
    self.rate2F = CGRectMake(rate1X, rate2Y,rate1W, rate1H);
    
    CGFloat rate3Y = rate2Y + rate1H;
    self.rate3F = CGRectMake(rate1X, rate3Y,rate1W, rate1H);
    
    self.cellHeight =  nameY + nameSize.height+paddingY + 90 + paddingY;

}

@end
