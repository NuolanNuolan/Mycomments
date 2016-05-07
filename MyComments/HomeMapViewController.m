//
//  HomeMapViewController.m
//  MyComments
//
//  Created by Bruce on 16/1/23.
//
//

#import "HomeMapViewController.h"

@import GoogleMaps;

@interface HomeMapViewController ()
{
    GMSMapView *mapView_;
    
}

@end

@implementation HomeMapViewController

bool initedMap=NO;

CLLocation *_location;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.title = @"MyComments";
    
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

    
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = shop_name;
    marker.snippet = address;
    marker.map = mapView_;
    */
}

-(void) initMap{
    if(initedMap==YES) return;
    
    NSLog(@"sss");
    
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
-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    NSLog(@"mapView moved!!!!");
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
