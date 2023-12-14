import 'package:build/build.dart';

import 'builders/alfred_api_builder.dart';

Builder generateApi(BuilderOptions options) => AlfredApiBuilder(options);
