package App::CLI::Extension::Component::ErrorHandler;

=pod

=head1 NAME

App::CLI::Extension::Component::Error - for App::CLI::Extension error module

=head1 VERSION

1.0

=cut

use strict;
use base qw(Class::Data::Accessor);

our $VERSION  = '1.0';

__PACKAGE__->mk_classaccessor( "error" );

sub is_error {

	my $self = shift;
	return defined $self->error ? 1 : 0;
}

1;

__END__

=head1 SEE ALSO

L<App::CLI::Extension> L<Class::Data::Accessor>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2009 Akira Horimoto

=cut

