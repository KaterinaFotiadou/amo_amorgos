import java.util.Properties
import java.io.FileInputStream

// Φόρτωσε τα flutter.* από το local.properties
val localProps = Properties().apply {
    val f = rootProject.file("local.properties")
    if (f.exists()) load(FileInputStream(f))
}


plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}


val keystoreProperties = Properties()
val keystoreFile = rootProject.file("key.properties")
if (keystoreFile.exists()) {
    keystoreFile.inputStream().use { keystoreProperties.load(it) }
}


android {
    // ⚠️ Βάλε το οριστικό σου package εδώ
    namespace = "com.amorgos.amoamorgos"   // να ταιριάζει
    compileSdk = 35

    defaultConfig {
        applicationId = "com.amorgos.amoamorgos"
        minSdk = 23
        targetSdk = 35

        val flutterVersionCode = localProps.getProperty("flutter.versionCode")?.toInt() ?: 1
        val flutterVersionName = localProps.getProperty("flutter.versionName") ?: "1.0.0"
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }


    // ✅ Ένα και μοναδικό release signing, εκτός defaultConfig
    signingConfigs {
        // Αν υπάρχει ήδη release στο template σου, χρησιμοποίησε getByName("release") αντί για create
        create("release") {
            // Συνίσταται να έχεις: android/key.properties  και app/amorgos.keystore
            // key.properties:
            // storePassword=...
            // keyPassword=...
            // keyAlias=amorgos
            // storeFile=app/amorgos.keystore
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false   // <-- κρατά το ρητά κλειστό
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }



    kotlinOptions { jvmTarget = "17" }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))
    implementation("com.google.firebase:firebase-firestore")
}
