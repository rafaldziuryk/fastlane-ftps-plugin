# ftps plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-ftp)
[![Build Status](https://travis-ci.org/PoissonBallon/fastlane-ftp-plugin.svg?branch=master)](https://travis-ci.org/PoissonBallon/fastlane-ftp-plugin)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-ftps`, add it to your project by running:

```bash
fastlane add_plugin ftps
```

## About ftp

Simple FTPS plugins for Fastlane

Support Download and Upload

## Example

### Upload :

```ruby
  ftp(
    host: 'ftp.domain.com',
    username: 'my_name',
    password: 'my_password',
    upload: {
      src: "./localFile",
      dest:"/server/path/"
    },
    options: {
     ssl: true,
     port: ENV["FTP_PORT"],
   }
    )
```

### Download

```ruby
  ftp(
    host: 'ftp.domain.com',
    username: 'my_name',
    password: 'my_password',
    download: {
      src: "/distant/server/path/file.md",
      dest:"/localPath/file.md"
    }
    ,
    options: {
     ssl: true,
     port: ENV["FTP_PORT"],
   }
    )
```

## Run tests for this plugin

To run both the tests, and code style validation, run

````
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate building and releasing your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
