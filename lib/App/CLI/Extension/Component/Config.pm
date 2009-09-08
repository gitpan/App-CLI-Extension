package App::CLI::Extension::Component::Config;

=pod

=head1 NAME

App::CLI::Extension::Component::Config - for App::CLI::Extension config module

=head1 VERSION

0.1

=cut

use strict;

our $PACKAGE  = __PACKAGE__;
our $VERSION  = '0.1';

sub config {

    my $self = shift;

    $self->{$PACKAGE} = {} if !exists $self->{$PACKAGE};

    my %hash;
    if(scalar(@_) == 1 && ref($_[0]) eq "HASH"){
        %hash = %{$_[0]}
    } elsif(scalar(@_) > 1) {
        %hash = @_;
    }

    my @keys = keys %hash;
    if (scalar(@keys) > 0) {
        map { $self->{$PACKAGE}->{$_} = $hash{$_} } @keys;
    }

    return $self->{$PACKAGE};
}

1;

__END__

=head1 SEE ALSO

L<App::CLI::Extension>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2008 Akira Horimoto

=cut

