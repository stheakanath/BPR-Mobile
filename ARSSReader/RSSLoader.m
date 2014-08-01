//
//  RSSLoader.m
//  Bellarmine Political Review Mobile
//
//  Created by Sony Theakanath on May 27, 2013
//

#import "RSSLoader.h"
#import "RXMLElement.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"
#import "RSSItem.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation RSSLoader

-(void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)c {
    dispatch_async(kBgQueue, ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        RXMLElement *rss = [RXMLElement elementFromURL: url];
        RXMLElement* title;
        NSMutableArray* result;
        if(![rss.text length] == 0) {
            title = [[rss child:@"channel"] child:@"title"];
            NSArray* items = [[rss child:@"channel"] children:@"item"];
            result = [NSMutableArray arrayWithCapacity:items.count];
            for (RXMLElement *e in items) {
                RSSItem* item = [[RSSItem alloc] init];
                NSArray *split = [e.text componentsSeparatedByString:@"\n"];
                //Title
                item.title = [[e child:@"title"] text];

                //Featured Image
                NSString *image = [[e child:@"description"] text];
                NSArray *listItems = [image componentsSeparatedByString:@"\""];
                if([listItems count] > 5) {
                item.imagelink = [listItems objectAtIndex:5];
                NSURL *imageURL = [NSURL URLWithString:[listItems objectAtIndex:5]];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                item.image =  [UIImage imageWithData:imageData];
                
                //Date Posted
                NSString *date = [[e child:@"pubDate"] text];
                NSArray *dateitems = [date componentsSeparatedByString:@":"];
                NSString *pubdate = [[dateitems objectAtIndex:0] substringWithRange:NSMakeRange(0, [[dateitems objectAtIndex:0] length]-3)];
                item.dateposted = pubdate;
                
                //Author
                item.author = [[[[split objectAtIndex:5] stringByStrippingTags] stringByRemovingNewLinesAndWhitespace] stringByDecodingHTMLEntities];

                
                //Category
                item.category = [[e child:@"category"] text];
                item.category = [item.category gtm_stringByUnescapingFromHTML];
                
                //Link
                item.link = [NSURL URLWithString: [[e child:@"link"] text]];
                
                //Content
                NSMutableString *fullcontent = [[NSMutableString alloc] initWithFormat:@""];
                for(int x = 11; x < [split count]-3; x++) {
                    [fullcontent appendString:[split objectAtIndex:x]];
                   
                }
                NSString *f = [NSString stringWithString: fullcontent];
                f = [f stringByReplacingOccurrencesOfString: @"<p>" withString:@"\n\n"];
                f = [f stringByReplacingOccurrencesOfString: @"<br />" withString:@"\n"];
                f = [f stringByReplacingOccurrencesOfString: @"<br/>" withString:@"\n"];
                f = [f stringByReplacingOccurrencesOfString: @"</p>" withString:@""];
                f = [f stringByReplacingOccurrencesOfString: @"<strong>" withString:@""];
                f = [f stringByReplacingOccurrencesOfString: @"</strong>" withString:@""];
                NSString *newone = [self strip:f];
                NSRange rOriginal = [newone rangeOfString: @"\n\n"];
                if (NSNotFound != rOriginal.location)
                    newone = [newone stringByReplacingCharactersInRange: rOriginal withString: @""];
                newone = [newone stringByDecodingHTMLEntities];
                item.content = newone;
                [result addObject: item];
                }
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        } else {
            result = [NSMutableArray array];
        }
        c([title text], result);
    });

}

-(NSString *) strip:(NSString*)url {
    NSRange r;
    NSString *s = [url copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
