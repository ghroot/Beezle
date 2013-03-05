//
// Created by Marcus on 28/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

@protocol AppGratisDelegate <NSObject>

-(void) showAppGratisAd;

@end

@interface AppGratisManager : NSObject <NSURLConnectionDataDelegate>
{
	NSURLConnection *_remoteConfigurationConnection;
	NSMutableData *_remoteConfigurationData;

	id<AppGratisDelegate> _delegate;
}

@property (nonatomic, assign) id<AppGratisDelegate> delegate;

+(AppGratisManager *) sharedManager;

-(void) initialise;
-(void) openAppGratisAdUrl;

@end
