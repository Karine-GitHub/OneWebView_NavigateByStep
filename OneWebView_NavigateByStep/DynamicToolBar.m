//
//  DynamicToolBar.m
//  OneWebView_NavigateByStep
//
//  Created by admin on 9/9/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "DynamicToolBar.h"
#import "AppDelegate.h"
#import "DisplayViewController.h"

@implementation DynamicToolBar

+ (UIToolbar *) createToolBarIn:(UIView *)parentView withSteps:(NSDictionary *)steps
{
    UIToolbar *dynamicToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 395, parentView.frame.size.width - 70, 45)];
    [dynamicToolBar sizeToFit];
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    
    if ([[steps valueForKey:@"AllowLastUpdateDate"] isEqual:[NSNumber numberWithBool:YES]]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyy 'à' HH:mm"];
        NSString *updateDate = [dateFormat stringFromDate:(NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadDate"]];
        
        UILabel *updateInfos = [[UILabel alloc] init];
        updateInfos.text = [NSString stringWithFormat:@"Mise à jour le %@", updateDate];
        [updateInfos setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        updateInfos.textAlignment = NSTextAlignmentCenter;
        [updateInfos setFrame:CGRectMake(3, 3, dynamicToolBar.frame.size.width - 70, dynamicToolBar.frame.size.height)];
        UIBarButtonItem *labelContainer = [[UIBarButtonItem alloc] initWithCustomView:updateInfos];
        [toolBarItems addObject:labelContainer];
    }
    
    if ([[steps valueForKey:@"AllowApplicationSettings"] isEqual:[NSNumber numberWithBool:YES]]) {
        UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(settingsClick:)];
        [toolBarItems addObject:settings];
    }
    
    if ([[steps valueForKey:@"AllowDataRefresh"] isEqual:[NSNumber numberWithBool:YES]]) {
        //self.refresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(dataRefreshClick)];
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(dataRefreshClick:)];
        [toolBarItems addObject:refresh];
    }
    
    if ([[steps valueForKey:@"AllowSearch"] isEqual:[NSNumber numberWithBool:YES]]) {
        //self.search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick)];
        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick:)];
        [toolBarItems addObject:search];
    }
    
    if ([[steps valueForKey:@"AllowFiltering"] isEqual:[NSNumber numberWithBool:YES]]) {
        //self.filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick)];
        UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick:)];
        [toolBarItems addObject:filter];
    }
    
    if ([[steps valueForKey:@"AllowShare"] isEqual:[NSNumber numberWithBool:YES]]) {
        //self.share = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareClick)];
        UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareClick:)];
        [toolBarItems addObject:share];
    }
    
    if ([[steps valueForKey:@"AllowGeolocalisation"] isEqual:[NSNumber numberWithBool:YES]]) {
        //self.geolocation = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(geolocationClick)];
        UIBarButtonItem *geolocation = [[UIBarButtonItem alloc] initWithTitle:@"Loc" style:UIBarButtonItemStyleBordered target:self action:@selector(geolocationClick:)];
        [toolBarItems addObject:geolocation];
    }
    
    if ([[steps valueForKey:@"AllowAddContact"] isEqual:[NSNumber numberWithBool:YES]]) {
        //self.contact = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonClick)];
        UIBarButtonItem *contact = [[UIBarButtonItem alloc] initWithTitle:@"Contact" style:UIBarButtonItemStyleBordered target:self action:@selector(contactClick:)];
        [toolBarItems addObject:contact];
    }
    
    if ([[steps valueForKey:@"AllowAddCalendar"] isEqual:[NSNumber numberWithBool:YES]]) {
        //self.calendar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonClick)];
        UIBarButtonItem *calendar = [[UIBarButtonItem alloc] initWithTitle:@"Calendar" style:UIBarButtonItemStyleBordered target:self action:@selector(calendarClick:)];
        [toolBarItems addObject:calendar];
    }
    
    if ([[steps valueForKey:@"AllowPageNavigation"] isEqual:[NSNumber numberWithBool:YES]]) {
        UIStepper *navigate = [[UIStepper alloc] init];
        [navigate setMinimumValue:0];
        [navigate setMaximumValue:100];
        [navigate addTarget:self action:@selector(navigateClick:) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem *stepperContainer = [[UIBarButtonItem alloc] initWithCustomView:navigate];
        [toolBarItems addObject:stepperContainer];
    }
    
    [dynamicToolBar setItems:toolBarItems animated:YES];
    NSLog(@"Nb of items : %d", toolBarItems.count);
    return dynamicToolBar;
}

+ (void) settingsClick:(id)sender
{
    // 1° : toolbar, 2° : view, 3° : viewController
    NSLog(@"Nextresponder : %@",[[[sender nextResponder] nextResponder] nextResponder]);
    
    UIViewController *controller = (UIViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    [controller.navigationController pushViewController:[controller.storyboard instantiateViewControllerWithIdentifier:@"settingsView"] animated:YES];
}

+ (void) dataRefreshClick:(id)sender
{
    AppDelegate *appDel = [[AppDelegate alloc] init];
    forceDownloading = YES;
    [appDel performSelectorInBackground:@selector(configureApp) withObject:appDel];
    
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    [controller initApp];
}

+ (void) searchClick:(id)sender
{}

+ (void) filterClick:(id)sender
{}

+ (void) shareClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    /* Fonctionne : NSString *js = @"function getShareData(){return \"bla\";} getShareData()";
    /NSString *obj = [controller.Display stringByEvaluatingJavaScriptFromString:js"]; */
    
    /* Fonctionne NSString *js_json = @"function getData() {  var json = null; $.getJSON('http://headers.jsontest.com').done(function( data ) { alert(data); alert(JSON.stringify(data));});} getData()";
    [controller.Display stringByEvaluatingJavaScriptFromString:js_json]; */
    
    //String empty => NSString *js_json2 = @"function getData() { var json = $.getJSON('http://headers.jsontest.com').done(function( data ) { json = JSON.stringify(data); return String(json);}); } getData()";
    
    
    NSString *js_json2 = @"function getData() { var json; $.ajax({url: 'http://headers.jsontest.com',dataType: 'json',async: false,success: function(data) {json = JSON.stringify(data);return json;}});return json;}; getData()";
    NSString *obj = [controller.Display stringByEvaluatingJavaScriptFromString:js_json2];
    NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    NSData *imgFile = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.zimagez.com/avatar/img7812.jpg"]];
    UIImage *shareImage = [UIImage imageWithData:imgFile];
    NSString *shareMessage = @"test share";
    NSURL *shareUrl = [NSURL URLWithString:@"http://www.visionitgroup.lu"];
    NSArray *shareArray = [NSArray arrayWithObjects:shareMessage, shareImage, shareUrl, nil];
    
    UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    [share setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [controller presentViewController:share animated:YES completion:nil];
}

+ (void) geolocationClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    NSString *js = @"function getGeolocalisationData(){return \"6.12820?49.60410\";} getGeolocalisationData()";

    NSString *obj = [controller.Display stringByEvaluatingJavaScriptFromString:js];
    
    NSRange separator = [obj rangeOfString:@"?"];
    NSString *longitude = [obj substringToIndex:separator.location];
    NSString *lattitude = [obj substringFromIndex:separator.location +1];
    
    /* Fonctionne mais pas d'annotation sur la carte
    NSURL*request = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@", lattitude, longitude]];
    [[UIApplication sharedApplication] openURL:request];*/
    
    CLLocationCoordinate2D coordonnees = CLLocationCoordinate2DMake([lattitude doubleValue], [longitude doubleValue]);
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:coordonnees addressDictionary:nil];
    MKMapItem *map = [[MKMapItem alloc] initWithPlacemark:placeMark];
    [map setName:@"Map's Name"];
    [map openInMapsWithLaunchOptions:nil];
    
    /* MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(49.60410, 6.12820);
    annotation.title = @"Here !";
    annotation.subtitle = @"subtitle";
    [controller.mapView addAnnotation:annotation];
    MKCoordinateRegion region;
    region.center.longitude = 6.12820;
    region.center.latitude = 49.60410;
    region.span.latitudeDelta = 0.0725;
    region.span.longitudeDelta = 0.0725;
    controller.Display.hidden = YES;
    controller.mapView.hidden = NO;
    [controller.mapView setRegion:region animated:YES];*/
    
    // With address
    /*NSString *adresse = @"7 rue des merovingiens L-8070 BERTRANGE";
    
    controller.Display.hidden = YES;
    controller.mapView.hidden = NO;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:adresse completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span.latitudeDelta = 0.0725;
            region.span.longitudeDelta = 0.0725;
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            annotation.title = @"Vision IT is Here !";
            annotation.subtitle = adresse;
            [controller.mapView addAnnotation:annotation];
            [controller.mapView setRegion:region animated:YES];
            NSLog(@"Latitude : %f", region.center.latitude);
            NSLog(@"Longitude : %f", region.center.longitude);
        }
    }];*/
}

+ (void) contactClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    NSObject *obj = [controller.Display stringByEvaluatingJavaScriptFromString:@"getAddContactData()"];
}

+ (void) calendarClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    NSObject *obj = [controller.Display stringByEvaluatingJavaScriptFromString:@"getAddCalendarData()"];

    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:store];
    NSDateFormatter *formateDate = [[NSDateFormatter alloc] init];
    [formateDate setDateFormat:@"YYYYMMddHHmmss"];
    event.title = @"My new RDV @CHD";
    event.location = @"23, rue du Marché-aux-Herbes L-1728 Luxembourg";
    //event.startDate = [formateDate dateFromString:[request.URL query]];
    event.startDate = [NSDate dateWithTimeIntervalSinceNow:77777];
    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        [event setCalendar:[store defaultCalendarForNewEvents]];
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        //NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
        
        // Alert user that adding is finished
        if(error) {
            NSString *successMsg = [NSString stringWithFormat:@"Your rdv is now added to your calendar. "];
            controller.SettingsDone = [[UIAlertView alloc] initWithTitle:@"Event Successfully Added" message:successMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [controller.SettingsDone performSelectorOnMainThread:@selector(show) withObject:self waitUntilDone:YES];
        }
    }];
}

+ (void) navigateClick:(id)sender
{

}


@end
