package MyCLI;

use strict;
use base qw(App::CLI::Extension);
use constant alias => (plugin => "PluginTest", config => "ConfigTest");

__PACKAGE__->load_plugins(qw(+MyCLI::Plugin::Greeting));
__PACKAGE__->config(yellow => "banana");

1;

