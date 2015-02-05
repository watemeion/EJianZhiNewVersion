//
//  MLFirstVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFirstVC.h"
#import "SRAdvertisingView.h"
//#import "MLCell1.h"
#import "JobListTableViewCell.h"
#import "SRScanVC.h"
#import "ResumeVC.h"
#import "JobDetailVC.h"
#import "MLJobListViewController.h"

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface MLFirstVC ()<ValueClickDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int cellNum;
}
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SRAdvertisingView *blankView;


- (IBAction)findJobWithLocationAction:(id)sender;


- (IBAction)findJobWithCardAction:(id)sender;

- (IBAction)jobAsTeacherAction:(id)sender;

- (IBAction)jobAsAccountingAction:(id)sender;
- (IBAction)jobAsModelAction:(id)sender;

- (IBAction)jobAsOutseaStuAction:(id)sender;

@end

@implementation MLFirstVC
@synthesize tableHeadView=_tableHeadView;
@synthesize tableView=_tableView;
- (IBAction)scan:(id)sender {
    //[self setupCamera];
}
- (IBAction)resume:(id)sender {
    ResumeVC *VC=[[ResumeVC alloc]init];
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBar"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(location)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareJob)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    [self tableViewInit];
    [self advertisementInit];
}

//*********************tableView********************//
- (void)tableViewInit{
    cellNum=10;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
    [_tableHeadView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 284+130*[[UIScreen mainScreen] bounds].size.width/320)];
    [_tableView setTableHeaderView:_tableHeadView];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    BOOL nibsRegistered = NO;
//    
//    static NSString *Cellidentifier=@"MLCell1";
//    if (!nibsRegistered) {
//        UINib *nib = [UINib nibWithNibName:@"MLCell1" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
//        nibsRegistered = YES;
//    }
//    
//    MLCell1 *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
//    cell.accessoryType=UITableViewCellAccessoryNone;
//    
//    NSUInteger row=[indexPath row];
    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"JobListTableViewCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"JobListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    JobListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNum;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobDetailVC *detailVC=[[JobDetailVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}


- (void)location{
    
}

- (void)shareJob{
    
}

//*********************Banner********************//
-(void)advertisementInit{
    

    NSMutableArray *urlArray=[[NSMutableArray alloc]init];
    
    [urlArray addObject:@"http://ac-gtcxbmll.clouddn.com/7pGXzjWe0tQ0Y3gK9Ei1FzDz7m531PVvaU58ziDt.jpg"];
    [urlArray addObject:@"http://ac-gtcxbmll.clouddn.com/7pGXzjWe0tQ0Y3gK9Ei1FzDz7m531PVvaU58ziDt.jpg"];
    [urlArray addObject:@"http://ac-gtcxbmll.clouddn.com/7pGXzjWe0tQ0Y3gK9Ei1FzDz7m531PVvaU58ziDt.jpg"];


    SRAdvertisingView *bannerView=[[SRAdvertisingView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 130*[[UIScreen mainScreen] bounds].size.width/320) imageArray:urlArray interval:3.0];
    
    bannerView.vDelegate=self;
    [self.blankView addSubview:bannerView];
}

- (void)buttonClick:(int)vid{
    
}



//-(void)setupCamera
//{
//    if(IOS7)
//    {
//        SRScanVC * scanVC = [[SRScanVC alloc]init];
//        scanVC.scanDelegate=self;
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//        backItem.title = @"";
//        backItem.tintColor=[UIColor whiteColor];
//        self.navigationItem.backBarButtonItem = backItem;
//        scanVC.hidesBottomBarWhenPushed=YES;
//        
//        [self.navigationController pushViewController:scanVC animated:YES];
//        
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)findJobWithLocationAction:(id)sender {
    
    [self showListView];
}

- (IBAction)findJobWithCardAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsTeacherAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsAccountingAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsModelAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsOutseaStuAction:(id)sender {
    [self showListView];
}



#pragma --mark  ListViewInit Method

-(void)showListView
{
    MLJobListViewController *jobListView=[[MLJobListViewController alloc]init];
    
    jobListView.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:jobListView animated:YES];

}
@end
