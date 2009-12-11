package MyAppFail;

use strict;
use base qw(App::CLI::Extension);
use constant alias => (
                fail      => "FailTest",
            );

__PACKAGE__->load_plugins(qw(
                         +MyAppFail::Plugin::Fail
));

1;

