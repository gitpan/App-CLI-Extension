package MyApp;

use strict;
use base qw(App::CLI::Extension);
use constant alias => (
                plugin => "PluginTest",
                config => "ConfigTest",
                stash  => "StashTest"
            );

__PACKAGE__->load_plugins(qw(+MyApp::Plugin::Greeting));
__PACKAGE__->config(yellow => "banana");

1;

