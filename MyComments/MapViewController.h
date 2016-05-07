//
//  MapViewController.h
//  MyComments
//
//  Created by Bruce on 15-7-6.
//
//

#import <UIKit/UIKit.h>
#import "MapDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController
<MapDelegate,
GMSMapViewDelegate
>

@end
