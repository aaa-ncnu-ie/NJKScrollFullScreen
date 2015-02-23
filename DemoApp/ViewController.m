//
//  ViewController.m
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+NJKFullScreenSupport.h"

@interface ViewController ()
@property (nonatomic) NSArray *data;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@end

@implementation ViewController

- (void)dealloc
{
    // If tableView is scrolling as this VC is being dealloc'd
    // it continues to send messages (scrollViewDidScroll:) to its delegate.
    // This is fine if the delegate will outlive tableView (e.g. this VC would.)
    // However, if the delegate is an instance that may be dealloc'd
    // before the tableView
    // (i.e. _scrollProxy may be dealloc'd prior to tableView being dealloc'd)
    // the tableView will send messages to its delegate,
    // which is defined with an "assign" (i.e. unsafe_unretained) property.
    // This is a msgSend to non-nil'ed, invalid memory leading to a crash.
    // If or when UIScrollView's delegate is referred to with "weak" rather
    // than "assign", this can and should be removed.
    self.tableView.delegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupData];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self viewController:self]; // UIScrollViewDelegate and UITableViewDelegate methods proxy to ViewController
    _scrollProxy.downThresholdY = 0;
    self.tableView.delegate = (id)_scrollProxy; // cast for surpress incompatible warnings

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetBars) name:UIApplicationWillEnterForegroundNotification object:nil]; // resume bars when back to forground from other apps
}

-(void)viewDidLayoutSubviews
{
    // remove bottom toolbar height from inset
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 0;
    self.tableView.contentInset = inset;
    inset = self.tableView.scrollIndicatorInsets;
    inset.bottom = 0;
    self.tableView.scrollIndicatorInsets = inset;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_scrollProxy reset];
    [self showNavigationBar:animated];
}

- (void)setupData
{
    NSMutableArray *data = [@[] mutableCopy];
    for (NSUInteger i = 0; i < 100; i++) {
        [data addObject:@(i)];
    }
    _data = [data copy];
}

- (void)refreshControlValueChanged:(id)sender
{
    [self.refreshControl beginRefreshing];
    // simulate loading time
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}

- (void)resetBars
{
    [_scrollProxy reset];
    [self showNavigationBar:NO];
}

#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.textLabel.text = [_data[indexPath.row] stringValue];
    return cell;
}

@end
