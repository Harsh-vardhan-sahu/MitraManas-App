import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mitramanas"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.mitramanas"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val props = Properties()
            val localPropsFile = rootProject.file("local.properties")
            if (localPropsFile.exists()) {
                props.load(localPropsFile.inputStream())
            }

            val keyPath = props.getProperty("keyPath") ?: ""
            val storePwd = props.getProperty("storePassword")
            val keyAlias = props.getProperty("keyAlias")
            val keyPwd = props.getProperty("keyPassword")

            if (keyPath.isNotEmpty()) {
                storeFile = file(keyPath)
            }
            storePassword = storePwd
            this.keyAlias = keyAlias
            keyPassword = keyPwd
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("debug") {
            // Optional: Use the same signing config as release for easier testing
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:30.3.0"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
}

flutter {
    source = "../.."
}
