#import "CRALogController.h"
#import "Log.h"
#import "NSString+HTML.h"

@implementation CRALogController
-(instancetype)initWithLog:(Log*)log
{
    if ((self = [self init]))
    {
        _log = log;
        NSArray<NSString*>* comp = [[_log.path lastPathComponent] componentsSeparatedByString:@"@"];
        NSString* title = comp.count > 1 ? comp[1] : comp[0];
        self.title = title;
    }
    return self;
}

-(void)loadView
{
	[super loadView];

    if ([self.navigationItem respondsToSelector:@selector(setLargeTitleDisplayMode:)])
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;

    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;

    webView = [WKWebView new];
    webView.scrollView.bounces = NO;
    logMessage = [NSString stringWithContentsOfFile:_log.path encoding:NSUTF8StringEncoding error:NULL];

    NSString* htmlString =  @"<html><head><title>.</title><meta name='viewport' content='initial-scale=1.0,maximum-scale=3.0'/></head><body><pre style=\"font-size:8pt;\">%@</pre></body></html>";
    NSString* formattedStr = [logMessage kv_encodeHTMLCharacterEntities];
    htmlString = [NSString stringWithFormat:htmlString, formattedStr];
    [self.view addSubview:webView];

    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    [webView loadHTMLString:htmlString baseURL:nil];
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
