# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Play Core library (used by Flutter for deferred components)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Device Calendar plugin
-keep class com.builttoroam.** { *; }
-keep class android.content.ContentResolver { *; }
-keep class android.provider.CalendarContract { *; }
-keep class android.provider.CalendarContract$* { *; }

# WorkManager (background sync)
-keep class androidx.work.** { *; }

# Local Auth (biometric)
-keep class androidx.biometric.** { *; }

# Gson / JSON serialization
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
