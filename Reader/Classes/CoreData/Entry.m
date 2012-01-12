//
//  Entry.m
//  Reader
//
//  Created by Helen Ma on 1/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Entry.h"
#import "Feed.h"
#import "AppDelegate.h"

@implementation Entry

@dynamic author;
@dynamic title;
@dynamic publishDate;
@dynamic link;
@dynamic snippet;
@dynamic content;
@dynamic feed;
@dynamic mediaGroups;

+ (Entry *)newEntryInFeed: (Feed *)feed
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Entry *entry = (Entry *)[NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                       inManagedObjectContext:appDelegate.managedObjectContext];
    
    [feed addEntriesObject:entry];
    return entry;
}

@end
