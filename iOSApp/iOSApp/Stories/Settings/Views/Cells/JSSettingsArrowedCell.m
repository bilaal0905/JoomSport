// Created for BearDev by drif
// drif@mail.ru

#import "JSSettingsArrowedCell.h"

@implementation JSSettingsArrowedCell

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleGray;

        {
            UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.actionView addSubview:view];

            [self.actionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        }
    }
    return self;
}

@end
