package App::CLI::Extension::Component::Config;

=pod

=head1 NAME

App::CLI::Extension::Component::Config - for App::CLI::Extension config module

=head1 VERSION

0.01

=cut

use strict;
use Hash::Merge qw(merge);

our $PACKAGE  = __PACKAGE__;
our $VERSION  = 0.01;

sub config {

    my $self = shift;

    $self->{$PACKAGE} = {} if !exists $self->{$PACKAGE};

    my %hash;
    if(scalar(@_) == 1 && ref($_[0]) eq "HASH"){
        %hash = %{$_[0]}
    } elsif(scalar(@_) > 1) {
        %hash = @_;
    }

    $self->{$PACKAGE} = merge($self->{$PACKAGE}, \%hash) if keys %hash;

    return $self->{$PACKAGE};
}

1;

__END__

=head1 SEE ALSO

L<App::CLI::Extension> L<Hash::Merge>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2008 Akira Horimoto

=cut

