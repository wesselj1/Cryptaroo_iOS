//
//  AppDelegate.m
//  Cryptaroo
//
//  Created by build on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewControlleriPhone.h"
#import "RootViewControlleriPad.h"
#import "DetailViewController.h"
#import "InfoViewController.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize splitViewController = _splitViewController;
@synthesize rootViewControlleriPhone = _rootViewControlleriPhone;
@synthesize rootViewControlleriPad = _rootViewControlleriPad;
@synthesize detailViewController = _detailViewController;
@synthesize textData = _textData;
@synthesize toolbar = _toolbar;
@synthesize toolbarTitle = _toolbarTitle;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // If the user is using an iPad device
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
    {
        // Initialize the app's split, root, and detail views.
        self.splitViewController = [[UISplitViewController alloc] init];
        self.rootViewControlleriPad = [[RootViewControlleriPad alloc] init];
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:nil]; // Default view (Frequency Count) uses DetailView1
        _detailViewController.rootViewController = _rootViewControlleriPad;
        _rootViewControlleriPad.detailViewController = _detailViewController;
        
        UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:_rootViewControlleriPad];
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_detailViewController];
        
        // Set the Root and Detail views
        self.splitViewController.viewControllers = @[rootNav, detailNav];
        self.splitViewController.delegate = _detailViewController;
        
        // Add the root controller and detail navigation controller to the splitview
        self.detailViewController.splitViewController = self.splitViewController; // Set detail view's pointer to the split view
        self.splitViewController.navigationController.navigationBar.translucent = NO;
        
        
        // Finally, set the window's rootViewController to be splitViewController
        self.window.rootViewController = _splitViewController;
    }
    else
    {   // Else, if the user is using an iPhone/iPod device
        
        // Setup the rootViewController and navController
        self.rootViewControlleriPhone = [[RootViewControlleriPhone alloc] init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:_rootViewControlleriPhone];
        self.window.rootViewController = self.navController;
    }
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        self.window.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
 
    [self.window makeKeyAndVisible];
    
    // Create instance of persitent text data class
    _textData = [[TextData alloc] init];

    return YES;
}

- (natural_t)freeMemory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    return vm_stat.free_count * pagesize;
}

void print_free_memory ()
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
}

@end
