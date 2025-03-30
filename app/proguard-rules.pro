# Allow access modification
-allowaccessmodification

# Ignore warnings
-dontwarn **

# Don't keep any classes or members
# -dontkeepattributes *Annotation*
-dontwarn *
-dontnote *

# Obfuscation settings
-obfuscationdictionary proguard-android-optimize.txt
-classobfuscationdictionary proguard-android-optimize.txt
-packageobfuscationdictionary proguard-android-optimize.txt

# Keep nothing, obfuscate all
-dontnote
-dontwarn
# -dontkeepattributes *
