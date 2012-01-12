//
//  RootViewController.m
//  Reader
//
//  Created by Helen Ma on 1/11/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "RootViewController.h"
#import "Feed.h"
#import "Entry.h"
#import "MediaGroup.h"

@implementation RootViewController
@synthesize urlField = _urlField;
@synthesize refreshButton = _refreshButton;
@synthesize contentView = _contentView;

- (UITextField *)urlField
{
    if (!_urlField) {
        _urlField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.view.bounds) - 50, 28)];
        _urlField.text = kDefaultFeed;
        _urlField.adjustsFontSizeToFitWidth = YES;
        _urlField.borderStyle = UITextBorderStyleRoundedRect;
        _urlField.font = [UIFont fontWithName:@"CourierNewPSMT" size:20];
        _urlField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _urlField.delegate = self;
    }
    return _urlField;
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshButton.frame = CGRectMake(CGRectGetMaxX(self.urlField.bounds) + 10, 5, 32, 32);
        [_refreshButton setImage:[UIImage imageNamed:@"images/refresh"] forState:UIControlStateNormal];
        _refreshButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_refreshButton addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (UIWebView *)contentView
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FeedViewController *feedViewController = appDelegate.feedViewController;
    CGFloat height = CGRectGetMaxY(feedViewController.view.frame);
    CGRect f = CGRectMake(0, height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-height);

    if (!_contentView) {
        _contentView = [[UIWebView alloc] initWithFrame:f];
        [self.view addSubview:_contentView];
    } else {
        _contentView.frame = f;
    }
    return _contentView;
}

- (void)refreshAction: (id)sender
{
    NSString *urlString = self.urlField.text;
    
    if (!urlString || !urlString.length) {
        return;
    }
    
    urlString = [NSString stringWithFormat:kDefaultURL, urlString];
    
    __block NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    // success
    [request setCompletionBlock:^{
        
        if (!([request responseStatusCode] >= 200 && [request responseStatusCode]<300)) {
            NSLog(@"error loading: %@", url);
            return;
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSData *responseData = [request responseData];
        NSError *error = nil;

        NSDictionary *responseDictionary = (NSDictionary *)[responseData objectFromJSONData];
        if (responseDictionary) {
            NSDictionary *responseData = [responseDictionary objectForKey: @"responseData"];
            if (responseData) {
                NSDictionary *feedData = [responseData objectForKey:@"feed"];
                if (feedData) {
                    if ([Feed feedWithURL:urlString]) {
                        [Feed deleteFeedWithURL: urlString];
                    }
                    Feed *feed = [Feed newFeedWithURL: urlString];
                    NSArray *entries = [feedData objectForKey:@"entries"];
                    
                    //FIXME: we are ignoring categories and publishDate right now
                    for (NSDictionary *entryData in entries) {
                        Entry *entry = [Entry newEntryInFeed: feed];
                        NSString *data = [entryData objectForKey:@"author"];
                        if (data && data.length) {
                            entry.author = data;
                        }
                        
                        data = [entryData objectForKey:@"content"];
                        if (data && data.length) {
                            entry.content = data;
                        }
                        
                        data = [entryData objectForKey:@"contentSnippet"];
                        if (data && data.length) {
                            entry.snippet = data;
                        }
                        
                        data = [entryData objectForKey:@"link"];
                        if (data && data.length) {
                            entry.link = data;
                        }
                        
                        data = [entryData objectForKey:@"publishedDate"];
                        if (data && data.length) {
                            entry.publishDate = [NSDate date];      // do the date format later
                        }
                        
                        data = [entryData objectForKey:@"title"];
                        if (data && data.length) {
                            entry.title = data;
                        }
                        
                        NSArray *mediaGroups = (NSArray *)[entryData objectForKey:@"mediaGroups"];
                        if (mediaGroups) {
                            NSDictionary *dictionary = (NSDictionary *)[mediaGroups objectAtIndex:0];
                            NSArray *contents = (NSArray *)[dictionary objectForKey:@"contents"];
                            for (NSDictionary *mediaGroupData in contents) {
                                MediaGroup *mediaGroup = (MediaGroup *)[NSEntityDescription insertNewObjectForEntityForName:@"MediaGroup"
                                                                                                     inManagedObjectContext:appDelegate.managedObjectContext];
                                mediaGroup.medium = [mediaGroupData objectForKey:@"medium"];
                                mediaGroup.title = [mediaGroupData objectForKey:@"title"];
                                mediaGroup.url = [mediaGroupData objectForKey:@"url"];
                                NSArray *arr = (NSArray *)[mediaGroupData objectForKey:@"thumbnails"];
                                NSDictionary *dict = (NSDictionary *)[arr objectAtIndex:0];
                                NSString *str = (NSString *)[dict objectForKey:@"url"];
                                if (str && str.length) {
                                    mediaGroup.thumbnail = str;
                                }
                                
                                [entry addMediaGroupsObject:mediaGroup];
                            }                            
                        }
                    }
                    
                    [appDelegate saveContext];
                }
            }
        }
        
        Feed *newFeed = [Feed feedWithURL:urlString];
        if (newFeed) {
            for (Entry *entry in newFeed.entries) {
                NSLog(@"entry: %@", entry.title);
            }
        }
        
        [appDelegate.feedViewController.tableView reloadData];
        
        error = nil;
        
    }];
    
    // fail
    [request setFailedBlock:^{
        NSLog(@"Failed to download %@ status code: %d", url, [request responseStatusCode]);
    }];
    
    [request startSynchronous];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self refreshAction:textField];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self.view addSubview:self.urlField];
        [self.view addSubview:self.refreshButton];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshAction:nil];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
