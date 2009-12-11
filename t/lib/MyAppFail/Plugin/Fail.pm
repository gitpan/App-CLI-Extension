package MyAppFail::Plugin::Fail;

use strict;

sub fail {

    my($self, @argv) = @_;
    $main::RESULT = $self->error; 
#    $self->maybe::next::method(@argv);
}

1;
