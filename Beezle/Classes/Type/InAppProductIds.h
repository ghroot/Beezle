//
//  InAppProductIds.h
//  Beezle
//
//  Created by Me on 19/04/2013.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifdef DEVELOPMENT
static NSString *BURNEE_PRODUCT_ID = @"com.stinglab.inapp.dev.burnee";
static NSString *STINGEE_PRODUCT_ID = @"com.stinglab.inapp.dev.stingee";
static NSString *IRONBEE_PRODUCT_ID = @"com.stinglab.inapp.dev.ironbee";
static NSString *GOGGLES_PRODUCT_ID = @"com.stinglab.inapp.dev.goggles";
#else
static NSString *BURNEE_PRODUCT_ID = @"com.stinglab.inapp.live.burnee50";
static NSString *STINGEE_PRODUCT_ID = @"com.stinglab.inapp.live.stingee50";
static NSString *IRONBEE_PRODUCT_ID = @"com.stinglab.inapp.live.ironbee50";
static NSString *GOGGLES_PRODUCT_ID = @"com.stinglab.inapp.live.goggles50";
#endif
