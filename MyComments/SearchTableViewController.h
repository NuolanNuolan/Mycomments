//
//  SearchTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-2.
//
//

#import <UIKit/UIKit.h>
#import "ShopDelegate.h"

@interface SearchTableViewController : UITableViewController
{
}

@property (nonatomic,assign) id<ShopDelegate> delegate;
@end
