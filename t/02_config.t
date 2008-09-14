#!/usr/bin/perl

use strict;
use Test::More tests => 2;
use lib qw(t/lib);
use MyCLI;

our $RESULT;
my $result = "banana";

{
    local *ARGV = ["config", "--color=yellow"];
    MyCLI->dispatch;
}

ok($result eq $RESULT);

{
    local *ARGV = ["config", "--color=nothing"];
    MyCLI->dispatch;
}

ok(!defined($RESULT));

