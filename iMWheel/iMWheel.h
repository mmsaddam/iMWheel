//
//  iMWheel.h
//  iMWheel
//
//  Created by Muzahidul Islam on 9/19/15.
//  Copyright (c) 2015 iMuzahid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iMWheelProtocol.h"
#import "iMSector.h"

@interface iMWheel : UIControl

@property (weak) id <iMWheelProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
@end
