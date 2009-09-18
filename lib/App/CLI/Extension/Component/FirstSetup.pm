package App::CLI::Extension::Component::FirstSetup;

=pod

=head1 NAME

App::CLI::Extension::Component::Accessor - for App::CLI::Extension config module

=head1 VERSION

0.3

=cut

use strict;
use NEXT;

our $VERSION  = '0.3';

sub setup {

    my $self = shift;

    return $self->NEXT::setup;
}

1;

__END__

=head1 SEE ALSO

L<App::CLI::Extension> L<NEXT>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2009 Akira Horimoto

=cut

