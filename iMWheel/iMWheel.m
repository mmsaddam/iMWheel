//
//  iMWheel.m
//  iMWheel
//
//  Created by Muzahidul Islam on 9/19/15.
//  Copyright (c) 2015 iMuzahid. All rights reserved.
//

#import "iMWheel.h"
#import <QuartzCore/QuartzCore.h>



@interface iMWheel ()

-(void)drawWheel;
- (void) buildSectorsEven;
- (void) buildSectorsOdd;
@end

static float deltaAngle;
static float minAlphavalue = 0.6;
static float maxAlphavalue = 1.0;

@implementation iMWheel
@synthesize container = _container;
@synthesize numberOfSections = _numberOfSections;
@synthesize startTransform = _startTransform;
@synthesize sectors = _sectors;
@synthesize currentSector = _currentSector;

-(id)initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        [self drawWheel];
//        [NSTimer scheduledTimerWithTimeInterval:2.0
//                                         target:self
//                                       selector:@selector(rotate)
//                                       userInfo:nil
//                                        repeats:YES];
    }
    return self;
}


-(void)drawWheel{
    
    _container = [[UIView alloc]initWithFrame:self.frame];
    CGFloat angleSize = (2*M_PI)/_numberOfSections;
    for (int i =0 ; i< _numberOfSections; i++) {
        UILabel *im = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        im.backgroundColor = [UIColor redColor];
        im.text = [NSString stringWithFormat:@"%zd",i];
        im.layer.anchorPoint = CGPointMake(1.0, 0.5);
        im.layer.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
        [_container addSubview:im];
    }
    
    [_container setUserInteractionEnabled:NO];
    [self addSubview:_container];
    
    _sectors = [NSMutableArray arrayWithCapacity:_numberOfSections];
    if (_numberOfSections % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }
      self.currentSector = 0;
     [self.delegate wheelDidChangeValue:[NSString stringWithFormat:@"value is %i", self.currentSector]];
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
      //  Get touch position
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    
    if (dist < 40 || dist > 100)
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
      //  return NO;
    }
    //  Calculate distance from center
    float dx = touchPoint.x - _container.center.x;
    float dy = touchPoint.y - _container.center.y;
    //  Calculate arctangent value
    deltaAngle = atan2(dy,dx);
    //  Save current transform
    _startTransform = _container.transform;
    return YES;
    
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
   
    CGFloat radians = atan2f(_container.transform.b, _container.transform.a);
    NSLog(@"rad is %f", radians);
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x  - _container.center.x;
    float dy = pt.y  - _container.center.y;
    float ang = atan2(dy,dx);
    float angleDifference = deltaAngle - ang;
    _container.transform = CGAffineTransformRotate(_startTransform, -angleDifference);
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    // 1 - Get current container rotation in radians
    CGFloat radians = atan2f(_container.transform.b, _container.transform.a);
    // 2 - Initialize new value
    CGFloat newVal = 0.0;
    // 3 - Iterate through all the sectors
    for (iMSector *s in _sectors) {
        // 4 - Check for anomaly (occurs with even number of sectors)
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                // 5 - Find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                _currentSector = s.sector;
            }
        }
        // 6 - All non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            _currentSector = s.sector;
        }    }
    
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform t = CGAffineTransformRotate(_container.transform, -newVal);
        _container.transform = t;
    }];
    

}


-(void)rotate{
    CGAffineTransform t = CGAffineTransformRotate(_container.transform, -0.78);
    _container.transform = t;
}

- (void) buildSectorsOdd {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/_numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < _numberOfSections; i++) {
        iMSector *sector = [[iMSector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        // 5 - Add sector to array
        [_sectors addObject:sector];
        NSLog(@"cl is %@", sector);
    }
}

- (void) buildSectorsEven {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/_numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < _numberOfSections; i++) {
        iMSector *sector = [[iMSector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
            
        }
        mid -= fanWidth;
        NSLog(@"cl is %@", sector);
        // 5 - Add sector to array
        [_sectors addObject:sector];
    }
}

@end
