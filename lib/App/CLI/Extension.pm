package App::CLI::Extension;

=pod

=head1 NAME

App::CLI::Extension - for App::CLI extension module

=head1 VERSION

0.5

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
use base qw(App::CLI Class::Data::Accessor);
use 5.008;
use UNIVERSAL::require;

our $VERSION    = '0.5';
our @COMPONENTS = qw(
                     FirstSetup
                     Config
                     Stash
                  );

__PACKAGE__->mk_classaccessor( "_config"      => {} );
__PACKAGE__->mk_classaccessor( "_components" );
__PACKAGE__->mk_classaccessor( "_plugins" );

=pod

=head1 METHOD

=cut

sub import {

    my $class = shift;
    my @loaded_components;
    foreach my $component (@COMPONENTS) {
       $component = sprintf "%s::Component::%s", __PACKAGE__, $component;
       $component->require or die "load component error: $UNIVERSAL::require::ERROR";
       $component->import;
       push @loaded_components, $component;
    }
    $class->_components(\@loaded_components);
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
        $cmd->setup;
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
        $plugin->import;
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

=head1 COMPONENT METHOD

=head2 setup

for component and plugin function

=head2 stash

like global variable in Command package

Example:
  
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
  
  1;

=cut

1;

__END__

=head1 SEE ALSO

L<App::CLI> L<Class::Data::Accessor> L<UNIVERSAL::require>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2009 Akira Horimoto

=cut

