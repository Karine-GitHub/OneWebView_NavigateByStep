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
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    UIToolbar *dynamicToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenBound.size.height - 44, screenBound.size.width, 60)];
    [dynamicToolBar sizeToFit];
    [dynamicToolBar setTranslucent:YES];
    [dynamicToolBar setBackgroundColor:parentView.backgroundColor];
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    
    if ([[steps valueForKey:@"AllowDataRefreshing"] isEqual:[NSNumber numberWithBool:YES]]) {
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(dataRefreshClick:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [toolBarItems addObject:refresh];
        [toolBarItems addObject:space];
    }
    
    if ([[steps valueForKey:@"AllowLastUpdateDate"] isEqual:[NSNumber numberWithBool:YES]]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyy 'à' HH:mm"];
        NSString *update = [dateFormat stringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadDate"]];
        
        UILabel *updateInfos = [[UILabel alloc] init];
        updateInfos.text = [NSString stringWithFormat:@"Mise à jour le %@", update];
        [updateInfos setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        updateInfos.textAlignment = NSTextAlignmentCenter;
        [updateInfos setFrame:CGRectMake(3, 3, dynamicToolBar.frame.size.width - 80, dynamicToolBar.frame.size.height)];
        UIBarButtonItem *labelContainer = [[UIBarButtonItem alloc] initWithCustomView:updateInfos];
        [toolBarItems addObject:labelContainer];
    }
    
    if ([[steps valueForKey:@"AllowApplicationSettings"] isEqual:[NSNumber numberWithBool:YES]]) {
        //UIImage *settingsImg = [[UIImage imageNamed:@"20-gear2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-free.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(settingsClick:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:settings];
        [toolBarItems addObject:space];

    }
    
    if ([[steps valueForKey:@"AllowSearching"] isEqual:[NSNumber numberWithBool:YES]]) {
        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:search];
        [toolBarItems addObject:space];

    }
    
    if ([[steps valueForKey:@"AllowFiltering"] isEqual:[NSNumber numberWithBool:YES]]) {
        //UIImage *filterImg = [[UIImage imageNamed:@"Filter-44.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filterClick:)];
        [filter setImage:[UIImage imageNamed:@"filter-free.png"]];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:filter];
        [toolBarItems addObject:space];

    }
    
    if ([[steps valueForKey:@"AllowSorting"] isEqual:[NSNumber numberWithBool:YES]]) {
        //UIImage *sortImg = [[UIImage imageNamed:@"sort-44.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortClick:)];
        [sort setImage:[UIImage imageNamed:@"sort_alphabetical_free.png"]];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:sort];
        [toolBarItems addObject:space];
    }
    
    if ([[steps valueForKey:@"AllowSharing"] isEqual:[NSNumber numberWithBool:YES]]) {
        //UIImage *shareImg = [[UIImage imageNamed:@"share.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareClick:)];
        [share setImage:[UIImage imageNamed:@"ShareFree-32.png"]];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:share];
        [toolBarItems addObject:space];
    }
    
    if ([[steps valueForKey:@"AllowGeolocalisation"] isEqual:[NSNumber numberWithBool:YES]]) {
        //UIImage *geolocImg = [[UIImage imageNamed:@"geolocation-44.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *geolocation = [[UIBarButtonItem alloc] initWithTitle:@"Loc" style:UIBarButtonItemStyleBordered target:self action:@selector(geolocationClick:)];
        [geolocation setImage:[UIImage imageNamed:@"maps-free.png"]];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:geolocation];
        [toolBarItems addObject:space];
    }
    
    if ([[steps valueForKey:@"AllowAddContact"] isEqual:[NSNumber numberWithBool:YES]]) {
        //UIImage *contactImg = [[UIImage imageNamed:@"contact.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *contact = [[UIBarButtonItem alloc] initWithTitle:@"Contact" style:UIBarButtonItemStyleBordered target:self action:@selector(contactClick:)];
        [contact setImage:[UIImage imageNamed:@"Business-Contact-icon.png"]];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:contact];
        [toolBarItems addObject:space];
    }
    
    if ([[steps valueForKey:@"AllowAddCalendar"] isEqual:[NSNumber numberWithBool:YES]]) {
        //UIImage *calendarImg = [[UIImage imageNamed:@"calendar-44.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *calendar = [[UIBarButtonItem alloc] initWithTitle:@"Calendar" style:UIBarButtonItemStyleBordered target:self action:@selector(calendarClick:)];
        [calendar setImage:[UIImage imageNamed:@"Calendar-free.png"]];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        [toolBarItems addObject:calendar];
        [toolBarItems addObject:space];
    }
    
    if ([[steps valueForKey:@"AllowPageNavigation"] isEqual:[NSNumber numberWithBool:YES]]) {
        DisplayViewController *controller = (DisplayViewController *)[parentView nextResponder];
        UIStepper *navigate = [[UIStepper alloc] init];
        [navigate setMinimumValue:0];
        [navigate setMaximumValue:(double)controller.itemsCount];
        [navigate setValue:(double)controller.currentDetailsId];
        [navigate addTarget:self action:@selector(navigateClick:) forControlEvents:UIControlEventValueChanged];
        [navigate setIncrementImage:[UIImage imageNamed:@"arrow-up-free.png"] forState:UIControlStateNormal];
        [navigate setDecrementImage:[UIImage imageNamed:@"arrow-down-free.png"] forState:UIControlStateNormal];
        UIBarButtonItem *stepperContainer = [[UIBarButtonItem alloc] initWithCustomView:navigate];
        [toolBarItems addObject:stepperContainer];
    }
    
    [dynamicToolBar setItems:toolBarItems animated:YES];
    return dynamicToolBar;
}

+ (void) settingsClick:(id)sender
{
    // 1° : toolbar, 2° : view, 3° : viewController
    UIViewController *controller = (UIViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    [controller.navigationController pushViewController:[controller.storyboard instantiateViewControllerWithIdentifier:@"settingsView"] animated:YES];
}

+ (void) dataRefreshClick:(id)sender
{
    AppDelegate *appDel = [[AppDelegate alloc] init];
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    refreshByToolbar = YES;
    [appDel performSelectorInBackground:@selector(configureApp) withObject:appDel];
    
    [controller initApp];
}

+ (void) searchClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    [controller.Display stringByEvaluatingJavaScriptFromString:@"showSearch()"];
}

+ (void) filterClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    [controller.Display stringByEvaluatingJavaScriptFromString:@"showFilterForm()"];
}

+ (void) sortClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    [controller.Display stringByEvaluatingJavaScriptFromString:@"Sort()"];
}

+ (void) shareClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    NSString *result = [controller.Display stringByEvaluatingJavaScriptFromString:@"getShareData()"];
    NSData *dataResult = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:nil];

    NSMutableArray *shareArray = [[NSMutableArray alloc] init];
    if ([jsonResult objectForKey:@"urlImage"]) {
        NSData *imgFile = [NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonResult objectForKey:@"urlImage"]]];
        UIImage *shareImage = [UIImage imageWithData:imgFile];
        [shareArray addObject:shareImage];
    }
    if ([jsonResult objectForKey:@"message"]) {
        NSString *shareMessage = [jsonResult objectForKey:@"message"];
        [shareArray addObject:shareMessage];
    }
    if ([jsonResult objectForKey:@"url"]) {
        NSString *url;
        NSRange check = [[jsonResult objectForKey:@"url"] rangeOfString:@"http"];
        if (check.location == NSNotFound) {
            url = [NSString stringWithFormat:@"http://%@", [jsonResult objectForKey:@"url"]];
        } else {
            url = [jsonResult objectForKey:@"url"];
        }
        NSURL *shareUrl = [NSURL URLWithString:url];
        [shareArray addObject:shareUrl];
    }
    
    UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    [share setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [controller.navigationController presentViewController:share animated:YES completion:nil];
}

+ (void) geolocationClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    NSString *result = [controller.Display stringByEvaluatingJavaScriptFromString:@"getGeolocalisationData()"];
    NSData *dataResult = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:nil];
    
    NSString *longitude = [jsonResult objectForKey:@"longitude"];
    NSString *lattitude = [jsonResult objectForKey:@"lattitude"];
    
    /* Fonctionne mais pas d'annotation sur la carte
    NSURL*request = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@", lattitude, longitude]];
    [[UIApplication sharedApplication] openURL:request];*/
    
    CLLocationCoordinate2D coordonnees = CLLocationCoordinate2DMake([lattitude doubleValue], [longitude doubleValue]);
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:coordonnees addressDictionary:nil];
    MKMapItem *map = [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    if ([jsonResult objectForKey:@"name"]) {
        [map setName:@"Map's Name"];
    }
    
    [map openInMapsWithLaunchOptions:nil];
    
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

    NSString *result = [controller.Display stringByEvaluatingJavaScriptFromString:@"getAddContactData()"];
    NSData *dataResult = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:nil];
    
    ABUnknownPersonViewController *addContact = [[ABUnknownPersonViewController alloc] init];
    addContact.unknownPersonViewDelegate = controller;
    addContact.allowsAddingToAddressBook = YES;
    
    ABRecordRef person = ABPersonCreate();
    ABMutableMultiValueRef multipleNumber = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMutableMultiValueRef multipleEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMutableMultiValueRef allAddresses = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    /*if ([jsonResult objectForKey:@"firstName"]) {
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)[jsonResult objectForKey:@"fistName"], nil);
    }
    if ([jsonResult objectForKey:@"lastName"]) {
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)[jsonResult objectForKey:@"lastName"], nil);
    }
    if ([jsonResult objectForKey:@"organization"]) {
        ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef)[jsonResult objectForKey:@"organization"], nil);
    }
    if ([jsonResult objectForKey:@"jobTitle"]) {
        ABRecordSetValue(person, kABPersonJobTitleProperty, (__bridge CFStringRef)[jsonResult objectForKey:@"jobTitle"], nil);
    }
    if ([jsonResult objectForKey:@"birthday"]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"ddMMyyyy"];
        [format setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDate *birthday = [format dateFromString:[jsonResult objectForKey:@"birthday"]];
        ABRecordSetValue(person, kABPersonBirthdayProperty, (__bridge CFDateRef)birthday, nil);
    }
    if ([jsonResult objectForKey:@"phoneNumber"]) {
        ABMultiValueAddValueAndLabel(multipleNumber, (__bridge CFStringRef)[jsonResult objectForKey:@"phoneNumber"], kABPersonPhoneMainLabel, nil);
    }
    if ([jsonResult objectForKey:@"faxNumber"]) {
        ABMultiValueAddValueAndLabel(multipleNumber, (__bridge CFStringRef)[jsonResult objectForKey:@"faxNumber"], kABPersonPhoneWorkFAXLabel, nil);
    }
    if ([jsonResult objectForKey:@"email"]) {
        ABMutableMultiValueRef multipleEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multipleEmail, (__bridge CFTypeRef)([jsonResult objectForKey:@"email"]), CFSTR("email"), nil);
        ABRecordSetValue(person, kABPersonEmailProperty, multipleEmail, nil);
    }
    if ([jsonResult objectForKey:@"urlImage"]) {
        NSData *imgFile = [NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonResult objectForKey:@"urlImage"]]];
        NSData *contactImage = UIImagePNGRepresentation([UIImage imageWithData:imgFile]);
        ABPersonSetImageData(person, (__bridge CFDataRef)(contactImage), nil);
    }
    if ([jsonResult objectForKey:@"addresses"]) {
        for (NSDictionary *address in [jsonResult objectForKey:@"addresses"]) {
            NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
            [addressDictionary setObject:[address objectForKey:@"street"] forKey:(NSString *)kABPersonAddressStreetKey];
            [addressDictionary setObject:[address objectForKey:@"zip"] forKey:(NSString *)kABPersonAddressZIPKey];
            [addressDictionary setObject:[address objectForKey:@"city"] forKey:(NSString *)kABPersonAddressCityKey];
            ABMultiValueAddValueAndLabel(allAddresses, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, nil);
            ABRecordSetValue(person, kABPersonAddressProperty, allAddresses, nil);
        }
    }
    if ([jsonResult objectForKey:@"notes"]) {
        ABRecordSetValue(person, kABPersonNoteProperty, (__bridge CFTypeRef)[jsonResult objectForKey:@"notes"], nil);
    }*/
    
    ABRecordSetValue(person, kABPersonFirstNameProperty, @"Toto", nil);
    ABRecordSetValue(person, kABPersonLastNameProperty, @"Toto", nil);
    
    // Birthday
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyyy"];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *birthday = [format dateFromString:@"10051989"];
    ABRecordSetValue(person, kABPersonBirthdayProperty, (__bridge CFDateRef)(birthday), nil);
    
    // Email
    ABMultiValueAddValueAndLabel(multipleEmail, @"vsmobile@vision.lu", CFSTR("email"), nil);
    ABRecordSetValue(person, kABPersonEmailProperty, multipleEmail, nil);
    
    // Numbers phone, fax,...
    bool success = ABMultiValueAddValueAndLabel(multipleNumber, @"+352 123456", kABPersonPhoneMainLabel, nil);
    success = ABMultiValueAddValueAndLabel(multipleNumber, @"+352 654321", kABPersonPhoneWorkFAXLabel, nil);
    ABRecordSetValue(person, kABPersonPhoneProperty, multipleNumber, nil);
    
    // Address
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:@"7 rue des merovingiens" forKey:(NSString *)kABPersonAddressStreetKey];
    [addressDictionary setObject:@"L-8070" forKey:(NSString *)kABPersonAddressZIPKey];
    [addressDictionary setObject:@"Bertrange" forKey:(NSString *)kABPersonAddressCityKey];
    ABMultiValueAddValueAndLabel(allAddresses, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, nil);
    ABRecordSetValue(person, kABPersonAddressProperty, allAddresses, nil);
    
    // Image
    NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"BackButtonHome-44.png"]);
    ABPersonSetImageData(person, (__bridge CFDataRef)(imgData), nil);
    
    addContact.displayedPerson = person;

    [controller.navigationController pushViewController:addContact animated:YES];
}

+ (void) calendarClick:(id)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    NSString *result = [controller.Display stringByEvaluatingJavaScriptFromString:@"getAddCalendarData()"];
    NSData *dataResult = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:nil];

    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:store];
    NSDateFormatter *formateDate = [[NSDateFormatter alloc] init];
    [formateDate setDateFormat:@"ddMMyyyyHHmmss"];
    if ([jsonResult objectForKey:@"name"]) {
        //event.title = [jsonResult objectForKey:@"name"];
        event.title = @"My CHD RDV";
    }
    if ([jsonResult objectForKey:@"dateTime"]) {
        //event.startDate = [formateDate dateFromString:[jsonResult objectForKey:@"dateTime"]];
        event.startDate = [NSDate dateWithTimeIntervalSinceNow:999999];
        NSLog(@"Start date : %@", event.startDate);
    }
    if ([jsonResult objectForKey:@"location"]) {
        //event.location = [jsonResult objectForKey:@"location"]];
        event.location = @"23, rue du Marché-aux-Herbes L-1728 Luxembourg";
    }

    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:event.startDate];
    [event addAlarm:alarm];
    
    EKReminder *reminder = [EKReminder reminderWithEventStore:store];
    [reminder setTitle:event.title];
    [reminder setNotes:event.location];
    EKCalendar *defaultReminder = [store defaultCalendarForNewReminders];
    [reminder setCalendar:defaultReminder];
    
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *err) {
        if (!granted) {
            return;
        }
        [event setCalendar:[store defaultCalendarForNewEvents]];
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        //NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
        
        // Alert user that adding is finished
        if(err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *successMsg = [NSString stringWithFormat:@"An error occured during the Saving of the appointment."];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Saving Failure" message:successMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:self waitUntilDone:YES];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *successMsg = [NSString stringWithFormat:@"Your appointment is now added in your calendar to the date %@.", event.startDate];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Successfully Saved" message:successMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:self waitUntilDone:YES];
            });

        }
    }];

}

+ (void) navigateClick:(UIStepper *)sender
{
    DisplayViewController *controller = (DisplayViewController *)[[[sender nextResponder] nextResponder] nextResponder];
    
    if (sender.value > controller.currentDetailsId ) {
        [controller.Display stringByEvaluatingJavaScriptFromString:@"ViewNextDetails()"];
    } else {
        [controller.Display stringByEvaluatingJavaScriptFromString:@"ViewPreviousDetails()"];
    }
    controller.currentDetailsId = sender.value;
}



@end
