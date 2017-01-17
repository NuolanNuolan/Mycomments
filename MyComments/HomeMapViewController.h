//
//  HomeMapViewController.h
//  MyComments
//
//  Created by Bruce on 16/1/23.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AFNetworkTool.h"

@interface HomeMapViewController : UIViewController
<GMSMapViewDelegate>

@property (nonatomic,retain) NSMutableArray *dataArray;

@end
