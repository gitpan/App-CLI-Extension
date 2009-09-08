package App::CLI::Extension::Component::Stash;

=pod

=head1 NAME

App::CLI::Extension::Component::Stash - for App::CLI::Extension stash module

=head1 VERSION

0.1

=head1 SYNOPSIS

  # MyApp/Hello.pm
  package MyApp::Hello;
  use strict;
  use feature ":5.10.0";
  use base qw(App::CLI::Command);
     
  sub run {
  
      my($self, @args) = @_;
      $self->stash->{name} = "kurt";
      say "stash value: " . $self->stash->{name};
  }
  
  # myapp
  #!/usr/bin/perl
  
  use strict;
  use MyApp;
  
  MyApp->dispatch;
  
  # execute
  [kurt@localhost ~] ./myapp hello
  stash value: kurt

=head1 DESCRIPTION

App::CLI::Extension stash like global variable in Command package
  
=cut

use strict;

our $PACKAGE  = __PACKAGE__;
our $VERSION  = '0.1';

=pod

=head1 METHOD

=head2 stash

=cut
sub stash {

    my $self = shift;

    $self->{$PACKAGE} = {} if !exists $self->{$PACKAGE};

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

Copyright (C) 2009 Akira Horimoto

=cut

