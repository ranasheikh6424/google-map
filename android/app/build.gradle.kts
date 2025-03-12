plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.untitled2"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true  // Enable desugaring support
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        multiDexEnabled = true
        applicationId = "com.example.untitled2"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    ndkVersion = "27.0.12077973"
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1") // Add multidex dependency
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.5.31")
    // Add core library desugaring for Java 8+ support
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")

    // Your other dependencies go here...
}

flutter {
    source = "../.."
}
