//
//  SearchResultsViewController.m
//  MyComments
//
//  Created by Bruce on 16/2/14.
//
//
#import "SearchResultsViewController.h"
#import "ShopDetailViewController.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

UIWindow* _overlayWindow;

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"SearchResultsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.searchResults[indexPath.row] objectForKey:@"name"];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // this will be the UINavigationController that provides the push animation.
    // its rootViewController is a placeholder that exists so we can actually push and pop
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController: [UIViewController new]];
    
    // the overlay window
    _overlayWindow = [[UIWindow alloc] initWithFrame: self.view.window.frame];
    _overlayWindow.rootViewController = nc;
    _overlayWindow.windowLevel = self.view.window.windowLevel+1; // appear over us
    _overlayWindow.backgroundColor = [UIColor clearColor];
    [_overlayWindow makeKeyAndVisible];
    
    // get this into the next run loop cycle:
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //UIViewController* resultDetailViewController = [UIViewController alloc];
        //resultDetailViewController.title = @"Result Detail";
        //resultDetailViewController.view.backgroundColor = [UIColor whiteColor];
        //[nc pushViewController: resultDetailViewController animated: YES];
        
        // start looking for popping-to-root:
        //nc.delegate = self;
        
        ShopDetailViewController *viewController = [[ShopDetailViewController alloc] init];
        self.detailDelegate = viewController;
        //viewController.hidesBottomBarWhenPushed = YES;
        NSInteger sid = [[self.searchResults[indexPath.row] objectForKey:@"sid"] integerValue];
        [self.detailDelegate setValue:sid];
        
        [nc pushViewController: viewController animated: YES];
        nc.delegate = self;
    });
}

- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // pop to root?  then dismiss our window.
    if ( navigationController.viewControllers[0] == viewController )
    {
        [_overlayWindow resignKeyWindow];
        _overlayWindow = nil;
    }
}

@end
