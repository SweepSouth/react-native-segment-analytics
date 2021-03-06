//
//  Copyright (c) 2016 OnCircle Inc. All rights reserved.
//

#import "SegmentAnalytics.h"
#import "RCTConvert.h"
#import <Analytics/SEGAnalytics.h>
#import <Foundation/Foundation.h>
#import <Segment-Firebase/SEGFirebaseIntegrationFactory.h>
#import <Segment-Mixpanel/SEGMixpanelIntegrationFactory.h>
#import <segment-appsflyer-ios/SEGAppsFlyerIntegrationFactory.h>

@implementation SegmentAnalytics

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setup:(NSDictionary*)config) {
    NSString *configKey = [config objectForKey:@"configKey"];
    NSInteger flushAt = [[config objectForKey:@"flushAt"] integerValue];

    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:configKey];
    [configuration use:[SEGFirebaseIntegrationFactory instance]];
    [configuration use:[SEGMixpanelIntegrationFactory instance]];
    [configuration use:[SEGAppsFlyerIntegrationFactory instance]];

    configuration.flushAt = flushAt;
    configuration.trackApplicationLifecycleEvents = YES;
    configuration.trackAttributionData = YES;
    [SEGAnalytics setupWithConfiguration:configuration];
}

RCT_EXPORT_METHOD(identify:(NSString*)userId traits:(NSDictionary *)traits) {
    [[SEGAnalytics sharedAnalytics] identify:userId traits:[self toStringDictionary:traits]];
}

RCT_EXPORT_METHOD(track:(NSString*)trackText properties:(NSDictionary *)properties) {
    [[SEGAnalytics sharedAnalytics] track:trackText
                               properties:[self toStringDictionary:properties]];
}

RCT_EXPORT_METHOD(screen:(NSString*)screenName properties:(NSDictionary *)properties) {
    [[SEGAnalytics sharedAnalytics] screen:screenName properties:[self toStringDictionary:properties]];
}

RCT_EXPORT_METHOD(alias:(NSString*)aliasId) {
    [[SEGAnalytics sharedAnalytics] alias:aliasId];
}

-(NSMutableDictionary*) toStringDictionary: (NSDictionary *)properties {
    NSMutableDictionary *stringDictionary = [[NSMutableDictionary alloc] init];
    for (NSString* key in [properties allKeys]) {
        if ([[properties objectForKey:key] isKindOfClass:[NSString class]]) {
            id value = [RCTConvert NSString:[properties objectForKey:key]];
            [stringDictionary setObject:value forKey:[RCTConvert NSString:key]];
        }
        if ([[properties objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            id value = [self toStringDictionary:[properties objectForKey:key]];
            [stringDictionary setObject:value forKey:[RCTConvert NSString:key]];
        }

    }
    return stringDictionary;
}

@end
