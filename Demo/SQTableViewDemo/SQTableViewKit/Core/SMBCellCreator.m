//
//  DTPNewGroupCellCretaer.m
//  DTPocket
//
//  Created by sqb on 15/3/11.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import "SMBCellCreator.h"
#import "SMBBaseTableInfoHead.h"

@interface SMBCellCreator ()
@property NSMutableDictionary * sectionDic;
@end

@implementation SMBCellCreator
+(instancetype)sharedInstance{
    static SMBCellCreator *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedInstance = [[SMBCellCreator alloc] init];
    });
    return _sharedInstance;
}

//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}

-(UITableViewCell *)getTableViewCell:(SMBBaseTableInfo *)createInfo
{
    //    DTPSquareDelegateInfo* curInfo = createInfo.delegateInfo;
    return [self  cellForSection:createInfo];
}

-(UIView*)getHeadView:(SMBBaseTableInfo *)createInfo
{
    //    DTPSquareDelegateInfo* curInfo = createInfo.delegateInfo;
    return [self  viewForHeadSection:createInfo];
}

-(UIView*)getFootView:(SMBBaseTableInfo *)createInfo
{
    //    DTPSquareDelegateInfo* curInfo = createInfo.delegateInfo;
    return [self  viewForFootSection:createInfo];
}

#pragma mark--
#pragma mark cell for section delegate
-(UITableViewCell *)cellForSection:(SMBBaseTableInfo *)info
{
    UITableViewCell * cell = nil;
    SMBBaseTableSectionInfo * delegateInfo = info.delegateInfo;
    SMBBaseTableCellInfo * cellInfo = delegateInfo.cellDataArray[info.indexPath.row];
    NSString * nibName = cellInfo.cellNibName;
    NSString * className = cellInfo.cellClassName;
    if (nibName) {
        
        cell = [self reuseCell:info.tableView cellID:nibName];
        if (!cell) {
            cell = [self loadNibCellWithNibName:nibName tableView:info.tableView reuseIdentifier:nibName];
        }
    }else
    {
        cell = [self reuseCell:info.tableView cellID:className];
        if (!cell) {
            cell = [[NSClassFromString(className) alloc]initWithStyle:cellInfo.cellStyle reuseIdentifier:className];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self dataForCell:cell cellForRowAtIndexPath:info.indexPath cellDataArray:delegateInfo.cellDataArray VCDelegate:info.viewController];
    return cell;
}


-(UITableViewCell*)reuseCell:(UITableView *)tableView cellID:(NSString*)cellID
{
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

-(void)dataForCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath cellDataArray:(NSArray *)cellDataArray VCDelegate:(id)VCDelegate
{
    SMBBaseTableCellInfo * info = [self getCellInfo:cellDataArray cellForRowAtIndexPath:indexPath];
    info.cellIndex = indexPath.row;
    info.sectionIndex = indexPath.section;
    info.VCDelegate = VCDelegate;
    if (info) {
        [cell fillData:info];
    }else
    {
        
    }
}

-(SMBBaseTableCellInfo*)getCellInfo:(NSArray*)cellDataArray cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellDataArray.count > indexPath.row) {
        return [cellDataArray objectAtIndex:indexPath.row];
    }else
    {
        return nil;
    }
}

#pragma mark--
#pragma mark view for head section delegate
-(UIView *)viewForHeadSection:(SMBBaseTableInfo *)info
{
    UITableViewCell * cell = nil;
    SMBBaseTableSectionInfo * delegateInfo = info.delegateInfo;
    SMBBaseTableHeadViewInfo * cellInfo = delegateInfo.headViewInfo;
    NSString * nibName = cellInfo.cellNibName;
    NSString * className = cellInfo.cellClassName;
    if (nibName) {
        
        cell = [self reuseCell:info.tableView cellID:nibName];
        if (!cell) {
            cell = [self loadNibCellWithNibName:nibName tableView:info.tableView reuseIdentifier:nibName];
        }
    }else
    {
        cell = [self reuseCell:info.tableView cellID:className];
        if (!cell) {
            cell = [[NSClassFromString(className) alloc]initWithStyle:cellInfo.cellStyle reuseIdentifier:className];
        }
    }
    [self dataForHeadView:cell section:info.section sectionViewInfo:delegateInfo.headViewInfo VCDelegate:info.viewController];
    return cell;
}

#pragma mark--
#pragma mark view for foot section delegate
-(UIView *)viewForFootSection:(SMBBaseTableInfo *)info
{
    UITableViewCell * cell = nil;
    SMBBaseTableSectionInfo * delegateInfo = info.delegateInfo;
    SMBBaseTableFootViewInfo * cellInfo = delegateInfo.footViewInfo;
    NSString * nibName = cellInfo.cellNibName;
    NSString * className = cellInfo.cellClassName;
    if (nibName) {
        
        cell = [self reuseCell:info.tableView cellID:nibName];
        if (!cell) {
            cell = [self loadNibCellWithNibName:nibName tableView:info.tableView reuseIdentifier:nibName];
        }
    }else
    {
        cell = [self reuseCell:info.tableView cellID:className];
        if (!cell) {
            cell = [[NSClassFromString(className) alloc]initWithStyle:cellInfo.cellStyle reuseIdentifier:className];
        }
    }
    [self dataForFootView:cell section:info.section sectionViewInfo:delegateInfo.footViewInfo VCDelegate:info.viewController];
    return cell;
}


-(UITableViewHeaderFooterView*)reuseHeadViewCell:(UITableView *)tableView cellID:(NSString*)cellID
{
    UITableViewHeaderFooterView * cell = nil;
    cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    return cell;
}

-(void)dataForHeadView:(UITableViewCell *)cell section:(NSInteger)section sectionViewInfo:(SMBBaseTableHeadViewInfo *)headViewInfo VCDelegate:(id)VCDelegate
{
    headViewInfo.cellIndex = section;
    headViewInfo.VCDelegate = VCDelegate;
    if (headViewInfo) {
        [cell fillData:headViewInfo];
    }else
    {
        
    }
}

-(void)dataForFootView:(UITableViewCell *)cell section:(NSInteger)section sectionViewInfo:(SMBBaseTableFootViewInfo *)headViewInfo VCDelegate:(id)VCDelegate
{
    headViewInfo.cellIndex = section;
    headViewInfo.VCDelegate = VCDelegate;
    if (headViewInfo) {
        [cell fillData:headViewInfo];
    }else
    {
        
    }
}

-(UITableViewCell*)loadNibCellWithNibName:(NSString*)nibName tableView:(UITableView *)tableView reuseIdentifier:(NSString*)reuseId
{
    UINib * nib = [UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reuseId];
    return [tableView dequeueReusableCellWithIdentifier:reuseId ];
}

@end
