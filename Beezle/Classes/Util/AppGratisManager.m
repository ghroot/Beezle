//
// Created by Marcus on 28/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AppGratisManager.h"
#import "Logger.h"

#ifdef DEVELOPMENT
static NSString *REMOTE_CONFIGURATION_URL = @"https://dl.dropbox.com/s/kaoavy8uandd35g/remoteConfigurationDev.plist?token_hash=AAGFCL08D3Q9Q4mP93ozZAk3sLy5uE79v5wgEHDf6F9tqw&dl=1";
#else
static NSString *REMOTE_CONFIGURATION_URL = @"https://dl.dropbox.com/s/xsuofr77fxxutxk/remoteConfiguration.plist?token_hash=AAEBBFaKX_2i80aj4u2z5mKHwc4cd0EC-mXa0xODE8CxIw&dl=1";
#endif

static NSString *AD_URL = @"http://appgratis.com/download/?source=StingLab_2013";

@interface AppGratisManager()

-(BOOL) isAppGratisAppInstalled;
-(void) checkRemoteConfiguration;

@end

@implementation AppGratisManager

@synthesize delegate = _delegate;

+(AppGratisManager *) sharedManager
{
	static AppGratisManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(void) dealloc
{
	[_remoteConfigurationConnection cancel];
	[_remoteConfigurationConnection release];
	[_remoteConfigurationData release];

	[super dealloc];
}

-(void) initialise
{
	if ([self isAppGratisAppInstalled])
	{
#ifdef DEBUG
		[[Logger defaultLogger] log:@"AppGratis is installed, skipping ad"];
#endif
	}
	else
	{
		[self checkRemoteConfiguration];
	}
}

-(void) checkRemoteConfiguration
{
	_remoteConfigurationData = [NSMutableData new];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:REMOTE_CONFIGURATION_URL]];
	_remoteConfigurationConnection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
	[_remoteConfigurationConnection start];
}

-(BOOL) isAppGratisAppInstalled
{
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"appg://"]];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_remoteConfigurationData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSDictionary *remoteConfigrationDict = [NSPropertyListSerialization propertyListFromData:_remoteConfigurationData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];

#ifdef DEBUG
	[[Logger defaultLogger] log:@"Loaded remote configuration"];
	[[Logger defaultLogger] log:[NSString stringWithFormat:@"showAppGratisAd: %@", [[remoteConfigrationDict objectForKey:@"showAppGratisAd"] boolValue] ? @"TRUE" : @"FALSE"]];
#endif

	if ([[remoteConfigrationDict objectForKey:@"showAppGratisAd"] boolValue])
	{
		[_delegate showAppGratisAd];
	}
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#ifdef DEBUG
	[[Logger defaultLogger] log:@"Failed to load remote configuration"];
#endif
}

-(void) openAppGratisAdUrl
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:AD_URL]];
}

@end
