//
//  ViewController.m
//  iMWheel
//
//  Created by Muzahidul Islam on 9/19/15.
//  Copyright (c) 2015 iMuzahid. All rights reserved.
//

#import "ViewController.h"
#import "iMWheel.h"

@interface ViewController ()<iMWheelProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    iMWheel *wheel = [[iMWheel alloc]initWithFrame:CGRectMake(0, 0, 200, 200) andDelegate:self withSections:8];
    wheel.layer.anchorPoint = CGPointMake(0.5, 0.5);
    wheel.center = self.view.center;
    [self.view addSubview:wheel];
}

-(void)wheelDidChangeValue:(NSString *)newValue{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
