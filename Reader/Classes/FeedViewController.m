//
//  FeedViewController.m
//  Reader
//
//  Created by Helen Ma on 1/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "FeedViewController.h"
#import "RootViewController.h"
#import "MediaGroup.h"
#import "AppDelegate.h"
#import "Feed.h"
#import "Entry.h"
#import "ASIHTTPRequest.h"

@implementation FeedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        CGFloat space = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 150: 520;
        self.view.frame = CGRectMake(0, 40, CGRectGetWidth([UIScreen mainScreen].applicationFrame), CGRectGetHeight([UIScreen mainScreen].applicationFrame)-40-space);
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootViewController *rootViewController = appDelegate.rootViewController;
    
    Feed *newFeed = [Feed feedWithURL:rootViewController.urlField.text];
    if (newFeed) {
        return newFeed.entries.count;
    }
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootViewController *rootViewController = appDelegate.rootViewController;
    Feed *feed = [Feed feedWithURL:rootViewController.urlField.text];
    NSUInteger entryNumber = indexPath.row;
    if (feed) {
        UILabel *snippetLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, CGRectGetWidth(cell.bounds)-100, CGRectGetHeight(cell.bounds))];
        snippetLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        Entry *entry = (Entry *)[feed.entries objectAtIndex: entryNumber];
        snippetLabel.text = entry.snippet;
        [cell.contentView addSubview: snippetLabel];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        MediaGroup *mediaGroup = (MediaGroup *)[entry.mediaGroups anyObject];   // oops, need to handle multiple mediaGroups?
        NSString *urlString = mediaGroup.thumbnail;
        if (urlString && urlString.length) {
            __block NSURL *url = [NSURL URLWithString:urlString];
            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            // success
            [request setCompletionBlock:^{
                NSData *responseData = [request responseData];
                if (responseData) {
                    cell.imageView.image = [UIImage imageWithData: responseData];                    
                }
            }];
            
            [request setFailedBlock:^{
                NSLog(@"Failed to download %@ status code: %d", url, [request responseStatusCode]);
            }];
            
            [request startAsynchronous];
        }
        
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootViewController *rootViewController = appDelegate.rootViewController;
    UIWebView *contentView = rootViewController.contentView;
    Feed *feed = [Feed feedWithURL:rootViewController.urlField.text];
    NSURL *url = [NSURL URLWithString:feed.url];
    NSUInteger entryNumber = indexPath.row;
    Entry *entry = (Entry *)[feed.entries objectAtIndex: entryNumber];
    
    NSString *content = entry.content;
    
    [contentView loadHTMLString:content baseURL:url];
}

@end
