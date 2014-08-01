//
//  DetailViewController.m
//  Bellarmine Political Review Mobile
//
//  Created by Sony Theakanath on May 27, 2013
//

#import "DetailViewController.h"
#import "UIImage+StackBlur.h"
#import "RSSItem.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

- (void) startInterface {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    inview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-70)];
    RSSItem* item = (RSSItem*)self.detailItem;
    
    self.title = item.title;
    [inview setContentSize:CGSizeMake(screenWidth, 2000)];
    UIImageView *bkgndimage =  [[UIImageView alloc] initWithImage:[item.image stackBlur:20]];
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bkgndimage.frame.size.width, screenHeight)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [bkgndimage addSubview:overlay];
    bkgndimage.contentMode = UIViewContentModeScaleAspectFill;
    [bkgndimage setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:bkgndimage];
    
    CGSize sizeDate = [item.title sizeWithFont:[UIFont fontWithName:@"Bebas Neue" size:50] constrainedToSize:CGSizeMake(screenWidth-40, 20000) lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *articlename = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 14.0, screenWidth-40, sizeDate.height)];
    [articlename setBackgroundColor:[UIColor clearColor]];
    [articlename setFont:[UIFont fontWithName:@"Bebas Neue" size:50]];
    [articlename setText:item.title];
    [articlename setTextAlignment:NSTextAlignmentRight];
    [articlename setTextColor:[UIColor whiteColor]];
    [articlename setShadowColor:[UIColor blackColor]];
    [articlename setShadowOffset:CGSizeMake(1, 0)];
    articlename.lineBreakMode = NSLineBreakByWordWrapping;
    articlename.numberOfLines = 0;
    [inview addSubview:articlename];

    CGSize sizeauthor = [item.author sizeWithFont:[UIFont fontWithName:@"Bebas Neue" size:25] constrainedToSize:CGSizeMake(screenWidth-40, 20000) lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *category = [[UILabel alloc] initWithFrame:CGRectMake(20.0, sizeDate.height+15, screenWidth-40, sizeauthor.height)];
    [category setBackgroundColor:[UIColor clearColor]];
    [category setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [category setText:item.author];
    [category setTextAlignment:NSTextAlignmentRight];
    [category setTextColor:[UIColor whiteColor]];
    [category setShadowColor:[UIColor blackColor]];
    [category setShadowOffset:CGSizeMake(1, 0)];
    category.lineBreakMode = NSLineBreakByWordWrapping;
    category.numberOfLines = 0;
    [inview addSubview:category];
    
    UIView *split = [[UIView alloc] initWithFrame:CGRectMake(20, sizeDate.height+sizeauthor.height+20, screenWidth-40, 2)];
    [split setBackgroundColor:[UIColor whiteColor]];
    [split setAlpha:0.6];
    [inview addSubview:split];
    
    CGSize sizearticle = [item.content sizeWithFont:[UIFont fontWithName:@"Palatino-Roman" size:16] constrainedToSize:CGSizeMake(screenWidth-40, 20000) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *article = [[UILabel alloc] initWithFrame:CGRectMake(20.0, sizeDate.height+sizeauthor.height+30, screenWidth-40, sizearticle.height)];
    [article setBackgroundColor:[UIColor clearColor]];
    [article setFont:[UIFont fontWithName:@"Palatino-Roman" size:16]];
    [article setText:item.content];
    [article setTextAlignment:NSTextAlignmentLeft];
    [article setTextColor:[UIColor whiteColor]];
    [article setShadowColor:[UIColor blackColor]];
    [article setShadowOffset:CGSizeMake(1, 0)];
    article.lineBreakMode = NSLineBreakByWordWrapping;
    article.numberOfLines = 0;
    [inview addSubview:article];
    [inview setContentSize:CGSizeMake(screenWidth, sizeDate.height+sizeauthor.height+sizearticle.height+30)];

    [[self view] addSubview:inview];
}


-(void)viewDidAppear:(BOOL)animated {
    [self startInterface];
}

@end