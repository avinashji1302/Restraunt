pluginManagement {
    
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        properties.getProperty("flutter.sdk")
            ?: error("flutter.sdk not set in local.properties")
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // ✅ UPDATED: Upgraded from 8.5.2 to 8.7.3 (latest stable)
    id("com.android.application") version "8.7.3" apply false
    // ✅ UPDATED: Upgraded from 1.9.24 to 2.1.0 (required for Firebase compatibility)
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    // ✅ PREVIOUSLY ADDED: Google Services plugin for Firebase
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")
