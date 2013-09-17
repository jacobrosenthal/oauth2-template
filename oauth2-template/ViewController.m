//
//  ViewController.m
//  oauth2-template
//
//  Created by Jacob on 9/10/13.
//  Copyright (c) 2013 Example. All rights reserved.
//

#import "ViewController.h"
#import "TwitterOauth2.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, TwitterOauth2Delgate>

@property (strong, nonatomic) IBOutlet UITableView      *dataTable;

@property TwitterOauth2 *twitter;

@property NSMutableArray *trends;

@end

@implementation ViewController

@synthesize dataTable;
@synthesize twitter;
@synthesize trends;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    twitter = [[TwitterOauth2 alloc] initWithDelegate:self];
    
    //twitter doesnt have a way to check for valid auth, so just send for the token again
    [twitter authenticateApp];
    
}

- (void) viewDidUnload
{
    [self setDataTable:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TwitterOauth2 Delegates
- (void) didReceiveValidAppAuth{
    
    //USA woeid == 23424977
    [twitter retreiveTrendsByWOEID:@"23424977"];
}

- (void) didReceiveTrendsByWOEID:(NSDictionary *)trends
{
    //save trend strings locally
    self.trends = [NSMutableArray array];
    NSDictionary *trend;
    for(trend in trends)
    {
        [self.trends addObject:[trend objectForKey:@"name"]];
        //NSLog(@"%@", [b objectForKey:@"name"]);
    }
    
    //tell table we have fresh data
    [self.dataTable reloadData];
}

- (void) didReceiveError:(NSError *)error fromData:(NSData *)data{
    //if wasnt a valid token, try again?
    //
}

#pragma mark -
#pragma mark TableView Delegates
/****************************************************************************/
/*							TableView Delegates								*/
/****************************************************************************/
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oauth2-template-root-view"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"oauth2-template-root-view"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //copy trends strings into datasource object
    cell.textLabel.text = [trends objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
	return cell;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [trends count];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
