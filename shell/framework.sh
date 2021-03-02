#!/bin/bash
set -e

echo 'Will Select /Applications/Xcode.app/Contents/Developer'
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcode-select -p

# 获取工程的Example目录
function getExampleFolder () {
  currentTemp="$(pwd)"
  if [[ -f ${currentTemp}/Podfile ]]; then
    echo $currentTemp
  else
    if [[ -f ${currentTemp}/Example/Podfile  ]]; then
      echo $currentTemp/Example
    else
      if [[ -f $(dirname $currentTemp)/Example/Podfile ]]; then
        echo $(dirname $currentTemp)/Example
      else
        echo "找不到Example目录,请在项目工程中执行该命令"
        exit 0
      fi
    fi
  fi
}

currentFold=$(getExampleFolder)                      # 当前执行的目录
echo "当前执行目录: "$currentFold
fatherFold=$(dirname $currentFold)                   # 父目录
build=${fatherFold}/build

rm -rf $build
# rm -rf ../Example/Pods
# rm ../Example/Podfile.lock
mkdir $build

cd ${fatherFold}/Example
rm -rf Pods/

pwd
pod install

# pod install
#获取scheme名字
workspace=`ls | grep *.xcworkspace`
# Release
workspacePath=$fatherFold/Example/$workspace   #工程文件目录
scheme=${workspace%.*}
frameworkName=$scheme
configuration="Release"

# Builds xcframework from iOS framework template project called TestFramework

# Archive for iOS
# xcodebuild archive \
#   -workspace $workspace \
#   -scheme $scheme \
#   -destination="iOS" \
#   -archivePath $build/xcf/ios.xcarchive \
#   -derivedDataPath $build/iphoneos \
#   -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES BITCODE_GENERATION_MODE=bitcode THER_CFLAGS="-fembed-bitcode" | xcpretty
# echo "************************************************************ archive iphoneos success"

# # Archive for simulator
# xcodebuild archive \
#   -workspace $workspace \
#   -scheme $scheme -destination="iOS Simulator" \
#   -archivePath $build/xcf/iossimulator.xcarchive \
#   -derivedDataPath $build/iphoneos \
#   -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES BITCODE_GENERATION_MODE=bitcode THER_CFLAGS="-fembed-bitcode" | xcpretty
# echo "************************************************************ archive iphonesimulator success"

# # Build xcframework with two archives
# xcodebuild -create-xcframework \
#   -framework $build/xcf/ios.xcarchive/Products/Library/Frameworks/$frameworkName.framework \
#   -framework $build/xcf/iossimulator.xcarchive/Products/Library/Frameworks/$frameworkName.framework \
#   -output $build/xcf/$frameworkName.xcframework | xcpretty
# echo "************************************************************ Build xcframework with two archivess"

# cp -r $build/xcf/$frameworkName.xcframework  $build/$frameworkName.xcframework 

# xcodebuild打包

xcodebuild \
   -workspace $workspacePath \
   -scheme ${scheme} \
   -configuration ${configuration} \
   -sdk iphonesimulator \
   -arch i386 \
   BITCODE_GENERATION_MODE=bitcode \
   OTHER_CFLAGS="-fembed-bitcode" \
   BUILD_DIR=$build/i386 \
   BUILD_ROOT=$build clean build | xcpretty
echo "************************************************************ Build iphonesimulator i386 success"

xcodebuild \
   -workspace $workspacePath \
   -scheme ${scheme} \
   -configuration ${configuration} \
   -sdk iphonesimulator \
   -arch x86_64 \
   BITCODE_GENERATION_MODE=bitcode \
   OTHER_CFLAGS="-fembed-bitcode" \
   BUILD_DIR=$build/x86_64 \
   BUILD_ROOT=$build clean build | xcpretty
echo "************************************************************ Build iphonesimulator x86_64 success"

xcodebuild \
  -workspace $workspacePath \
  -scheme ${scheme} \
  -configuration ${configuration} \
  -sdk iphoneos \
  BITCODE_GENERATION_MODE=bitcode \
  OTHER_CFLAGS="-fembed-bitcode" \
  BUILD_DIR=$build \
  BUILD_ROOT=$build clean build | xcpretty
echo "************************************************************ Build iphoneos success"

cp -rf ${build}/${configuration}-iphoneos/${frameworkName}/${frameworkName}.framework ${build}/${frameworkName}.framework
i386SwiftmodulePath=${build}/i386/${configuration}-iphonesimulator/${frameworkName}/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule
if [ -d ${i386SwiftmodulePath} ];then
 cp -rf ${build}/i386/${configuration}-iphonesimulator/${frameworkName}/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule/* ${build}/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule/
fi
x86_64SwiftmodulePath=${build}/x86_64/${configuration}-iphonesimulator/${frameworkName}/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule
if [ -d ${x86_64SwiftmodulePath} ];then
 cp -rf ${build}/x86_64/${configuration}-iphonesimulator/${frameworkName}/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule/* ${build}/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule/
fi

lipo -create  "${build}/i386/${configuration}-iphonesimulator/${frameworkName}/${frameworkName}.framework/${frameworkName}" \
              "${build}/x86_64/${configuration}-iphonesimulator/${frameworkName}/${frameworkName}.framework/${frameworkName}" \
              "${build}/${configuration}-iphoneos/${frameworkName}/${frameworkName}.framework/${frameworkName}" \
              -output "${build}/${frameworkName}"

cp -rf ${build}/${frameworkName} ${build}/${frameworkName}.framework/${frameworkName}

lipo -info ${build}/${frameworkName}.framework/${frameworkName}
echo "************************************************************ Create framework success"

#rm -rf ${build}/${configuration}-iphonesimulator
#rm -rf ${build}/${configuration}-iphoneos
#rm -rf ${build}/
