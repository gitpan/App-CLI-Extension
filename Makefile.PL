use inc::Module::Install;
name 'App-CLI-Extension';
author 'Akira Horimoto';
all_from 'lib/App/CLI/Extension.pm';

build_requires 'Test::More';
requires(
      "App::CLI"              => '0.07',
      "Class::Data::Accessor" => 0,
      "UNIVERSAL::require"    => 0,
     );
use_test_base;
auto_include_deps;
author_tests('xt');
auto_set_repository;
WriteAll;
