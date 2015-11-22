//
//  EventsVC.m
//  MobileNight
//

#import "EventsVC.h"
#import "EventCell.h"
#import "KxMenu.h"
#import "LoginVC.h"
#import "ViewController.h"
#import "RFSegmentView.h"
#import "EventDetailVC.h"
#import "Event.h"

@interface EventsVC () <UISearchBarDelegate>

@end

@implementation EventsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [tblEvents registerNib:[UINib nibWithNibName:@"EventCell" bundle:nil] forCellReuseIdentifier:@"EventCell1"];
}
-(void) viewWillAppear:(BOOL)animated {
    arrEvents = [[NSArray alloc]init];
    
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        [kAPP_DELEGATE ShowLoader];
        
        [APIClient getEventsByType:@"ALL" with:^(NSDictionary *response, NSError *error) {
            
            [kAPP_DELEGATE stopLoader];
            if (error == nil) {
                
                arrEvents = [Event getEvents:response];
                [tblEvents reloadData];
            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
    
//    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
//    [txfSearchField setBackgroundColor:[UIColor colorWithRed:212 green:211 blue:214 alpha:1]];
    
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    UIImageView *search = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    search.image = [UIImage imageNamed:@"search-icon.png"];
    [txfSearchField addSubview:search];
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    //txfSearchField.layer.borderWidth = 8.0f;
    //txfSearchField.layer.cornerRadius = 10.0f;
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    txfSearchField.clearButtonMode=UITextFieldViewModeNever;
    [self btnSegmentClicked:self.segmtAll];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    // Do any additional setup after loading the view.
    //arrEvents = [NSArray array];
    //arrEvents = @[@"DJ NIKKY",@"DJ BUDDY",@"DJ NIKKY",@"DJ BUDDY"];
    
}


//
- (NSString *)tabTitle
{
    return @"Events";
}

- (NSString *)tabImageName
{
    return @"event-icon.png";
}

- (NSString *)activeTabImageName
{
    return @"event-icon.png";
}
//

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrEvents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell1"];
    Event *event = [arrEvents objectAtIndex:indexPath.row];
    [cell configureCell:event with:indexPath];
    
    if (indexPath.row % 2  == 0) {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    } else {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:100]];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //EventDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailVC"];
    EventDetailVC *vc = [[EventDetailVC alloc]initWithNibName:@"EventDetailVC" bundle:nil];
    vc.EventDetail = [arrEvents objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
     
    NSLog(@"Selected Event: %@",[[arrEvents objectAtIndex:indexPath.row] valueForKey:@"eventName"]);
    
}

- (IBAction)btnSegmentClicked:(UIButton *)sender {
    [self setSegmentsColors];
    
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    switch (sender.tag) {
        case 1: {
            [self.segmtDJ setBackgroundImage:[UIImage imageNamed:@"tab1-ho.png"] forState:UIControlStateNormal];
            break;
        }
        case 2: {
            [self.segmtKaroke setBackgroundImage:[UIImage imageNamed:@"tab2-ho.png"] forState:UIControlStateNormal];
            break;
        }
        case 3: {
            [self.segmtComedy setBackgroundImage:[UIImage imageNamed:@"tab3-ho.png"] forState:UIControlStateNormal];
            break;
        }
        case 4: {
            [self.segmtAll setBackgroundImage:[UIImage imageNamed:@"tab4-ho.png"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}
- (void)setSegmentsColors {
    UIColor *backColor = [UIColor clearColor];
    UIColor *textColor = [UIColor whiteColor];
    
    [self.segmtDJ setBackgroundColor:backColor];
    [self.segmtDJ setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.segmtKaroke setBackgroundColor:backColor];
    [self.segmtKaroke setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.segmtComedy setBackgroundColor:backColor];
    [self.segmtComedy setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.segmtAll setBackgroundColor:backColor];
    [self.segmtAll setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.segmtDJ setBackgroundImage:[UIImage imageNamed:@"tab1.png"] forState:UIControlStateNormal];
    [self.segmtKaroke setBackgroundImage:[UIImage imageNamed:@"tab2.png"] forState:UIControlStateNormal];
    [self.segmtComedy setBackgroundImage:[UIImage imageNamed:@"tab3.png"] forState:UIControlStateNormal];
    [self.segmtAll setBackgroundImage:[UIImage imageNamed:@"tab4.png"] forState:UIControlStateNormal];


}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addGestureRecognizer:tapGesture];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.view removeGestureRecognizer:tapGesture];
}
- (void)handleTap:(UIGestureRecognizer *)gesutre {
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:gesutre];
}
@end
