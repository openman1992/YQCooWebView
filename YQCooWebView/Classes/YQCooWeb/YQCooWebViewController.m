//
//  YQCooWebViewController.m
//  web
//
//  Created by 意想不到 on 2019/4/4.
//  Copyright © 2019年 意想不到. All rights reserved.
//

#import "YQCooWebViewController.h"
#import <WebKit/WebKit.h>

@interface YQCooWebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKUserContentController *userControl;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, weak) UIButton *canGoBackButton;

@property (nonatomic, weak) UIButton *canGoForwardButton;


@end

@implementation YQCooWebViewController

- (void)dealloc {
    [_userControl removeAllUserScripts];
    [_progressView removeFromSuperview];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"canGoForward"];
}

+ (UINavigationController *)instanceWithUrl:(NSURL *)url {
    YQCooWebViewController *web = [[YQCooWebViewController alloc]init];
    web.url = url;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:web];
    nav.toolbarHidden = NO;
    return nav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *canGoBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [canGoBackButton setImage:self.canBackNormalItemImage forState:UIControlStateNormal];
    [canGoBackButton setImage:self.canBackSelectedItemImage forState:UIControlStateSelected];
    [canGoBackButton addTarget:self action:@selector(canGoBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *canGoBackBarItem = [[UIBarButtonItem alloc]initWithCustomView:canGoBackButton];
    _canGoBackButton = canGoBackButton;
    UIButton *canGoFarwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [canGoFarwardButton setImage:self.canGoForwardNormalItemImage forState:UIControlStateNormal];
    [canGoFarwardButton setImage:self.canGoForwardSelectedItemImage forState:UIControlStateSelected];
    [canGoFarwardButton addTarget:self action:@selector(canGoForwardClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *canGoForwardBarItem = [[UIBarButtonItem alloc]initWithCustomView:canGoFarwardButton];
    _canGoForwardButton = canGoFarwardButton;
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:self.refreshImage forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc]initWithCustomView:refreshButton];
    
    UIButton *goMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goMenuButton setImage:self.goMenuImage forState:UIControlStateNormal];
    [goMenuButton addTarget:self action:@selector(goMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *goMenuBarItem = [[UIBarButtonItem alloc]initWithCustomView:goMenuButton];
    NSArray *arr = [NSArray arrayWithObjects:flexSpace,canGoBackBarItem,flexSpace,canGoForwardBarItem,flexSpace,refreshBarItem,flexSpace,goMenuBarItem,flexSpace, nil];
    [self.navigationController.toolbar setItems:arr animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.bounds;
    _progressView.frame = CGRectMake(0, 43, self.view.bounds.size.width, 1);
}

- (void)canGoBackButtonClick:(UIButton *)sender {
    if (!sender.selected) {
        return;
    }
    [_webView goBack];
}

- (void)canGoForwardClick:(UIButton *)sender {
    if (!sender.selected) {
        return;
    }
    [_webView goForward];
}

- (void)refreshButtonClick:(UIButton *)sender {
    [_webView reload];
}

- (void)goMenuButtonClick:(UIButton *)sender {
    WKBackForwardList *list = _webView.backForwardList;
    if (list.backList.firstObject) {
        [_webView goToBackForwardListItem:list.backList.firstObject];
    }
    
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    _progressView.progress = 0;
    _progressView.hidden = NO;
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    _progressView.progress = 0;
    _progressView.hidden = YES;
}

// 拦截url 方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma  mark - WKUIDelegate

// 网页弹框 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 网页弹框 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 网页谭文字输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = _webView.title;
        return;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (_webView.estimatedProgress >= 1) {
            _progressView.hidden = YES;
            _progressView.progress = 0;
        } else {
            _progressView.hidden = NO;
            _progressView.progress = _webView.estimatedProgress;
        }
        return;
    }
    if ([keyPath isEqualToString:@"canGoBack"]) {
        _canGoBackButton.selected = _webView.canGoBack;
        return;
    }
    if ([keyPath isEqualToString:@"canGoForward"]) {
        _canGoForwardButton.selected = _webView.canGoForward;
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma private - methods

- (UIImage *)YQCooImageWithName:(NSString *)name {
    NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [myBundle pathForResource:@"YQCooWebView" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

- (void)setupView {
    [self.view addSubview:self.webView];
    [self.navigationController.navigationBar addSubview:self.progressView];
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

#pragma mark - setter and getter

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        // 自适应屏幕的css
        NSString *str = @"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\" />";
        // 禁止图片长按手势的css
        //  NSString *source = @"var style = document.createElement('style'); \
        style.type = 'text/css'; \
        style.innerText = '*:not(input):not(textarea) { -webkit-user-select: none; -webkit-touch-callout: none; }'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(style);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:str injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly: YES];
        // WKUserScript *clickUserScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly: YES];
        // 添加自适应屏幕宽度js调用的方法
        _userControl = [[WKUserContentController alloc]init];
        [_userControl addUserScript:wkUserScript];
        //  [_userControl addUserScript:clickUserScript];
        configuration.userContentController = _userControl;
        // 1.self.view widthis 600 heightis 600 x 0 y 0
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progressTintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UIImage *)canBackNormalItemImage {
    if (!_canBackNormalItemImage) {
        _canBackNormalItemImage = [self YQCooImageWithName:@"canGoBackNormal"];
        
    }
    return _canBackNormalItemImage;
}

- (UIImage *)canBackSelectedItemImage {
    if (!_canBackSelectedItemImage) {
        _canBackSelectedItemImage = [self YQCooImageWithName:@"canGoBackSelected"];
    }
    return _canBackSelectedItemImage;
}

- (UIImage *)canGoForwardNormalItemImage {
    if (!_canGoForwardNormalItemImage) {
        _canGoForwardNormalItemImage = [self YQCooImageWithName:@"canGoForwardNormal"];
    }
    return _canGoForwardNormalItemImage;
}

- (UIImage *)canGoForwardSelectedItemImage {
    if (!_canGoForwardSelectedItemImage) {
        _canGoForwardSelectedItemImage = [self YQCooImageWithName:@"canGoForwardSelected"];
    }
    return _canGoForwardSelectedItemImage;
}

- (UIImage *)refreshImage {
    if (!_refreshImage) {
        _refreshImage = [self YQCooImageWithName:@"refreshWeb"];
    }
    return _refreshImage;
}

- (UIImage *)goMenuImage {
    if (!_goMenuImage) {
        _goMenuImage = [self YQCooImageWithName:@"goMenu"];
    }
    return _goMenuImage;
}

@end
