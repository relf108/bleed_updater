#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';

/// dcli script generated by:
/// dcli create bleed.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main(List<String> args) {
  var flag = '';
  if (args.isNotEmpty) {
    flag = args[0].toString();
  }
  try {
    echo(green('Bleeding Flatpaks \n'));
    'flatpak update -y'.start();
    'flatpak upgrade -y'.start();
    echo(green('Bleeding Debs \n'));
    'apt update -y'.start(privileged: true);
    'apt upgrade -y --allow-downgrades'.start(privileged: true);
    if (flag == '-d' || flag == '--dist') {
      var distro = read('/etc/os-release')
          .firstLine
          .toString()
          .split('\"')[1]
          .replaceAll('\"', '');
      echo(green('Upgrading $distro \n'));
      'apt dist-upgrade -y --allow-downgrades'.start(privileged: true);
    }
    'apt autoremove -y'.start(privileged: true);
  } on Exception catch (e) {
    echo(red('Bleeding failed with error: \n $e'));
    exit(1);
  }
  echo(green('Bleeding complete'));
  exit(0);
}
