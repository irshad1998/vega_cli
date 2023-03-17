var launchJsonData = '''
  {
    "version": "0.2.0",
    "configurations": [
      {
        "name": "Flutter: Attach to Device",
        "type": "dart",
        "request": "attach"
      },
      {
        "name": "dev",
        "request": "launch",
        "type": "dart",
        "args": [
          "-t",
          "lib/main_develop.dart",
          "--flavor",
          "dev"
        ]
      },
      {
        "name": "stage",
        "request": "launch",
        "type": "dart",
        "args": [
          "-t",
          "lib/main_staging.dart",
          "--flavor",
          "stage"
        ]
      },
      {
        "name": "production",
        "request": "launch",
        "type": "dart",
        "args": [
          "-t",
          "lib/main.dart",
          "--flavor",
          "prod"
        ]
      }
    ]
  }
  
''';
