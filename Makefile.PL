use inc::Module::Install;
name 'App-CLI-Extension';
author 'Akira Horimoto';
all_from 'lib/App/CLI/Extension.pm';

build_requires 'Test::More';
requires(
      "App::CLI"                  => '0.07',
      "Class::Data::Inheritable"  => 0,
      "Hash::Merge"               => 0,
      "Module::Pluggable::Object" => 0,
      "UNIVERSAL::require"        => 0,
     );
use_test_base;
auto_include_deps;
WriteAll;
