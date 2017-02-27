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
@property (nonatomic,strong) UIButton *btnHalal;
@property (nonatomic,strong) UIButton *btnWifi;
@property (nonatomic,strong) UIButton *btnPs;

@property (nonatomic,strong) UIScrollView *photoView;

@property (nonatomic, weak) UIButton *photoButton;

@property (nonatomic,retain) NSMutableArray * photoArray;
@property (nonatomic,retain) NSMutableArray * photoDataArray;

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

NSInteger muploaded_number = 0;
NSInteger muploading_number = 0;

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
    
    
    self.photoArray = [[NSMutableArray alloc] init];
    self.photoDataArray = [[NSMutableArray alloc] init];
    //第一个
    UITextField *name = [self createTextField:@"" Title:@"Merchant Name"];
    name.frame = CGRectMake(15,20,size.width-30,50);
    [sclView addSubview:name];
    name.delegate = self;
    self.name = name;
    //第二个
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
    //第三个
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
    //第四个
    UITextField *address = [self createTextField:@"" Title:@"Address"];
    address.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:address];
    address.delegate = self;
    self.address = address;
    
    h+=70;
    //第五个
    UITextField *tel = [self createTextField:@"" Title:@"Tel"];
    tel.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:tel];
    tel.delegate = self;
    self.tel = tel;
    
    h+=70;
    //第六个
    UITextField *website = [self createTextField:@"" Title:@"Webite"];
    website.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:website];
    website.delegate = self;
    self.website = website;
    
    h+=70;
    //第七个
    UITextField *openingTime = [self createTextField:@"" Title:@"Opening Time"];
    openingTime.frame = CGRectMake(15,h,size.width-30,50);
    [sclView addSubview:openingTime];
    openingTime.delegate = self;
    self.openingTime = openingTime;
    
    h+=70;
    
    UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(30, h, 40, 30)];
    [tags setText:@"Tags"];
    [sclView addSubview:tags];
    [tags setTextColor:[BWCommon getRGBColor:0x666666]];
    
    UIButton *btnHalal = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHalal.frame = CGRectMake(100, h, 27, 27);
    [btnHalal setBackgroundImage:[UIImage imageNamed:@"halal.gif"] forState:UIControlStateNormal];
    [btnHalal setBackgroundImage:[UIImage imageNamed:@"halal_gray.gif"] forState:UIControlStateSelected];
    [btnHalal addTarget:self action:@selector(tagsTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnHalal];
    self.btnHalal = btnHalal;
    
    UIButton *btnWifi = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWifi.frame = CGRectMake(140, h, 27, 27);
    [btnWifi setBackgroundImage:[UIImage imageNamed:@"wifi.gif"] forState:UIControlStateNormal];
    [btnWifi setBackgroundImage:[UIImage imageNamed:@"wifi_gray.gif"] forState:UIControlStateSelected];
    [btnWifi addTarget:self action:@selector(tagsTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnWifi];
    self.btnWifi = btnWifi;

    
    UIButton *btnPs = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPs.frame = CGRectMake(180, h, 27, 27);
    [btnPs setBackgroundImage:[UIImage imageNamed:@"ps.gif"] forState:UIControlStateNormal];
    [btnPs setBackgroundImage:[UIImage imageNamed:@"ps_gray.gif"] forState:UIControlStateSelected];
    [btnPs addTarget:self action:@selector(tagsTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnPs];
    self.btnPs = btnPs;

    
    
    h+=60;
    
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(15, h, 80, 80)];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"btn_add_photo.png"] forState:UIControlStateNormal];
    [sclView addSubview:photoButton];
    
    self.photoButton = photoButton;
    [photoButton addTarget:self action:@selector(uploadTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIScrollView *photoView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, h, size.width-120, 80)];
    photoView.bounces=NO;
    photoView.showsVerticalScrollIndicator = NO;
    photoView.contentSize = CGSizeMake(size.width, 80);
    photoView.scrollEnabled = YES;
    [sclView addSubview:photoView];
    
    self.photoView = photoView;

    
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

    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
    
}

-(void) tagsTouched:(UIButton *) sender{
    
    if(sender.selected){
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
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

    if([self.name.text isEqualToString:@""]){
        [alert setMessage:@"Please input merchant name"];
        [alert show];
        return;
    }
    
    if(cid==0){
        [alert setMessage:@"Please select category"];
        [alert show];
        return;
    }
    
    if(region_id==0){
        [alert setMessage:@"Please select location"];
        [alert show];
        return;
    }
    

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"addShop"];
    
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    if(self.btnHalal.selected){
        [tags addObject:@"halal"];
    }
    if(self.btnWifi.selected){
        [tags addObject:@"wifi"];
    }
    if(self.btnPs.selected){
        [tags addObject:@"delivery"];
    }
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setValue:self.name.text forKey:@"name"];
    [postData setValue:[NSString stringWithFormat:@"%ld",cid] forKey:@"cid"];
    [postData setValue:[NSString stringWithFormat:@"%ld",region_id] forKey:@"region_id"];
    [postData setValue:self.openingTime.text forKey:@"opening_hours"];
    [postData setValue:self.tel.text forKey:@"tel"];
    //[postData setValue:self.spendingPerHead.text forKey:@"price"];
    [postData setValue:imgurl forKey:@"original_image"];
    [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];
    [postData setValue:[tags componentsJoinedByString:@","] forKey:@"my_tags"];
    
    [postData setValue:self.website.text forKey:@"website"];
    [postData setValue:self.address.text forKey:@"address"];
    
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {

        MYLOG(@"%@",responseObject);
        
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
        
        MYLOG(@"请求失败");
    }];

}

-(void) uploadTouched:(UIButton *)sender{
    
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"Upload Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Gallery", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        //[pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
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
        
        MYLOG(@"%ld",(long)cid);
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
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 5;
    imagePickerController.prompt = @"Maximum 5 photos";
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.assetCollectionSubtypes = @[
                                                      @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                                                      @(PHAssetCollectionSubtypeAlbumMyPhotoStream), // My Photo Stream
                                                      @(PHAssetCollectionSubtypeSmartAlbumPanoramas), // Panoramas
                                                      @(PHAssetCollectionSubtypeSmartAlbumVideos), // Videos
                                                      @(PHAssetCollectionSubtypeSmartAlbumBursts) // Bursts
                                                      ];
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    /*
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
    [self presentViewController:ipc animated:YES completion:^{
    }];*/
    
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
    MYLOG(@"%@",fileUrl);
    
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
            
            MYLOG(@"%@",dataurl);
            
            NSData* ndata = [NSData dataWithContentsOfURL:dataurl];
            
            //MYLOG(@"%@",ndata);
            //[self.testImage sd_setImageWithURL:dataurl];
            
            [self.photoButton setBackgroundImage:[UIImage imageWithData:ndata] forState:UIControlStateNormal];
            
            MYLOG(@"%@",imgurl);
        }
        
    } fail:^{
        
        [hud removeFromSuperview];
        
        [alert setMessage:@"Timeout,please try again."];
        [alert show];
        
        MYLOG(@"请求失败");
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void) uploadFinished{
    
    if(muploading_number<=0){
        [hud removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Successfully post %ld photos",muploaded_number] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
}

- (void) qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    //[postData setValue:[NSString stringWithFormat:@"%ld",(unsigned long)self.sid] forKey:@"sid"];
    [postData setValue:[BWCommon getUserInfo:@"username"] forKey:@"username"];
    
    muploading_number = [assets count];
    muploaded_number = 0;
    
    if(muploading_number>0){
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate=self;
    }
    
    MYLOG(@"%ld",muploading_number);
    for (PHAsset *asset in assets) {
        //MYLOG(@"%@",asset);
        
        
        
        PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [[PHImageManager defaultManager]
         requestImageDataForAsset:asset
         options:imageRequestOptions
         resultHandler:^(NSData *imageData, NSString *dataUTI,
                         UIImageOrientation orientation,
                         NSDictionary *info)
         {
             //MYLOG(@"info = %@", info);
             if ([info objectForKey:@"PHImageFileURLKey"]) {
                 
                 //临时存储图片后上传
                 int y = (arc4random() % 1001) + 9000;
                 
                 NSString *fileName = [NSString stringWithFormat:@"%d%@",y,@".jpg"];
                 
                 NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString* documentsDirectory = [paths objectAtIndex:0];
                 // Now we get the full path to the file
                 NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];
                 // and then we write it out
                 [imageData writeToFile:fullPathToFile atomically:NO];
                 
                 NSString *fullFileName = [[self documentFolderPath] stringByAppendingPathComponent:fileName];
                 
                 NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:fullFileName];
                 //临时存储后的文件地址
                 
                 NSString *api_url = [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"addshopphoto"];
                 
                 
                 [AFNetworkTool postUploadWithUrl:api_url fileUrl:fileUrl parameters:postData success:^(id responseObject) {
                     
                     //MYLOG(@"%@",responseObject);
                     NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                     
                     //[hud removeFromSuperview];
                     
                     
                     MYLOG(@"%@",responseObject);
                     if (code != 200) {
                         
                     }
                     else
                     {
                         imgurl = [responseObject objectForKey:@"msg"];
                         
                         NSString *nimgview = [[NSString alloc] init];
                         
                         nimgview = [NSString stringWithFormat:@"%@/uploadfiles/%@!m80x80.jpg",[BWCommon getBaseInfo:@"site_url"],imgurl];
                         NSURL *dataurl = [NSURL URLWithString:nimgview];
                         
                         MYLOG(@"%@",dataurl);
                         
                         NSData* ndata = [NSData dataWithContentsOfURL:dataurl];
                         
                         [self.photoArray addObject:imgurl];
                         [self.photoDataArray addObject:ndata];
                         
                         [self loadPhotoView];
                         
                         
                         muploaded_number ++;
                     }
                     
                     muploading_number--;
                     
                     [self uploadFinished];
                     
                 } fail:^{
                     
                     //[hud removeFromSuperview];
                     MYLOG(@"faild");
                     muploading_number--;
                     
                     [self uploadFinished];
                 }];
                 
                 
             }
         }];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)loadPhotoView{
    
    for(UIView *subView in [self.photoView subviews])
    {
        [subView removeFromSuperview];
        MYLOG(@"%@",subView);
    }
    
    MYLOG(@"photoDataArray count: %ld", [self.photoDataArray count]);
    
    for(int i=0;i<self.photoDataArray.count;i++){
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        photoButton.frame = CGRectMake(85*i, 0, 80, 80);
        photoButton.tag = i;
        [photoButton addTarget:self action:@selector(photoRemoveTouched:) forControlEvents:UIControlEventTouchUpInside];
        [photoButton setBackgroundImage:[UIImage imageWithData:self.photoDataArray[i]] forState:UIControlStateNormal];
        [self.photoView addSubview:photoButton];
    }
    
}

-(void) photoRemoveTouched:(UIButton *)sender{
    
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"Remove this photo？" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        
        [self.photoArray removeObjectAtIndex:sender.tag];
        [self.photoDataArray removeObjectAtIndex:sender.tag];
        
        [self loadPhotoView];
        
    }];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action)
                          {}];
    [alert addAction:cancel];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,0.3);
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
