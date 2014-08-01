//
//  MasterViewController.m
//  Bellarmine Political Review Mobile
//
//  Created by Sony Theakanath on May 27, 2013
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "OptionsMenuController.h"
#import "RSSLoader.h"
#import "RSSItem.h"

@interface MasterViewController () {
    NSArray *_objects;
    NSURL* feedURL;
    int atfeed;
    BOOL scrolledbefore;
    BOOL doneloadingeverything;
    UIRefreshControl* refreshControl;
}
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    atfeed = 1;
    scrolledbefore = false;
    doneloadingeverything = false;
    self.title = @"BPR Mobile";
    feedURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://bpr.bcp.org/?feed=rss2&paged=%i", atfeed]];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    
    NSString* fetchMessage = [NSString stringWithFormat:@"Pull Up to Refresh!"];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView = footerView;
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(footerView.bounds.size.width/2.0, footerView.bounds.size.height/2.0)];
    [spinner startAnimating];
    [footerView addSubview:spinner];
    [self.tableView addSubview: refreshControl];
    
    
    [self refreshFeed:feedURL];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper.jpg"]];
    self.tableView.separatorColor = [UIColor clearColor];
}

-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
    [self refreshFeed:feedURL];
}

-(void)refreshFeed:(NSURL*)theurl {
    RSSLoader* rss = [[RSSLoader alloc] init];
    [rss fetchRssWithURL:theurl complete:^(NSString *title, NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *test = [[NSMutableArray alloc] init];
        [test addObjectsFromArray:_objects];
        if([results count] == 0) {
            NSLog(@"Finished Loading Everything!");
            [refreshControl endRefreshing];
            doneloadingeverything = true;
            NSArray *viewsToRemove = [self.tableView.tableFooterView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
                NSLog(@"removed");
            }
            self.tableView.tableFooterView.hidden = NO;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
        }
        [test addObjectsFromArray:results];
        _objects = [NSArray arrayWithArray:test];
        [self.tableView reloadData];
        [refreshControl endRefreshing];
        self.tableView.tableFooterView.hidden = YES;
        scrolledbefore = false;
    });}];
}



-(IBAction)showOptions:(id)sender {
    OptionsMenuController *ainfoController = [[OptionsMenuController alloc] initWithNibName:@"OptionsMenuController" bundle:nil];
    ainfoController.modalTransitionStyle = UIViewAnimationTransitionCurlUp;
    [self presentModalViewController:ainfoController animated:YES];
}

#pragma mark - Table Views

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance && scrolledbefore == false && doneloadingeverything == false) {
        self.tableView.tableFooterView.hidden = NO;
        atfeed++;
        [self refreshFeed:[NSURL URLWithString:[NSString stringWithFormat:@"http://bpr.bcp.org/?feed=rss2&paged=%i", atfeed]]];
         scrolledbefore = true;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    RSSItem *object = _objects[indexPath.row];
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    } else {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    UIImageView *bkgndimage =  [[UIImageView alloc] initWithImage:object.image];
    bkgndimage.contentMode = UIViewContentModeScaleAspectFill;
    cell.backgroundView = bkgndimage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundView.clipsToBounds = YES;
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, bkgndimage.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [bkgndimage addSubview:overlay];
    
    UILabel *articlename = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 14.0, screenWidth-40 , 60)];
    [articlename setBackgroundColor:[UIColor clearColor]];
    [articlename setFont:[UIFont fontWithName:@"Bebas Neue" size:40]];
    [articlename setText:object.title];
    [articlename setTextColor:[UIColor whiteColor]];
    [articlename setShadowColor:[UIColor blackColor]];
    [articlename setShadowOffset:CGSizeMake(1, 0)];
    articlename.lineBreakMode = NSLineBreakByWordWrapping;
    articlename.numberOfLines = 0;
    [cell.contentView addSubview:articlename];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 74.0, screenWidth-40 , 60)];
    [date setBackgroundColor:[UIColor clearColor]];
    [date setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [date setText:object.dateposted];
    [date setTextColor:[UIColor whiteColor]];
    [date setShadowColor:[UIColor blackColor]];
    [date setShadowOffset:CGSizeMake(1, 0)];
    date.lineBreakMode = NSLineBreakByWordWrapping;
    date.numberOfLines = 0;
    [cell.contentView addSubview:date];
    
    UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 47.0, screenWidth-40 , 60)];
    [author setBackgroundColor:[UIColor clearColor]];
    [author setFont:[UIFont fontWithName:@"Bebas Neue" size:22]];
    [author setText:[NSString stringWithFormat:@"By %@", object.author]];
    [author setTextColor:[UIColor whiteColor]];
    [author setShadowColor:[UIColor blackColor]];
    [author setShadowOffset:CGSizeMake(1, 0)];
    author.lineBreakMode = NSLineBreakByWordWrapping;
    author.numberOfLines = 0;
    [cell.contentView addSubview:author];
    
    UIView *category = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 125)];
    if([object.category isEqualToString:@"National Politics"])
        category.backgroundColor = [UIColor colorWithRed:0 green:0.47 blue:0.725 alpha:1.0];
    else if([object.category isEqualToString:@"International Politics"])
        category.backgroundColor = [UIColor colorWithRed:0.752 green:0.12 blue:0.15 alpha:1.0];
    else if([object.category isEqualToString:@"California Politics"])
        category.backgroundColor = [UIColor colorWithRed:1.0 green:0.7294 blue:0.0 alpha:1.0];
    else
        category.backgroundColor = [UIColor colorWithRed:0.254 green:0.678 blue:0.286 alpha:1.0];
    [cell.contentView addSubview:category];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSItem *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
