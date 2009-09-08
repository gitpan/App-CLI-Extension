#!/usr/bin/perl

use strict;
use Test::More tests => 2;
use lib qw(t/lib);
use MyApp;

our $RESULT;
my $result = "banana";

{
    local *ARGV = ["config", "--color=yellow"];
    MyApp->dispatch;
}

ok($result eq $RESULT);

{
    local *ARGV = ["config", "--color=nothing"];
    MyApp->dispatch;
}

ok(!defined($RESULT));

