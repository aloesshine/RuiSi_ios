//
//  ThreadListViewController.m
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadListViewController.h"
#import "Thread.h"
#import "ThreadListCell.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

NSString *kThreadListCell = @"ThreadListCell";

@interface ThreadListViewController ()

@property (nonatomic,strong) NSArray *threads;

@end

@implementation ThreadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = self.name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:kThreadListCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kThreadListCell];
    
    // 解析xml
    [self setUpArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _threads.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreadListCell *cell = [tableView dequeueReusableCellWithIdentifier:kThreadListCell forIndexPath:indexPath];
    
    Thread *thread = _threads[indexPath.row];
    
    cell.titleLabel.text = thread.title;
    cell.authorLabel.text = thread.author;
    cell.reviewCountLabel.text = thread.reviewCount;
    cell.hasPicImageView.image = thread.hasPic == YES ? [UIImage imageNamed:@"icon_tu"] : NULL;
    
    return cell;
}

- (void) setUpArray
{
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:self.url];
    NSString *htmlString = [NSString stringWithContentsOfURL: url encoding:NSUTF8StringEncoding error:&error];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    
    OCGumboNode *element = document.Query(@"body.bg").find(@"div.threadlist").first();
    OCQueryObject *elementArrry = element.Query(@"li");
    NSMutableArray *elements = [[NSMutableArray alloc] init];
    
    for (OCGumboNode *ele in elementArrry)
    {
        // 坑爹的初始化
        Thread *thread = [[Thread alloc] init];
        thread.reviewCount = (NSString *)ele.Query(@"span.num").text();
        thread.titleURL = (NSString *)ele.Query(@"a").first().attr(@"href");
        thread.author = (NSString *)ele.Query(@"a").first().Query(@"span.by").text();
        NSString *title = (NSString *)ele.Query(@"a").text();
        title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        thread.title = [title substringToIndex: title.length - thread.author.length];
        thread.hasPic = ele.Query(@"span.icon_tu").count == 0 ? NO : YES;
        
        [elements addObject:thread];

    }
    
    self.threads = [NSArray arrayWithArray:elements];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
