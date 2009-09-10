package App::CLI::Extension;

=pod

=head1 NAME

App::CLI::Extension - for App::CLI extension module

=head1 VERSION

0.2

=head1 SYNOPSIS

  # MyApp.pm
  package MyApp;

  use strict;
  use base qw(App::CLI::Extension);

  # extension method
  # load App::CLI::Plugin::Foo,  MyApp::Plugin::Bar
  __PACKAGE__->load_plugins(qw(Foo +MyApp::Plugin::Bar));
  
  # extension method
  __PACKAGE__->config( name => "kurt");
  
  1;

  # MyApp/Hello.pm
  package MyApp::Hello;

  use strict;
  use base qw(App::CLI::Command);
  use constant options => ("age=i" => "age");

  sub run {

      my($self, @args) = @_;
      # config - App::CLI::Extension extension method(App::CLI::Extension::Component::Config)
      print "Hello! my name is " . $self->config->{name} . "\n";
      print "age is " . "$self->{age}\n";
  }

  # myapp
  #!/usr/bin/perl

  use strict;
  use MyApp;

  MyApp->dispatch;

  # execute
  [kurt@localhost ~] myapp hello --age=27
  Hello! my name is kurt
  age is 27

=head1 DESCRIPTION

The expansion module which added plug in, initial setting mechanism to App::CLI

App::CLI::Extension::Component::* modules is automatic, and it is done require

(It is now Config and Stash is automatic, and it is done require)

=cut

use strict;
use base qw(App::CLI Class::Data::Inheritable);
use 5.008;
use Module::Pluggable::Object;
use UNIVERSAL::require;

our $VERSION = '0.2';

__PACKAGE__->mk_classdata("_plugins" => []);
__PACKAGE__->mk_classdata("_config"  => {});
__PACKAGE__->mk_classdata("_components");

=pod

=head1 METHOD

=cut

sub import {

    my $class = shift;
    my $finder = Module::Pluggable::Object->new(search_path => __PACKAGE__ . "::Component", require => 1);
    $class->_components([$finder->plugins]);
}

sub prepare {

    my $class = shift;
    my $cmd = $class->SUPER::prepare(@_);
    {
        no strict "refs"; ## no critic
        my $pkg = ref($cmd);

        # component and plugin setup
        push @{"$pkg\::ISA"}, @{$class->_components}, @{$class->_plugins};
        $cmd->config($class->_config);
        $cmd->setup if $cmd->can("setup");
    }
    return $cmd;
}

=pod

=head2 load_plugins

auto load and require plugin modules

Example

  # MyApp.pm
  # MyApp::Plugin::GoodMorning and App::CLI::Plugin::Config::YAML::Syck require
  __PACKAGE__->load_plugins(qw(+MyApp::Plugin::GoodMorning Config::YAML::Syck));
  
  # MyApp/Plugin/GoodMorning.pm
  package MyApp::Plugin::GoodMorning;

  use strict;
  
  sub good_morning {

      my $self = shift;
      print "Good monring!\n";
  }

  # MyApp/Hello.pm
  package MyApp::Hello;

  use strict;
  use base qw(App::CLI::Command);

  sub run {

      my($self, @args) = @_;
      $self->good_morning;
  }

  # myapp
  #!/usr/bin/perl

  use strict;
  use MyApp;

  MyApp->dispatch;

  # execute
  [kurt@localhost ~] myapp hello
  Good morning!

=cut

sub load_plugins {

    my($class, @load_plugins) = @_;

    my @loaded_plugins;
    foreach my $plugin(@load_plugins){

        if($plugin =~ /^\+/){
            $plugin =~ s/^\+//;
        }else{
            $plugin = "App::CLI::Plugin::$plugin";
        }
        $plugin->require or die "plugin load error: $UNIVERSAL::require::ERROR";
        push @loaded_plugins, $plugin;
    }

    $class->_plugins(\@loaded_plugins);
}

=pod

=head2 config

configuration method

Example

  # MyApp.pm
  __PACKAGE__->config(
                 name           => "kurt",
                 favorite_group => "nirvana",
                 favorite_song  => ["Lounge Act", "Negative Creep", "Radio Friendly Unit Shifter", "You Know You're Right"]
              );
  
  # MyApp/Hello.pm
  package MyApp::Hello;

  use strict;
  use base qw(App::CLI::Command);

  sub run {

      my($self, @args) = @_;
      print "My name is " . $self->config->{name} . "\n";
      print "My favorite group is " . $self->config->{favorite_group} . "\n";
      print "My favorite song is " . join(",", @{$self->config->{favorite_song}});
      print " and Smells Like Teen Spirit\n"
  }

  # myapp
  #!/usr/bin/perl

  use strict;
  use MyApp;

  MyApp->dispatch;

  # execute
  [kurt@localhost ~] myapp hello
  My name is kurt
  My favorite group is nirvana
  My favorite song is Lounge Act,Negative Creep,Radio Friendly Unit Shifter,You Know You're Right and Smells Like Teen Spirit

=cut


sub config {

    my($class, %config) = @_;
    $class->_config(\%config);
    return $class->_config;
}

1;

__END__

=head1 SEE ALSO

L<App::CLI> L<App::CLI::Extension::Component::Config> L<App::CLI::Extension::Component::Stash> L<Class::Data::Inheritable> L<Module::Pluggable::Object> L<UNIVERSAL::require>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2009 Akira Horimoto

=cut

