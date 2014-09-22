//
//  ServicesManager.m
//  VsMobile_FullWeb_OneWebview
//
//  Created by admin on 9/3/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ServicesManager.h"
#import "AppDelegate.h"

@interface ServicesManager ()

@end

@implementation ServicesManager

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appMenu = [[NSMutableArray alloc] init];
    if (APPLICATION_FILE != Nil) {
        self.nbMenuItem = 0;
        for (NSMutableDictionary *page in [APPLICATION_FILE objectForKey:@"Pages"]) {
            if (![[page objectForKey:@"TemplateType"] isEqualToString:@"Menu"]) {
                self.appMenu[self.nbMenuItem] = page;
                self.nbMenuItem++;
                NSIndexPath *indexPathTable = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPathTable] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        NSLog(@"Dico : %lu, Nb d'item dans le menu : %d", (unsigned long)self.appMenu.count, self.nbMenuItem);
        self.navigationItem.title = @"Mes services";
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    int nbSwitchOn = 0;
    int nbSwitchOff = 0;
    for (UITableViewCellWithSwitch *cell in self.tableView.visibleCells) {
        
        if (cell.status.hidden) {
            [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:2] forKey:cell.title.text]];
        } else {
            if (cell.status.isOn) {
                nbSwitchOn++;
                [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:0] forKey:cell.title.text]];
            } else {
                nbSwitchOff++;
                [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:cell.title.text]];
            }
        }
    }
    NSLog(@"Nb Cells = 7. On = %d, Off = %d", nbSwitchOn, nbSwitchOff);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.appMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellWithSwitch *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    self.itemMenu = self.appMenu[indexPath.row];
    
    if ([[self.itemMenu objectForKey:@"Title"] isKindOfClass:[NSNull class]]) {
        cell.title.text = @"Sans titre";
    } else {
        cell.title.text = [[self.itemMenu objectForKey:@"Title"] description];
    }
    
    switch ([AppDelegate serviceStatusFor:cell.title.text]) {
        case CellStyleBlocked:
        {
            [cell.status setHidden:YES];
            [cell.imgView setHidden:NO];
        }
            break;
        case CellstyleIsOff:
        {
            [cell.status setOn:NO];
            [cell.status setHidden:YES];
            [cell.imgView setHidden:NO];
        }
            break;
        case CellStyleIsOn:
        {
            [cell.status setOn:YES];
            [cell.status setHidden:YES];
            [cell.imgView setHidden:NO];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width - 5, 30)];
    sectionHeaderLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    sectionHeaderLabel.textColor = [UIColor grayColor];
    sectionHeaderLabel.numberOfLines = 2;
    sectionHeaderLabel.text = @"Choisissez les services à afficher et à synchroniser";
    [sectionHeaderView addSubview:sectionHeaderLabel];
    
    return sectionHeaderView;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
