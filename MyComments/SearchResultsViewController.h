//
//  SearchResultsViewController.h
//  MyComments
//
//  Created by Bruce on 16/2/14.
//
//

#import <UIKit/UIKit.h>
#import "DetailDelegate.h"
@interface SearchResultsViewController : UITableViewController
<UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic,assign) id<DetailDelegate> detailDelegate;
@end
