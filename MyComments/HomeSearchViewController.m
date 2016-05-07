//
//  HomeSearchViewController.m
//  MyComments
//
//  Created by Bruce on 16/1/23.
//
//

#import "HomeSearchViewController.h"
#import "ShopViewController.h"

@interface HomeSearchViewController ()

@end

@implementation HomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
     
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    
    ShopViewController *shopView = [[ShopViewController alloc] init];
    
    
    //__weak HomeSearchViewController *weakSelf = self;

    [self.navigationController pushViewController:shopView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
