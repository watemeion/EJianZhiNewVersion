//
//  ResumeVC.m
//  EJianZhi
//
//  Created by RAY on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "ResumeVC.h"
#import "DVSwitch.h"
#import "freeselectViewCell.h"

#define  PIC_WIDTH 64
#define  PIC_HEIGHT 64
#define  INSETS 10

static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface ResumeVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
    DVSwitch *switcher;
}
@property (weak, nonatomic) IBOutlet UIScrollView *picscrollview;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;

@end

@implementation ResumeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self picScrollViewInit];
    
    [self switcherInit];
    
    //page1
    [self timeCollectionViewInit];
    [self.view1 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-268)];
    [self.mainScrollView addSubview:self.view1];
    
    //page2
    [self.view2 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-268)];
    [self.mainScrollView addSubview:self.view2];
    
    //page3
    [self.view3 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width*2,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-268)];
    
    [self.mainScrollView addSubview:self.view3];
}

- (IBAction)clickBtn1:(id)sender {
    [switcher forceSelectedIndex:1 animated:YES];
}
- (IBAction)clickBtn2:(id)sender {
    [switcher forceSelectedIndex:0 animated:YES];
}
- (IBAction)clickBtn3:(id)sender {
    [switcher forceSelectedIndex:2 animated:YES];
}
- (IBAction)clickBtn4:(id)sender {
    [switcher forceSelectedIndex:1 animated:YES];
}



//图片滑动view
- (void)picScrollViewInit{
    addedPicArray=[[NSMutableArray alloc]init];
    UIButton *btnPic=[[UIButton alloc]initWithFrame:CGRectMake(INSETS, 0, PIC_WIDTH, PIC_HEIGHT)];
    [btnPic setImage:[UIImage imageNamed:@"resume_add"] forState:UIControlStateNormal];
    [addedPicArray addObject:btnPic];
    [self.picscrollview addSubview:btnPic];
    [btnPic addTarget:self action:@selector(addPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshScrollView];
}

- (void)timeCollectionViewInit{
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = ([UIScreen mainScreen].bounds.size.width - 100)/7;
    
    selectfreetimetitleArray = @[
                                 [UIImage imageNamed:@"resume_1"],
                                 [UIImage imageNamed:@"resume_2"],
                                 [UIImage imageNamed:@"resume_3"],
                                 [UIImage imageNamed:@"resume_4"],
                                 [UIImage imageNamed:@"resume_5"],
                                 [UIImage imageNamed:@"resume_6"],
                                 [UIImage imageNamed:@"resume_7"],
                                 ];
    
    selectfreetimepicArray = @[[UIImage imageNamed:@"resume_am1"],
                               [UIImage imageNamed:@"resume_am2"],
                               [UIImage imageNamed:@"resume_pm1"],
                               [UIImage imageNamed:@"resume_pm2"],
                               [UIImage imageNamed:@"resume_night1"],
                               [UIImage imageNamed:@"resume_night2"]
                               ];
    
    for (int index = 0; index<21; index++) {
        selectFreeData[index] = FALSE;
    }
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
}

- (IBAction)addPicAction:(UIButton *)sender {
    
    //添加图片
    UIButton *btnPic=[[UIButton alloc]initWithFrame:CGRectMake(-PIC_WIDTH, 0, PIC_WIDTH, PIC_HEIGHT)];
    [btnPic setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [btnPic setFrame:CGRectMake(-PIC_WIDTH, 0, PIC_WIDTH, PIC_HEIGHT)];
    [addedPicArray addObject:btnPic];
    [btnPic setRestorationIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)addedPicArray.count-1]];
    [btnPic addTarget:self action:@selector(deletePicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.picscrollview addSubview:btnPic];
    
    for (UIButton *btn in addedPicArray) {
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x, btn.center.y)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)]];
        [positionAnim setDelegate:self];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.25f];
        [btn.layer addAnimation:positionAnim forKey:nil];
        
        [btn setCenter:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)];
    }
    [self refreshScrollView];
}

- (void)switcherInit{
    switcher = [DVSwitch switchWithStringsArray:@[@"求职设置", @"自我介绍", @"联系信息"]];
    switcher.frame = CGRectMake(0, 160,[[UIScreen mainScreen] bounds].size.width, 44);
    switcher.backgroundColor = [UIColor whiteColor];
    switcher.sliderColor = [UIColor colorWithRed:41.0/255.0 green:169.0/255.0 blue:220.0/255.0 alpha:1.0];
    switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    switcher.labelTextColorOutsideSlider = [UIColor blackColor];
    switcher.cornerRadius = 0;
    
    [switcher setWillBePressedHandler:^(NSUInteger index) {
        if (index==0)
            [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        else if (index==1)
            [self.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
        else if (index==2)
            [self.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width*2, 0) animated:YES];
    }];
    
    [self.view addSubview:switcher];

}

-(IBAction)deletePicAction:(UIButton *)sender{
    NSInteger btnindex = [sender restorationIdentifier].integerValue;
    UIButton *btn = [addedPicArray objectAtIndex:btnindex];
    [btn removeFromSuperview];
    for (UIButton *tempbtn in addedPicArray) {
        if ([tempbtn restorationIdentifier].intValue > btnindex) {
            [tempbtn setRestorationIdentifier:[NSString stringWithFormat:@"%d",[tempbtn restorationIdentifier].intValue-1]];
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue == btnindex) {
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue < btnindex) {
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x, tempbtn.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)]];
            [positionAnim setDelegate:self];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [tempbtn.layer addAnimation:positionAnim forKey:nil];
            [tempbtn setCenter:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)];
        }
    }
    [addedPicArray removeObjectAtIndex:btnindex];
    [self refreshScrollView];
}


- (void)refreshScrollView
{
    CGFloat width=(PIC_WIDTH+INSETS*2)+(addedPicArray.count-1)*(PIC_WIDTH+INSETS);
    CGSize contentSize=CGSizeMake(width, 0);
    [self.picscrollview setContentSize:contentSize];
    [self.picscrollview setContentOffset:CGPointMake(width<self.picscrollview.frame.size.width?0:width-self.picscrollview.frame.size.width, 0) animated:YES];
}

//page1
#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 28;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(freecellwidth, freecellwidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=0 && indexPath.row<7) {
        return NO;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectFreeData[indexPath.row-7] = selectFreeData[indexPath.row-7]?false:true;
    [collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    freeselectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectFreecellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[freeselectViewCell alloc]init];
    }
    //[[cell imageView]setFrame:CGRectMake(0, 0, freecellwidth, freecellwidth)];
    if (indexPath.row>=0 && indexPath.row<7) {
        cell.imageView.image = [selectfreetimetitleArray objectAtIndex:indexPath.row];
    }
    
    
    if (indexPath.row>=7 && indexPath.row<14) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:1];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:0];
        }
        
    }
    if (indexPath.row>=14 && indexPath.row<21) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:3];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:2];
        }
    }
    if (indexPath.row>=21 && indexPath.row<28) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:5];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:4];
        }
    }
    return cell;
};


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

@end
