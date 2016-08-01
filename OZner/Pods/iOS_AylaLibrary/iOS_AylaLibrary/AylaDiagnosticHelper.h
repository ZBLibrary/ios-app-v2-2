//
//  AylaDiagnosticHelper.h
//  iOS_AylaLibrary
//
//  Created by Andy on 3/21/16.
//  Copyright © 2016 AylaNetworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AylaDiagnosticHelper : NSObject

/**
 *  Generate device diagnostics information
 *
 *  @return fromatted dianostic information
 */
+ (NSString *)generateDiagnostics;

- (instancetype)init NS_UNAVAILABLE;

@end
