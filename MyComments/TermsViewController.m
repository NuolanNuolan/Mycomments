//
//  TermsViewController.m
//  MyComments
//
//  Created by Bruce on 16/3/20.
//
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController
CGSize size;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
   

    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width,size.height)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/terms-of-service.html",[BWCommon getBaseInfo:@"site_url"] ]]];
    
    [self.webView loadRequest:request];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"Terms of Service";

}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    self.hud = [BWCommon getHUD];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud removeFromSuperview];
}
@end
