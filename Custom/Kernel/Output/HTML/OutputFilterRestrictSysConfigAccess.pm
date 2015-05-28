# --
# Kernel/Output/HTML/OutputFilterRestrictSysConfigAccess.pm
# Copyright (C)  2015 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterRestrictSysConfigAccess;

use strict;
use warnings;

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Web::Request
    Kernel::Output::HTML::Layout
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Action   = $ParamObject->GetParam( Param => 'Action' );
    my $Group    = $ParamObject->GetParam( Param => 'SysConfigGroup' );
    my $Subgroup = $ParamObject->GetParam( Param => 'SysConfigSubGroup' );

    return 1 if !$Action || $Action ne 'AdminSysConfig';

    my $Rules    = $ConfigObject->Get('RestrictSysConfig::Rules') || [];

    my (@GroupRules) = grep{ $_->{Group} eq $Group }@{$Rules};

    return 1 if !@GroupRules;

    my (@FoundRules) = grep{ $_->{SubGroup} eq $Subgroup }@GroupRules;

    return 1 if !@FoundRules;

    my $Output;
    $Output = $LayoutObject->Header( Title => 'Insufficient Rights' );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'NoPermission',
        Data         => {
            Message => 'No Permission',
        },
    );
    $Output .= $LayoutObject->Footer();

    ${ $Param{Data} } = $Output;        

    return ${ $Param{Data} };
}

1;
