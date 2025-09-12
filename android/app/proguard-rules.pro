# Flutter için ProGuard kuralları
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter Play Store Split için
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Firebase için
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Gson için (Firebase kullanıyorsa)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Image Picker için
-keep class androidx.camera.** { *; }
-keep class androidx.camera.core.** { *; }
-keep class androidx.camera.lifecycle.** { *; }
-keep class androidx.camera.view.** { *; }

# Mobile Scanner için
-keep class com.google.mlkit.vision.** { *; }
-keep class com.google.android.gms.vision.** { *; }

# Dio HTTP client için
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# Genel Android kuralları
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Native method'lar için
-keepclasseswithmembernames class * {
    native <methods>;
}

# Serializable sınıflar için
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Enum'lar için
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Reflection kullanılan sınıflar için
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Flutter plugin'leri için genel kural
-keep class io.flutter.plugins.** { *; }
