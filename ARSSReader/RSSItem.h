//
//  RSSItem.h
//  Bellarmine Political Review Mobile
//
//  Created by Sony Theakanath on May 27, 2013
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* imagelink;
@property (strong, nonatomic) NSString* dateposted;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* author;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSURL* link;
@property (strong, nonatomic) NSAttributedString* cellMessage;

@end