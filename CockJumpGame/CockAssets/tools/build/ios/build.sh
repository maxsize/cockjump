#user_configuration

# Path to Flex SDK
FLEX_SDK="/Users/Nicole/git/CockJumpGame/CockAssets/tools/AIRSDK"
ADT=$FLEX_SDK/bin/adt
AMXMLC=$FLEX_SDK/bin/amxmlc

#user_configuration

# About AIR application packaging
# http://livedocs.adobe.com/flex/3/html/help.html?content=CommandLineTools_5.html#1035959
# http://livedocs.adobe.com/flex/3/html/distributing_apps_4.html#1037515

# NOTICE: all paths are relative to project root

# root
ROOT="/Users/Nicole/git/CockJumpGame"
GAME_ROOT="$ROOT/CockJump"

# Your certificate information
CERT_NAME="Cert iOS"
CERT_PASS="1234"
CERT_FILE="$GAME_ROOT/cert/FakeCert.p12"
PROV_FILE="$GAME_ROOT/cert/Fake.mobileprovision"
#set SIGNING_OPTIONS=-storetype pkcs12 -keystore %CERT_FILE% -storepass %CERT_PASS%
SIGNING_OPTIONS="-storetype pkcs12 -keystore $CERT_FILE -provisioning-profile $PROV_FILE -storepass $CERT_PASS"

# Application descriptor
APP_XML="$GAME_ROOT/src/CockJump-app.xml"

# Files to package
APP_DIR="$GAME_ROOT/bin"

FILE_OR_DIR="-C $APP_DIR ."

# Your application ID (must match <id> of Application descriptor)
APP_ID="com.gamevil.zenonia2"

# Output
AIR_PATH="$GAME_ROOT/release"
AIR_NAME="CockJump.ipa"
OUTPUT=/Users/Nicole/git/CockJumpGame/CockRelease/mobile/ios/$AIR_NAME
SWF=$GAME_ROOT/

#library
COMMON_LIB=$ROOT/GameCommon/bin/GameCommon.swc

# application
APP=$GAME_ROOT/src/CockJump.as

# Package
#echo Packaging $OUTPUT using certificate $CERT_FILE...


#copying config files
#call copy .\*.json .\%APP_DIR%
#call xcopy .\src\icons .\%APP_DIR%\icons\
$AMXMLC –library-path=$COMMON_LIB
#$AMXMLC $GAME_ROOT/src/CockJump.as

#$ADT -package -target ipa-app-store $SIGNING_OPTIONS $OUTPUT $APP_XML
