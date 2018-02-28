//
//  AllDonorsViewController.m
//  BloodDonation
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "AllDonorsViewController.h"
#import "DonorTableViewCell.h"

@interface AllDonorsViewController ()

@end

@implementation AllDonorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_table_donors setTableFooterView:[UIView new]];
    
    arr_filters = [[NSArray alloc] initWithObjects:@"Name", @"Blood Group", nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO];
    self.navigationController.navigationBar.topItem.title = @"All Donors";
    self.navigationController.navigationBar.topItem.hidesBackButton = YES;
    
//    UIBarButtonItem *rightBarButton = [self.navigationItem rightBarButtonItem];
//    [rightBarButton setTarget:self];
//    [rightBarButton setAction:@selector(showMap:)];
//    
//    [self.navigationController.navigationBar.topItem setRightBarButtonItem:rightBarButton];
    
}



-(void)showMap:(id)sender{
    
    [self performSegueWithIdentifier:@"showMap" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DonorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
