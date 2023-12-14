# alfred_api

Generate routes and client code for [Alfred server](https://pub.dev/packages/alfred).

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```bash
mkdir myproject
cd myproject

dart create myproject_server
dart create -t package myproject_client
dart create -t package myproject_models

cd myproject_server
dart pub add alfred alfred_api_annotation
dart pub add --dev alfred_api build_runner

# TODO: define Endpoints

dart run build_runner build -d
```

## Additional information

- [writing package pages](https://dart.dev/guides/libraries/writing-package-pages)

- [Writing an Aggregate Builder](https://github.com/dart-lang/build/blob/master/docs/writing_an_aggregate_builder.md)

- [Using code generation to create a scalable and reliable codebase](https://invertase.io/blog/using-code-generation-to-create-a-scalable-and-reliable-codebase)

- [Why not multi-package builds?](https://github.com/dart-lang/build/issues/2981)

- [Generating files across directories with build_runner (deprecated)](https://www.simonbinder.eu/posts/build_directory_moves/)
