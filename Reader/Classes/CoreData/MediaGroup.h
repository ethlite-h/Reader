//
//  MediaGroup.h
//  Reader
//
//  Created by Helen Ma on 1/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry;

@interface MediaGroup : NSManagedObject

@property (nonatomic, retain) NSString * medium;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) Entry *entry;

@end
