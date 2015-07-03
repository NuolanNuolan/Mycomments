//
//  BWSectionView.h
//  MyComments
//
//  Created by Bruce He on 15/7/3.
//
//

#import <UIKit/UIKit.h>

@interface BWSectionView : UIView

@property NSUInteger section;

@property (nonatomic, weak) UITableView *tableView;


+ (CGFloat)getSectionHeight;

@end
