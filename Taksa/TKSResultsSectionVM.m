#import "TKSResultsSectionVM.h"

#import "TKSTaxiSuggestCellVM.h"
#import "TKSTaxiDefaultCellVM.h"
#import "TKSTaxiHeaderCellVM.h"
#import "TKSDataProvider.h"

#import <Crashlytics/Crashlytics.h>

@implementation TKSResultsSectionVM

@synthesize cellVMs = _cellVMs;

- (instancetype)initWithModel:(id)model
{
	self = [super initWithModel:model];
	if (self == nil) return nil;

	@weakify(self);

	_cellVMs = @[];

	[[RACObserve(self.model, taxiSections)
		filter:^BOOL(NSArray *results) {
			return results.count > 0;
		}]
		subscribeNext:^(NSArray<TKSTaxiSection *> *taxiList) {
			@strongify(self);

			[self loadResultsForTaxiList:taxiList];
		}];

	return self;
}

- (void)loadResultsForTaxiList:(NSArray<TKSTaxiSection *> *)taxiList
{
	NSArray<TKSBaseVM *> *suggestCells = [taxiList.firstObject.rows.rac_sequence
		map:^TKSTaxiSuggestCellVM *(TKSTaxiRow *taxiRow) {
			return [[TKSTaxiSuggestCellVM alloc] initWithTaxiRow:taxiRow];
		}].array;

	NSArray<TKSBaseVM *> *listCells = [taxiList.lastObject.rows.rac_sequence
		map:^TKSTaxiDefaultCellVM *(TKSTaxiRow *taxiRow) {
			return [[TKSTaxiDefaultCellVM alloc] initWithTaxiRow:taxiRow];
		}].array;

	TKSTaxiHeaderCellVM *headerCellVM = [[TKSTaxiHeaderCellVM alloc] initWithTaxiSection:taxiList.lastObject];
	_cellVMs = [suggestCells arrayByAddingObject:headerCellVM];
	_cellVMs = [_cellVMs arrayByAddingObjectsFromArray:listCells];

	[self reloadSection];
}

- (NSString *)headerTitleLeft
{
	return @"";
}

- (NSString *)headerTitleRight
{
	return @"";
}

- (void)clearSection
{
	_cellVMs = @[];
}

- (void)didSelectCellVMAtIndexPath:(NSIndexPath *)indexPath
{
	TKSBaseVM *cellVM = [self.cellVMs objectAtIndex:indexPath.row];

	if ([cellVM isKindOfClass:[TKSTaxiSuggestCellVM class]] ||
		[cellVM isKindOfClass:[TKSTaxiDefaultCellVM class]])
	{
		TKSTaxiSuggestCellVM *suggestCellVM = (TKSTaxiSuggestCellVM *)cellVM;
		[self trackTaxiRow:suggestCellVM.taxiRow];
		
		[[TKSDataProvider sharedProvider].taxiProcessor processTaxiRow:suggestCellVM.taxiRow];
	}
}

- (void)trackTaxiRow:(TKSTaxiRow *)taxiRow
{
	if (!taxiRow) return;

	NSDictionary *body = @{
		@"search_id" : taxiRow.searchId,
		@"operator_id" : taxiRow.id,
	};

	[[TKSDataProvider sharedProvider] sendAnalyticsForType:@"taxi-select" body:body];

	[Answers logContentViewWithName:@"taxi-select" contentType:taxiRow.searchId contentId:taxiRow.id customAttributes:body];
}

@end
