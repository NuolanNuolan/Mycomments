//
//  HomeMapViewController.m
//  MyComments
//
//  Created by Bruce on 16/1/23.
//
//

#import "HomeMapViewController.h"
#import "BWCommon.h"

@import GoogleMaps;

@interface HomeMapViewController ()
{
    GMSMapView *mapView_;
    
}

@property (nonatomic,strong) NSMutableArray *markers;

@end

@implementation HomeMapViewController

bool initedMap=NO;

CLLocation *_location;

@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getRedColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [self.navigationItem setTitle: @"Nearest Shops"];
    

    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
    // Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:3.16
                                                            longitude:101.7
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.delegate=self;
    self.view = mapView_;
    
    self.markers = [[NSMutableArray alloc] init];
    
    [self loadRelatedShop:101.7 lat:3.16];
    
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = shop_name;
    marker.snippet = address;
    marker.map = mapView_;
    */
}

-(void) initMap{
    if(initedMap==YES) return;
    
    MYLOG(@"sss");
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:3.16
                                                            longitude:101.7
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    self.view = mapView_;
    
    initedMap = YES;
    
    
}
-(void)dealloc
{

    MYLOG(@"释放了吗?");
}
-(void) loadRelatedShop:(double )lng lat:(double )lat{
    

    //hud = [BWCommon getHUD];
    //hud.mode = MBProgressHUDModeCustomView;
    //hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"relatedShop"];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    
    [postData setValue:[NSString stringWithFormat:@"%f",lng] forKey:@"lng"];
    [postData setValue:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
    
    //[postData setValue:@"101.7" forKey:@"lng"];
    //[postData setValue:@"3.16" forKey:@"lat"];

    
    MYLOG(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        //NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        //[hud removeFromSuperview];

            NSMutableDictionary *data = responseObject;
            
            //MYLOG(@"related shop: %@",data);

            dataArray = [[data objectForKey:@"lists"] mutableCopy];
            
            MYLOG(@"%@",dataArray);
        
            [self renderMarkers];
        
    } fail:^{
        //[hud removeFromSuperview];
        MYLOG(@"请求失败");
    }];

}

-(void) renderMarkers{
    
    if([self.markers count] > 0)
    {
        for(int i=0;i<[self.markers count] ; i ++){
            GMSMarker *marker = self.markers[i];
            marker.map = nil;
        }
    }
    
    self.markers = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[dataArray count] ; i ++){
        
        GMSMarker *marker = [[GMSMarker alloc] init];
         marker.position = CLLocationCoordinate2DMake([dataArray[i][@"lat"] floatValue], [dataArray[i][@"lng"] floatValue]);
         marker.title = dataArray[i][@"name"];
         marker.snippet = dataArray[i][@"address"];
         marker.appearAnimation = kGMSMarkerAnimationPop;
         marker.map = mapView_;
        
        [self.markers addObject:marker];
    }
}

-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    MYLOG(@"mapView moved!!!! %@",position);
    
    //[self loadRelatedShop:position.target.longitude lat:position.target.latitude];
}

-(void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    //[self loadRelatedShop:position.target.longitude lat:position.target.latitude];
}

-(void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self loadRelatedShop:coordinate.longitude lat:coordinate.latitude];
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    if(!mapView.myLocationEnabled){
        return;
    }
    
    NSString *saddr = [NSString stringWithFormat:@"%f,%f",mapView.myLocation.coordinate.latitude,mapView.myLocation.coordinate.longitude];
    
    NSString *daddr = [NSString stringWithFormat:@"%f,%f",marker.position.latitude,marker.position.longitude];
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@&directionsmode=driving",saddr,daddr]]];
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Google maps not installed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        MYLOG(@"Can't use comgooglemaps://");
    }
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
