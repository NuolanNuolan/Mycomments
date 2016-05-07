//
//  SearchTableViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-2.
//
//

#import <UIKit/UIKit.h>
#import "ShopDelegate.h"
#import "DetailDelegate.h"

@interface SearchTableViewController : UITableViewController
<UISearchResultsUpdating,
UISearchBarDelegate
>
{
}

@property (nonatomic,assign) id<ShopDelegate> delegate;

@property (nonatomic, strong) UISearchController *searchController;
@end
