/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "SoLaiHatenabookmarkModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

#import "HatenaBookmarkSDK.h"

@interface HTBHatenaBookmarkManager()
@property (nonatomic, readonly) HTBHatenaBookmarkManager* hatenaBookmarkManager;
@end

@implementation SoLaiHatenabookmarkModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"c6f09e95-d59e-430a-8dc9-6d2e4d8241bf";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"so.lai.hatenabookmark";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
  
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)loggedIn
{
	return NUMBOOL(self.hatenaBookmarkManager.authorized);
}

- (void)setup:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);
  [self.hatenaBookmarkManager setConsumerKey:args[@"consumer"] consumerSecret:args[@"secret"]];
}

-(id)authorize:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOAuthLoginView:) name:kHTBLoginStartNotification object:nil];
  [self.hatenaBookmarkManager logout];
  [self.hatenaBookmarkManager authorizeWithSuccess:nil failure:^(NSError *error) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
  }];
  return self;
}

- (void)logout:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  [self.hatenaBookmarkManager logout];
}

- (void)bookmark:(id)args
{
  ENSURE_UI_THREAD_1_ARG(args);
  ENSURE_SINGLE_ARG(args, NSDictionary);
  NSString* url = args[@"url"];
  if(!url.length){
    return;
  }
  
  if(!self.hatenaBookmarkManager.authorized){
    return;
  }
  
  HTBHatenaBookmarkViewController *viewController = [[[HTBHatenaBookmarkViewController alloc] init] autorelease];
  viewController.URL = [NSURL URLWithString:url];
  [TiApp.app showModalController:viewController animated:YES];
}

#pragma Private

- (HTBHatenaBookmarkManager *)hatenaBookmarkManager
{
  return [HTBHatenaBookmarkManager sharedManager];
}

-(void)showOAuthLoginView:(NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTBLoginStartNotification object:nil];

  NSURLRequest *req = (NSURLRequest *)notification.object;
  UINavigationController *navigationController = [[[UINavigationController alloc] initWithNavigationBarClass:[HTBNavigationBar class] toolbarClass:nil] autorelease];
  HTBLoginWebViewController *viewController = [[[HTBLoginWebViewController alloc] initWithAuthorizationRequest:req] autorelease];
  navigationController.viewControllers = @[viewController];
  [TiApp.app showModalController:navigationController animated:YES];
}

@end