//
//  MapViewController.m
//  MyComments
//
//  Created by Bruce on 15-7-6.
//
//

#import "MapViewController.h"

@interface MapViewController ()
{
    GMSMapView *mapView_;

}

@property (nonatomic,assign) NSDictionary *shopDict;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void) setSingleShop{
    
    
    NSString *shop_name = [[[self shopDict] objectForKey:@"shop"] objectForKey:@"name"];
    NSString *address = [[[self shopDict] objectForKey:@"shop"] objectForKey:@"address"];
    self.navigationItem.title = shop_name;
    // Creates a marker in the center of the map.
    
    double lat =[[[[self shopDict] objectForKey:@"shop"] objectForKey:@"lat"] doubleValue];
    double lng =[[[[self shopDict] objectForKey:@"shop"] objectForKey:@"lng"] doubleValue];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lng
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.delegate=self;
    //mapView_.settings.scrollGestures = YES;
    //mapView_.settings.zoomGestures = YES;
    self.view = mapView_;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = shop_name;
    marker.snippet = address;
    marker.map = mapView_;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setValue:(NSDictionary *)shopDict{
    self.shopDict = shopDict;
    [self setSingleShop];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
