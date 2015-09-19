//
//  iMWheelProtocol.h
//  iMWheel
//
//  Created by Muzahidul Islam on 9/19/15.
//  Copyright (c) 2015 iMuzahid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iMWheelProtocol <NSObject>
- (void) wheelDidChangeValue:(NSString *)newValue;
@end
