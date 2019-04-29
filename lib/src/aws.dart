import './core/config.dart';

import 's3.dart';

abstract class AWS {
  static Config globalConfig;
  
  Config config;

  AWS([config]) {
    this.config = config ?? Config.from(globalConfig);
  }

  factory AWS.S3([config]) => S3(config);
}

