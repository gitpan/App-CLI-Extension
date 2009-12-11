package MyAppCallback;

use strict;
use base qw(App::CLI::Extension);
use constant alias => (
                callback    => "CallbackTest",
            );

__PACKAGE__->load_plugins(qw(
                         +MyAppCallback::Plugin::Callback
));

1;

