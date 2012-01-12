//
//  Feed.m
//  Reader
//
//  Created by Helen Ma on 1/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Feed.h"
#import "Entry.h"
#import "AppDelegate.h"
#import "NSManagedObjectContext-CocoaWithLove.h"


@implementation Feed

@dynamic url;
@dynamic entries;

+ (Feed *)newFeedWithURL: (NSString *)url
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Feed *feed = (Feed *)[NSEntityDescription insertNewObjectForEntityForName:@"Feed"
                                                       inManagedObjectContext:appDelegate.managedObjectContext];
    feed.url = url;
    return feed;
}

+ (Feed *)feedWithURL: (NSString *)url
{
    NSString *urlString = [NSString stringWithFormat:kDefaultURL, url];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *feeds = [appDelegate.managedObjectContext fetchObjectsForEntityName:@"Feed"
                                                                  sortDescriptor:nil
                                                                       predicate:[NSPredicate predicateWithFormat:@"url = %@", urlString]];

    if (feeds.count) {
        return [feeds objectAtIndex:0];        
    }
    
    return nil;
}

+ (void)deleteFeedWithURL: (NSString *)url
{
    Feed *feed = [Feed feedWithURL:url];
    if (feed) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.managedObjectContext deleteObject:feed];
        [appDelegate saveContext];
    }
}

- (void)addEntriesObject:(Entry *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.entries];
    [tempSet addObject:value];
    self.entries = tempSet;
}


@end
