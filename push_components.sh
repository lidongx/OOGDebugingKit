#!/bin/bash

pod cache clean --all

filepath=$(cd "$(dirname "$0")"; pwd)

cd "$filepath"   #解决文件夹存在空格引起的问题


pod repo push Specs OOGDebugingKit.podspec --allow-warnings 