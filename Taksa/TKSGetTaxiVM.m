#import "TKSGetTaxiVM.h"

@interface TKSGetTaxiVM () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TKSGetTaxiVM

- (void)registerTableView:(UITableView *)tableView
{
	tableView.delegate = self;
	tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return UITableViewAutomaticDimension;
}

@end
