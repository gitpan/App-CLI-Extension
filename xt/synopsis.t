use Test::More;
use lib qw(t/lib);
eval "use Test::Synopsis";
plan skip_all => "Test::Synopsis required" if $@;
all_synopsis_ok();
