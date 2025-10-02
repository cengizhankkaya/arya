import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.cngz.arya"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
    
    kotlin {
        jvmToolchain(17)
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.cngz.arya"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Image cropper için gerekli
        vectorDrawables.useSupportLibrary = true
        
        // Sadece gerekli CPU mimarilerini dahil et (app boyutunu küçültür)
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a")
        }

        // Yalnızca kullanılan yerel dilleri paketle (APK boyutunu küçültür)
        resConfigs("en", "tr")
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file("${it as String}") }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Debug symbols için
            ndk {
                debugSymbolLevel = "SYMBOL_TABLE"
            }
        }
    }

    // App Bundle optimizasyonları
    bundle {
        language {
            // Dil paketlerini ayrı modüller olarak paketle
            enableSplit = true
        }
        density {
            // Yoğunluk paketlerini ayrı modüller olarak paketle
            enableSplit = true
        }
        abi {
            // CPU mimarisi paketlerini ayrı modüller olarak paketle
            enableSplit = true
        }
    }

    // Paketleme seçenekleri
    packagingOptions {
        // Asset sıkıştırmayı etkinleştir
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}