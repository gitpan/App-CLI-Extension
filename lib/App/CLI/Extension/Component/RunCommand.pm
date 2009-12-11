package App::CLI::Extension::Component::RunCommand;

=pod

=head1 NAME

App::CLI::Extension::Component::RunCommand - for App::CLI::Command run_command override module

=head1 VERSION

1.0

=cut

use strict;
use MRO::Compat;

our @RUNTIME_COMMANDS = qw(setup prerun run postrun finish);
our $VERSION          = '1.0';

sub run_command {

	my($self, @argv) = @_;
	eval { map { $self->$_(@argv) } @RUNTIME_COMMANDS };
	if ($@) {
		chomp(my $message = $@);
		$self->error($message);
		$self->fail(@argv);
	}
}

#######################################
# for run_command method
#######################################

sub setup {

	my($self, @argv) = @_;
	# something to do
	$self->maybe::next::method(@argv);
}

sub prerun {

	my($self, @argv) = @_;
	# something to do
	$self->maybe::next::method(@argv);
}

sub finish {

	my($self, @argv) = @_;
	# something to do
	$self->maybe::next::method(@argv);
}

sub postrun {

	my($self, @argv) = @_;
	# something to do
	$self->maybe::next::method(@argv);
}

sub fail {

	my($self, @argv) = @_;
	die sprintf("default fail method. error:%s. override fail method!!\n", $self->error);
}

1;

__END__

=head1 SEE ALSO

L<App::CLI::Extension> L<MRO::Compat>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2009 Akira Horimoto

=cut

