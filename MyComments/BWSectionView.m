//
//  BWSectionView.m
//  MyComments
//
//  Created by Bruce He on 15/7/3.
//
//

#import "BWSectionView.h"


#define APP_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width   // 屏幕的宽度

@interface BWSectionView()

@end

@implementation BWSectionView


+ (CGFloat)getSectionHeight
{
    return 44;
}

- (void)setFrame:(CGRect)frame{
    MYLOG(@"_______ frame = %@",NSStringFromCGRect(frame));
    
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame)); [super setFrame:newFrame];
}




@end
