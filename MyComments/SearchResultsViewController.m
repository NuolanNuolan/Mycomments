//
//  SearchResultsViewController.m
//  MyComments
//
//  Created by Bruce on 16/2/14.
//
//
#import "SearchResultsViewController.h"
#import "ShopDetailViewController.h"
#import "BWCommon.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController


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
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        ShopDetailViewController *viewController = [[ShopDetailViewController alloc] init];
        self.detailDelegate = viewController;
        viewController.isPresentview=YES;
        NSInteger sid = [[self.searchResults[indexPath.row] objectForKey:@"sid"] integerValue];
        [self.detailDelegate setValue:sid];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:YES completion:nil];
    });
}


@end
