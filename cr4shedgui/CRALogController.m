#import "CRALogController.h"
#import "Log.h"
#import "../sharedutils.h"
#import "NSString+HTML.h"

@implementation CRALogController
-(instancetype)initWithLog:(Log*)log
{
    if ((self = [self init]))
    {
        _log = log;
        self.title = log.dateName;
    }
    return self;
}

-(void)loadView
{
	[super loadView];

    if ([self.navigationItem respondsToSelector:@selector(setLargeTitleDisplayMode:)])
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;

    NSString* appStyle = [[NSUserDefaults standardUserDefaults] objectForKey:kAppStyle];
/**^
    if ([appStyle isEqualToString:@"Dark"]){
        self.view.backgroundColor = [UIColor blackColor];
        NSString* htmlString =  @"<html><head><title>.</title><meta name='viewport' content='initial-scale=1.0,maximum-scale=3.0'/></head><body><pre style=\"font-size:8pt;color:white;background-color:black\">%@</pre></body></html>";
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        NSString* htmlString =  @"<html><head><title>.</title><meta name='viewport' content='initial-scale=1.0,maximum-scale=3.0'/></head><body><pre style=\"font-size:8pt;\">%@</pre></body></html>";
    }
**/
    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;

    webView = [WKWebView new];
    webView.scrollView.bounces = NO;
    logMessage = _log.contents;


    
    
    [self.view addSubview:webView];

    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    if ([appStyle isEqualToString:@"Dark"]){
        self.view.backgroundColor = [UIColor blackColor];
        NSString* htmlString =  @"<html><head><title>.</title><meta name='viewport' content='initial-scale=1.0,maximum-scale=3.0'/></head><body><pre style=\"font-size:8pt;color:white;background-color:black\">%@</pre></body></html>";
        NSString* formattedStr = [logMessage kv_encodeHTMLCharacterEntities];
        htmlString = [NSString stringWithFormat:htmlString, formattedStr];
        [webView loadHTMLString:htmlString baseURL:nil];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        NSString* htmlString =  @"<html><head><title>.</title><meta name='viewport' content='initial-scale=1.0,maximum-scale=3.0'/></head><body><pre style=\"font-size:8pt;\">%@</pre></body></html>";
        NSString* formattedStr = [logMessage kv_encodeHTMLCharacterEntities];
        htmlString = [NSString stringWithFormat:htmlString, formattedStr];
        [webView loadHTMLString:htmlString baseURL:nil];
    }

}

-(void)viewDidAppear:(BOOL)arg1
{
    [super viewDidAppear:arg1];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)share:(id)sender
{
    NSArray* activityItems = @[logMessage];
    UIActivityViewController* activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:YES completion:nil];
}
@end
