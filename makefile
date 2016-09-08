RELEASE_DIR=build/Release-universal

staticlib:
	rm -rf $(RELEASE_DIR)
	xcodebuild clean build ARCHS="armv7 arm64" -sdk iphoneos -configuration Release
	xcodebuild clean build ARCHS="i386 x86_64" -sdk iphonesimulator -configuration Release
	mkdir $(RELEASE_DIR)
	cp -av build/Release-iphoneos/traceme.framework build/Release-universal/
	lipo -create build/Release-iphone*/traceme.framework/traceme \
		 -output build/Release-universal/traceme.framework/traceme
