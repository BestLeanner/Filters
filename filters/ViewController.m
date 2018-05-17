//
//  ViewController.m
//  filters
//
//  Created by zhaohang on 2018/5/15.
//  Copyright © 2018年 HangZhao. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Tools.h"
#import "UIDevice+Tools.h"
#import "DDFilterListView.h"
#import "DDFilterItem.h"
#import "DDFilters.h"
#import "MKGPUImageFilterPipeline.h"


@interface ViewController ()<DDFilterListViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DDFilterListView *filterListView;
@property (nonatomic, strong) DDFilterItem *lastActicityFilter;
@property (nonatomic, strong) NSArray *cameraFilters;
@property (nonatomic, strong) MKGPUImageFilterPipeline *filterSet;
@property (nonatomic, strong) GPUImageView *outputView;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, copy)   NSString *filterName;
@end

@implementation ViewController

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.image = [UIImage imageNamed:@"image"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = [self getImageViewFrame];
    }
    return _imageView;
}

- (CGRect)getImageViewFrame{
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        inset = self.view.safeAreaInsets;
    }
    CGFloat flag = 300+64+10+10;
    CGFloat w = [UIDevice screenWidth]-20-inset.left-inset.right;
    CGFloat maxH = [UIDevice screenHeight]-flag-inset.bottom-inset.top-50;
    CGFloat imgW = 612  ;
    CGFloat imgH = 408;
    CGFloat h = w * imgH / imgW;
    if (h > maxH) {
        h = maxH;
        w = h * imgW / imgH;
    }
    return CGRectMake(([UIDevice screenWidth]-w)/2, 64, w, h);
}

-(GPUImageView *)outputView{
    if (!_outputView) {
        _outputView = [[GPUImageView alloc] init];
        _outputView.backgroundColor = [UIColor clearColor];
        _outputView.frame = self.imageView.frame;
    }
    return _outputView;
}

-(GPUImagePicture *)picture{
    if (!_picture) {
        _picture = [[GPUImagePicture alloc] initWithImage:self.imageView.image];
    }
    return _picture;
}

- (void)initFilterSet{
    _filterSet = [[MKGPUImageFilterPipeline alloc] initWithName:self.filterName input:self.picture output:self.outputView];
    [self.view addSubview:self.outputView];
}

- (NSArray *)cameraFilters{
    if (!_cameraFilters) {
        NSArray *filterArray = @[@"Origin",@"Filter18",@"Filter1",@"Filter5",@"Filter6",@"Filter16",@"Filter7",@"Filter9",@"Filter11",@"Filter8",@"Filter12",@"Filter15",@"Filter17",@"Filter4",@"Filter3",@"Filter2",@"Filter10",@"Filter13",@"Filter14"];
        NSMutableArray *filters = [NSMutableArray array];
        for (NSString *filterName in filterArray) {
            if ([filterName isKindOfClass:[NSString class]]) {
                [filters addObject:[[DDFilterItem alloc] initWithFilterName:filterName
                                                                      image:self.imageView.image
                                                             selectionStyle:DDFilterItemSelectionStyle_Singleton]];
            }
        }
        _cameraFilters = filters;
        
    }
    return _cameraFilters;
}



- (void)prepareFilterListView {
    if (!self.filterListView) {
        
        self.filterListView = [[DDFilterListView alloc] initWithFrame:ccr(0, 400,self.view.width, 300)
                                                          filterItems:self.cameraFilters
                                                       filterDelegate:self
                                                    initialFilterItem:[self.cameraFilters firstObject]];
        [self.filterListView setBackgroundColor:[UIColor blueColor]];
    }
}

- (BOOL)filterListViewSelectedFilter:(DDFilterItem *)filterItem withFilterSwitchView:(DDFilterSwitchView *)filterSwitchView{
    if ([self.filterSet.name isEqualToString:filterItem.btnText]) {
        return NO;
    }
    NSLog(@"%@",filterItem.btnText);
    [self.filterSet changeMainFilterWithName:filterItem.btnText];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self prepareFilterListView];
    self.filterName = @"Origin";
    [self initFilterSet];
    [self.view addSubview:self.filterListView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
