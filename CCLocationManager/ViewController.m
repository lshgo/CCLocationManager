//
//  ViewController.m
//  CCLocationManager
//
//  Created by 程朋 on 14/12/31.
//  Copyright (c) 2014年 WangZeKeJi. All rights reserved.
//

/*集成说明：
 
 1、在plist添加
 NSLocationAlwaysUsageDescription ＝ YES
 NSLocationWhenInUseUsageDescription ＝ YES
 2、导入CCLocationManager.h头文件
 3、通过block回调获取经纬度、地理位置等
 
 */

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#import "ViewController.h"
#import "CCLocationManager.h"


@interface ViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationmanager;

}
@property(nonatomic,strong)UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    

    [self createButton];
    
}
-(void)createButton{
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, IS_IOS7 ? 30 : 10, 320, 60)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [UIColor redColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"测试位置";
    [self.view addSubview:_textLabel];
    
    UIButton *latBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    latBtn.frame = CGRectMake(100,IS_IOS7 ? 100 : 80, 120, 30);
    [latBtn setTitle:@"获取坐标" forState:UIControlStateNormal];
    [latBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [latBtn addTarget:self action:@selector(getLat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latBtn];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cityBtn.frame = CGRectMake(100,IS_IOS7 ? 150 : 130, 120, 30);
    [cityBtn setTitle:@"获取城市" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.frame = CGRectMake(100,IS_IOS7 ? 200 : 180, 120, 30);
    [allBtn setTitle:@"获取所有信息" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(getAllInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];

}


-(void)getLat
{
    __block __weak ViewController *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            [wself setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];

        }];
    }
    
}

-(void)getCity
{
    __block __weak ViewController *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            NSLog(@"%@",cityString);
            [wself setLabelText:cityString];
            
        }];

    }
    
}


-(void)getAllInfo
{
    __block NSString *string;
    __block __weak ViewController *wself = self;
    
    
    if (IS_IOS8) {

    [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
    } withAddress:^(NSString *addressString) {
        NSLog(@"%@",addressString);
        string = [NSString stringWithFormat:@"%@\n%@",string,addressString];
        [wself setLabelText:string];

    }];
    }
    
}

-(void)setLabelText:(NSString *)text
{
    NSLog(@"text %@",text);
    _textLabel.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
