# VERSION:1.1
package Kernel::Config::Files::ZZZRestrictSysConfigAccess;

use strict;
use warnings;
no warnings 'redefine';
use utf8;

sub Load {
    my ($File, $Self) = @_;

    $Self->{'Frontend::Output::FilterContent'}->{OutputFilterRestrictSysConfigAccess} = {
        Module    => 'Kernel::Output::HTML::OutputFilterRestrictSysConfigAccess',
        Debug     => 0,
        Templates => {
            AdminSysConfig => 1,
        },
    };

#    $Self->{'RestrictSysConfig::Rules'} = [
#        {
#            Group    => '',
#            SubGroup => ''
#        },
#    ];
}

1;
