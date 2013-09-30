//
//  MCNPlistedNavigation.h
//  Jobsite
//
//  Created by Giles Williams on 30/09/2013.
//  Copyright (c) 2013 Evenbase. All rights reserved.
//

#ifndef IS_IPHONE_5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 < DBL_EPSILON
#endif
#ifndef IS_IOS_7
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)
#endif
#ifndef FormatStoryboardString
#define FormatStoryboardString(StoryboardString) [NSString stringWithFormat:@"%@_%@", StoryboardString, ((UI_USER_INTERFACE_IDIOM()) == (UIUserInterfaceIdiomPhone) ? (@"iPhone") : (@"iPad"))]
#endif