//
//  AddMerchantViewController.m
//  MyComments
//
//  Created by Bruce on 15/9/27.
//
//

#import "AddMerchantViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface AddMerchantViewController ()

@property (nonatomic,strong) UITextField *name;
@property (nonatomic,strong) UITextField *category;
@property (nonatomic,strong) UITextField *location;
@property (nonatomic,strong) UITextField *address;
@property (nonatomic,strong) UITextField *tel;
@property (nonatomic,strong) UITextField *website;
@property (nonatomic,strong) UITextField *openingTime;
@property (nonatomic,strong) UITextField *spendingPerHead;

@property (nonatomic, weak) UIButton *photoButton;

@end

@implementation AddMerchantViewController

NSArray *categoryData;
NSArray *category2Data;
NSArray *category3Data;

NSArray *regionData;
NSArray *region2Data;
NSArray *region3Data;


NSString *imgurl;

NSInteger cid;
NSInteger region_id;

NSMutableArray *selectedCategory;
NSMutableArray *selectedRegion;

CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void) pageLayout{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationItem setTitle:@"Add a Merchant"];
    
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [sclView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]]];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, 780);
    [self.view addSubview:sclView];
    
    
    UITextField *name = [self createTextField:@"" Title:@"Merchant Name"];
    name.frame = CGRectMake(15,20,size.width-30,50);
    [sclView addSubview:name];
    name.delegate = self;
    self.name = name;
    
    UITextField *category = [self createTextField:@"" Title:@"Category"];
    category.frame = CGRectMake(15,90,size.width-30,50);
    [sclView addSubview:category];
    category.delegate = self;
    category.tag = 1;
    self.category = category;
    
    categoryData = [BWCommon getDataInfo:@"category"];
    category2Data = [[categoryData objectAtIndex:0] objectForKey:@"childrens"];
    category3Data = [[category2Data objectAtIndex:0] objectForKey:@"childrens"];
    
    selectedCategory = [[NSMutableArray alloc] initWithCapacity:3];
    selectedCategory[0] = [[categoryData objectAtIndex:0] objectForKey:@"cat_name"];
    selectedCategory[1] = [[category2Data objectAtIndex:0] objectForKey:@"cat_name"];
    selectedCategory[2] = [[category3Data objectAtIndex:0] objectForKey:@"cat_name"];

    
    [self setPickerView:category];
    
    UITextField *location = [self createTextField:@"" Title:@"Location"];
    location.frame = CGRectMake(15,160,size.width-30,50);
    [sclView addSubview:location];
    location.delegate = self;
    location.tag = 2;
    self.location = location;

    
    regionData = [BWCommon loadRegions:1 initData:@""];
    region2Data = [BWCommon loadRegions:[[[regionData objectAtIndex:0] objectForKey:@"region_id"] integerValue] initData:@""];
    region3Data = [BWCommon loadRegions:[[[region2Data objectAtIndex:0] objectForKey:@"region_id"] integerValue] initData:@""];
    
    selectedRegion = [[NSMutableArray alloc] initWithCapacity:3];
    selectedRegion[0] = [[regionData objectAtIndex:0] objectForKey:@"region_name"];
    selectedRegion[1] = [[region2Data objectAtIndex:0] objectForKey:@"region_name"];
    selectedRegion[2] = [[region3Data objectAtIndex:0] objectForKey:@"region_name"];
    
    [self setPickerView:location];
    
    NSInteger h = 230;
    
    UITextField *address = [self createTextField:@"" Title:@"Address"];
    address.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:address];
    address.delegate = self;
    self.address = address;
    
    h+=70;
    
    UITextField *tel = [self createTextField:@"" Title:@"Tel"];
    tel.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:tel];
    tel.delegate = self;
    self.tel = tel;
    
    h+=70;
    UITextField *website = [self createTextField:@"" Title:@"Webite"];
    website.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:website];
    website.delegate = self;
    self.website = website;
    
    h+=70;
    UITextField *openingTime = [self createTextField:@"" Title:@"Opening Time"];
    openingTime.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:openingTime];
    openingTime.delegate = self;
    self.openingTime = openingTime;
    
    h+=70;
    UITextField *spendingPerHead = [self createTextField:@"" Title:@"Spending per Head"];
    spendingPerHead.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:spendingPerHead];
    spendingPerHead.delegate = self;
    self.spendingPerHead = spendingPerHead;
    
    h+=70;
    
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(15, h, 80, 80)];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"btn_add_photo.png"] forState:UIControlStateNormal];
    [sclView addSubview:photoButton];
    
    self.photoButton = photoButton;
    [photoButton addTarget:self action:@selector(uploadTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    h+=100;

    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSubmit.frame = CGRectMake(15 , h, size.width-30, 50);
    [btnSubmit.layer setMasksToBounds:YES];
    [btnSubmit.layer setCornerRadius:5.0];
    btnSubmit.backgroundColor =[BWCommon getRGBColor:0xff0000];
    btnSubmit.tintColor = [UIColor whiteColor];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:22];
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(submitTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnSubmit];


}
- (UITextField *) createTextField:(NSString *)image Title:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.placeholder = title;
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    icon.frame = CGRectMake(20, 10, 30, 20);
    field.leftView = icon;
    field.leftViewMode = UITextFieldViewModeAlways;
    //field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

-(void) setPickerView:(UITextField *) field{
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.tag = field.tag;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneButton, nil]];
    field.inputView = pickerView;
    field.inputAccessoryView = toolBar;
}

-(void) doneTouched:(UIBarButtonItem *)sender{
    
    if([self.category resignFirstResponder] == YES){

        self.category.text = [selectedCategory componentsJoinedByString:@" - "];
        
        [self.category resignFirstResponder];
    }
    else if([self.location resignFirstResponder] == YES){
        
        self.location.text = [selectedRegion componentsJoinedByString:@" - "];
        
        [self.location resignFirstResponder];
    }
    
}

-(void) cancelTouched:(UIBarButtonItem *) sender{
    
}

-(void) submitTouched:(UIButton *) sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"addShop"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setValue:self.name.text forKey:@"name"];
    [postData setValue:[NSString stringWithFormat:@"%ld",cid] forKey:@"cid"];
    [postData setValue:[NSString stringWithFormat:@"%ld",region_id] forKey:@"region_id"];
    [postData setValue:self.openingTime.text forKey:@"opening_hours"];
    [postData setValue:self.tel.text forKey:@"tel"];
    [postData setValue:self.spendingPerHead.text forKey:@"price"];
    [postData setValue:imgurl forKey:@"original_image"];
    [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];
    
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {

        NSLog(@"%@",responseObject);
        
        [hud removeFromSuperview];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        
        if (code != 200) {
            [alert setMessage:[responseObject objectForKey:@"msg"]];
            [alert show];
        }
        else
        {
            [alert setMessage:@"Add merchant successfully."];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [alert setMessage:@"Network connection timeout."];
        [alert show];
        
        NSLog(@"请求失败");
    }];

}

-(void) uploadTouched:(UIButton *)sender{
    
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"Upload Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Gallery", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}



- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if(pickerView.tag == 1){
        return 3;
    }
    else if(pickerView.tag == 2){
        return 3;
    }

    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //return [self.items count];
    
    if(pickerView.tag == 1){
        if (component == 0){
            
            return [categoryData count];
        }
        else if(component == 1){
            return [category2Data count];
        }
        else if(component == 2){
            return [category3Data count];
        }
    }
    else if(pickerView.tag == 2){
        if (component == 0){
            
            return [regionData count];
        }
        else if(component == 1){
            return [region2Data count];
        }
        else if(component == 2){
            return [region3Data count];
        }
    }

    
    return 0;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //return [self.items objectAtIndex:row];
    
    if(pickerView.tag == 1)
    {
        if(component == 0){
            return [[categoryData objectAtIndex:row] objectForKey:@"cat_name"];

        }
        else if (component == 1){
            return [[category2Data objectAtIndex:row] objectForKey:@"cat_name"];
        }
        else if (component == 2){

            return [[category3Data objectAtIndex:row] objectForKey:@"cat_name"];
        }
        
    }
    else if(pickerView.tag == 2)
    {
        if(component == 0){
            return [[regionData objectAtIndex:row] objectForKey:@"region_name"];
            
        }
        else if (component == 1){
            return [[region2Data objectAtIndex:row] objectForKey:@"region_name"];
        }
        else if (component == 2){
            
            return [[region3Data objectAtIndex:row] objectForKey:@"region_name"];
        }
        
    }
    
    return @"";
}


-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(pickerView.tag == 1)
    {
        if(component == 0){
            
            category2Data = [[categoryData objectAtIndex:row] objectForKey:@"childrens"];
            category3Data = [[category2Data objectAtIndex:0] objectForKey:@"childrens"];
            [pickerView selectedRowInComponent:1];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            
            cid = [[[categoryData objectAtIndex:row] objectForKey:@"cid"] integerValue];
            selectedCategory[0] = [[categoryData objectAtIndex:row] objectForKey:@"cat_name"];
            selectedCategory[1] = [[category2Data objectAtIndex:0] objectForKey:@"cat_name"];
            
            if([category3Data count])
                selectedCategory[2] = [[category3Data objectAtIndex:0] objectForKey:@"cat_name"];
            else
                selectedCategory[2] = @"";

        }
        else if (component == 1){
            
            category3Data = [[category2Data objectAtIndex:row] objectForKey:@"childrens"];
            
            [pickerView selectedRowInComponent:2];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            cid = [[[category2Data objectAtIndex:row] objectForKey:@"cid"] integerValue];
            selectedCategory[1] = [[category2Data objectAtIndex:row] objectForKey:@"cat_name"];
            
            if([category3Data count])
                selectedCategory[2] = [[category3Data objectAtIndex:0] objectForKey:@"cat_name"];
            else
                selectedCategory[2] = @"";
            
        }
        else if (component == 2){
            
            cid = [[[category3Data objectAtIndex:row] objectForKey:@"cid"] integerValue];
            selectedCategory[2] = [[category3Data objectAtIndex:row] objectForKey:@"cat_name"];

        }
        
        
        //self.province.text = [selectedRegions componentsJoinedByString:@" - "];
    }
    else if(pickerView.tag == 2)
    {
        if(component == 0){
            
            region2Data = [BWCommon loadRegions:[[[regionData objectAtIndex:row] objectForKey:@"region_id"] integerValue] initData:@""];
            region3Data = [BWCommon loadRegions:[[[region2Data objectAtIndex:0] objectForKey:@"region_id"] integerValue] initData:@""];
            [pickerView selectedRowInComponent:1];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            
            region_id = [[[regionData objectAtIndex:row] objectForKey:@"region_id"] integerValue];
            selectedRegion[0] = [[regionData objectAtIndex:row] objectForKey:@"region_name"];
            selectedRegion[1] = [[region2Data objectAtIndex:0] objectForKey:@"region_name"];
            
            if([region3Data count])
                selectedRegion[2] = [[region3Data objectAtIndex:0] objectForKey:@"region_name"];
            else
                selectedRegion[2] = @"";
            
        }
        else if (component == 1){
            
            region3Data = [BWCommon loadRegions:[[[region2Data objectAtIndex:row] objectForKey:@"region_id"] integerValue] initData:@""];
            
            [pickerView selectedRowInComponent:2];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            region_id = [[[region2Data objectAtIndex:row] objectForKey:@"region_id"] integerValue];
            selectedRegion[1] = [[region2Data objectAtIndex:row] objectForKey:@"region_name"];
            
            if([region3Data count])
                selectedRegion[2] = [[region3Data objectAtIndex:0] objectForKey:@"region_name"];
            else
                selectedRegion[2] = @"";
            
        }
        else if (component == 2){
            
            region_id = [[[region3Data objectAtIndex:row] objectForKey:@"region_id"] integerValue];
            selectedRegion[2] = [[region3Data objectAtIndex:row] objectForKey:@"region_name"];
            
        }
        
    }
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        [self snapImage];
        
    }else if(buttonIndex==1){
        [self pickImage];
    }
    
}

//拍照
- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
    
    [self presentViewController:ipc animated:YES completion:^{
        
        
    }];
    
}
//从相册里找
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
    [self presentViewController:ipc animated:YES completion:^{
    }];
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        //UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    int y = (arc4random() % 1001) + 9000;
    
    NSString *fileName = [NSString stringWithFormat:@"%d%@",y,@".jpg"];
    
    [self saveImage:img WithName:fileName];
    
    NSString *fullFileName = [[self documentFolderPath] stringByAppendingPathComponent:fileName];
    
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:fullFileName];
    //NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSLog(@"%@",fileUrl);
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    ///default/app/addshopphoto
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"addshopphoto"];
    
    NSDictionary *postData = @{};

    
    [AFNetworkTool postUploadWithUrl:url fileUrl:fileUrl parameters:postData success:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        [hud removeFromSuperview];

        if (code != 200) {
            [alert setMessage:[responseObject objectForKey:@"msg"]];
            [alert show];
        }
        else
        {
            imgurl = [responseObject objectForKey:@"msg"];
            
            NSString *nimgview = [[NSString alloc] init];
            
            nimgview = [NSString stringWithFormat:@"%@/uploadfiles/%@!m80x80.jpg",[BWCommon getBaseInfo:@"site_url"],imgurl];
            NSURL *dataurl = [NSURL URLWithString:nimgview];
            
            NSLog(@"%@",dataurl);
            
            NSData* ndata = [NSData dataWithContentsOfURL:dataurl];
            
            //NSLog(@"%@",ndata);
            //[self.testImage sd_setImageWithURL:dataurl];
            
            [self.photoButton setBackgroundImage:[UIImage imageWithData:ndata] forState:UIControlStateNormal];
            
            NSLog(@"%@",imgurl);
        }
        
    } fail:^{
        
        [hud removeFromSuperview];
        
        [alert setMessage:@"Timeout,please try again."];
        [alert show];
        
        NSLog(@"请求失败");
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
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
