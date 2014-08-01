//
//  DetailViewController.h
//  Bellarmine Political Review Mobile
//
//  Created by Sony Theakanath on May 27, 2013
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    NSMutableArray *interfaceArray;
    UIScrollView *inview;
}

@property (strong, nonatomic) id detailItem;
@end
