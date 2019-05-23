//
//  TCCGlobalWebViewController.m
//  Tachcard
//
//  Created by admin on 7/17/17.
//  Copyright © 2017 Tachcard. All rights reserved.
//

#import "GlobalWebViewController.h"

@interface GlobalWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@end

@implementation GlobalWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];

    if (self.method) {
        [request setHTTPMethod:self.method];
    }

    if (self.arguments) {
        NSString *params = [self makeParamtersString:self.arguments withEncoding:NSUTF8StringEncoding];
        NSData *body = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody: body];
    }

    [self.webView loadRequest:request];
    [self hideWebViewShadow];
    [self abstractDidLoad];
}

- (void)abstractDidLoad {}

- (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;

    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
        NSString *value = [[parameters valueForKey:key] isKindOfClass:[NSString class]] ?
        [parameters valueForKey:key] : [[parameters valueForKey:key] stringValue];
        [stringOfParamters appendFormat:@"%@=%@&",
         [self URLEscaped:key withEncoding:encoding],
         [self URLEscaped:value withEncoding:encoding]];
    }

    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

- (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding {
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strIn, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *strOut = [NSString stringWithString:(__bridge NSString *)escaped];
    CFRelease(escaped);
    return strOut;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)closeButtonHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
    [UIView animateWithDuration:0.25f animations:^{
        webView.alpha = 1.f;
    }];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];

    [self absWebViewDidFinishLoad:webView];

    CGSize contentSize = self.webView.scrollView.contentSize;
    CGSize viewSize = self.webView.bounds.size;

    float rw = viewSize.width / contentSize.width;

    NSString *zoomString = [NSString stringWithFormat:@"document. body.style.zoom = %f;",rw];
    [self.webView stringByEvaluatingJavaScriptFromString:zoomString];
}

- (void)absWebViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
    @weakify(self);
    [UIAlertController showAlertInViewController:self withTitle:@"" message:[error localizedDescription] cancelButtonTitle:@"Ок" destructiveButtonTitle:nil otherButtonTitles:nil textFieldPlaceholders:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)hideWebViewShadow {
    self.webView.backgroundColor = [UIColor whiteColor];
    for (UIView* subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
}


@end
