//
//  ViewController.m
//  ATEventBus
//
//  Created by linzhiman on 2020/7/9.
//  Copyright © 2020 AppToolbox. All rights reserved.
//

#import "ViewController.h"
#import "ATEventBus.h"

AT_EB_DECLARE(kName, int, a);
AT_EB_DEFINE(kName, int, a);

AT_DECLARE_NOTIFICATION(kSysName);
AT_DECLARE_NOTIFICATION(kSysName2);

@interface ATEventBusTest : NSObject

- (void)regEvent;
- (void)unRegEvent;

@property (nonatomic, strong) id<IATEBEventToken> eventToken;
@property (nonatomic, strong) id<IATEBEventToken> eventToken2;

@end

@implementation ATEventBusTest

- (void)regEvent
{
    [AT_EB_EVENT(kName).observer(self) reg:^(ATEBEvent<ATEB_DATA_kName *> * _Nonnull event) {
        NSLog(@"ATEventBusTest user event %@ %@", event.eventId, @(event.data.a));
    }];
    [AT_EB_EVENT_SYS(kSysName).observer(self) reg:^(ATEBEvent<NSDictionary *> * _Nonnull event) {
        NSLog(@"ATEventBusTest sys event %@ %@", event.eventId, event.data);
    }];

    self.eventToken = [AT_EB_EVENT(kName).observer(self) forceReg:^(ATEBEvent<ATEB_DATA_kName *> * _Nonnull event) {
        NSLog(@"ATEventBusTest user force event %@ %@", event.eventId, @(event.data.a));
    }];
    self.eventToken2 = [AT_EB_EVENT_SYS(kSysName).observer(self) forceReg:^(ATEBEvent<NSDictionary *> * _Nonnull event) {
        NSLog(@"ATEventBusTest sys force event %@ %@", event.eventId, event.data);
    }];
}

- (void)unRegEvent
{
    AT_EB_EVENT(kName).observer(self).unReg();
    AT_EB_EVENT_SYS(kSysName).observer(self).unReg();
    
    [self.eventToken dispose];
    [self.eventToken2 dispose];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ATEventBusTest *test = [ATEventBusTest new];
    [test regEvent];

    [self post:1];

    [test unRegEvent];

    [self post:2];
}

- (void)post:(int)num
{
   [AT_EB_BUS(kName) post_a:num];
   [AT_EB_BUS_SYS(kSysName) post_data:@{@"data":@(num)}];
}

@end
