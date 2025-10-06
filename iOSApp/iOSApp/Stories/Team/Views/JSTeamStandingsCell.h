// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

extern CGFloat const JSTeamStandingsCellHeight;

@interface JSTeamStandingsCell : UITableViewCell

- (void)setup:(NSArray *)titles with:(NSArray *)values forWidth:(CGFloat)width;

@end
