//
//  iMSector.m
//  iMWheel
//
//  Created by Muzahidul Islam on 9/19/15.
//  Copyright (c) 2015 iMuzahid. All rights reserved.
//

#import "iMSector.h"

@implementation iMSector
-(NSString *)description{
    
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.sector, self.minValue, self.midValue, self.maxValue];
}
@end
