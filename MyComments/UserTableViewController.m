//
//  UserTableViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-12.
//
//

#import "UserTableViewController.h"
#import "UserTableViewCell.h"
#import "UserTableViewFrame.h"
#import "BWCommon.h"

@interface UserTableViewController ()

@property (nonatomic,strong) NSArray *statusFrames;

@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) NSMutableArray *sectionList;

@end

@implementation UserTableViewController

CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self pagelayout];
}

- (void) pagelayout{
 
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.list = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSMutableArray *menu1 = [[NSMutableArray alloc] init];
    [menu1 addObject:[self createRow:@"brucehe3" text:@"" icon:@""]];
    
    self.list[0] = menu1;
    
    NSMutableArray *menu2 = [[NSMutableArray alloc] init];
    [menu2 addObject:[self createRow:@"brucehe3" text:@"" icon:@""]];
    [menu2 addObject:[self createRow:@"brucehe3" text:@"" icon:@""]];
    [menu2 addObject:[self createRow:@"brucehe3" text:@"" icon:@""]];
    self.list[1] = menu2;
    
    NSMutableArray *menu3 = [[NSMutableArray alloc] init];
    [menu3 addObject:[self createRow:@"brucehe3" text:@"" icon:@""]];

    self.list[2] = menu3;
    
    

}
- (NSDictionary *) createRow:(NSString *) title  text: (NSString *) text icon: (NSString *) icon{
    
    NSDictionary *row = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title,@"title",text,@"text", icon,@"icon", nil];
    return row;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 1)
        return 3;
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UserTableViewCell * cell = [UserTableViewCell cellWithTableView:tableView];
    
    
    //NSLog(@"%@",self.statusFrames[indexPath.section][indexPath.row]);
    cell.viewFrame = self.statusFrames[indexPath.section][indexPath.row];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    if(indexPath.section == 0){
        if(indexPath.row>0){
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-edit"]];
            [cell.contentView addSubview:icon];
            
            if(indexPath.row==1){
                icon.frame = CGRectMake(184, 12, 24, 24);
            }else{
                icon.frame = CGRectMake(120, 12, 24, 24);
            }
        }
    }
    else if(indexPath.section==2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [BWCommon getBackgroundColor];
        
    [headerView sizeToFit];
        
    [BWCommon setTopBorder:headerView color:[BWCommon getBorderColor]];
    [BWCommon setBottomBorder:headerView color:[BWCommon getBorderColor]];
    
    return headerView;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [BWCommon getBackgroundColor];
    return footView;
}


- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.list.count];
        
        for (int i=0;i < self.list.count;i++){
            
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in [self.list objectAtIndex:i]) {
                // 创建模型
                UserTableViewFrame *vf = [[UserTableViewFrame alloc] init];
                vf.data = dict;
                //NSLog(@"%@",dict);
                [tmp addObject:vf];
            }
            
            
            [models addObject:tmp];
        }
        self.statusFrames = [models copy];
    }
    
    
    return _statusFrames;
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
