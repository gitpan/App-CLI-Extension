package App::CLI::Extension::Component::Config;

=pod

=head1 NAME

App::CLI::Extension::Component::Config - for App::CLI::Extension config module

=head1 VERSION

0.3

=cut

use strict;
use base qw(Class::Data::Accessor);

our $VERSION  = '0.3';

__PACKAGE__->mk_classaccessor( _config => {} );

sub config {

    my $self = shift;

    my %hash;
    if(scalar(@_) == 1 && ref($_[0]) eq "HASH"){
        %hash = %{$_[0]}
    } elsif(scalar(@_) > 1) {
        %hash = @_;
    }
    my @keys = keys %hash;
    if (scalar(@keys) > 0) {
        map { $self->_config->{$_} = $hash{$_} } @keys;
    }
    return $self->_config;
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

