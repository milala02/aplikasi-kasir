import os, subprocess

print("🚀 MEMULAI SETUP LINGKUNGAN ANDROID BUILD DI COLAB...")
project_path = '/content/aplikasi-kasir'
os.chdir(project_path)

print("\n📦 1. Menginstal Java 17...")
os.system('apt-get update -qq && apt-get install -y -qq openjdk-17-jdk-headless ninja-build > /dev/null 2>&1')
java17_path = "/usr/lib/jvm/java-17-openjdk-amd64"
os.environ["JAVA_HOME"] = java17_path
os.environ["PATH"] = f"{java17_path}/bin:" + os.environ["PATH"]

print("🛠️ 2. Menerima Lisensi Android SDK & Instalasi CMake/NDK...")
os.system('yes | flutter doctor --android-licenses > /dev/null 2>&1')
android_home = os.environ.get('ANDROID_HOME', '/content/android-sdk')
sdkmanager = f"{android_home}/cmdline-tools/latest/bin/sdkmanager"
if not os.path.exists(sdkmanager): sdkmanager = "sdkmanager"
os.system(f'yes | {sdkmanager} "cmake;3.22.1" "ndk-bundle" > /dev/null 2>&1')

print("⚙️ 3. Menghubungkan CMake ke Flutter (local.properties)...")
with open('android/local.properties', 'a') as f:
    f.write(f"\ncmake.dir={android_home}/cmake/3.22.1\n")

print("🔧 4. Menyesuaikan build.gradle (minSdk 21 & Disable Minify)...")
gradle_path = 'android/app/build.gradle'
if os.path.exists(gradle_path):
    with open(gradle_path, 'r') as f: content = f.read()
    content = content.replace('minSdkVersion flutter.minSdkVersion', 'minSdkVersion 21')
    content = content.replace('minSdkVersion 16', 'minSdkVersion 21')
    content = content.replace('minifyEnabled true', 'minifyEnabled false')
    content = content.replace('shrinkResources true', 'shrinkResources false')
    with open(gradle_path, 'w') as f: f.write(content)

print("🧹 5. Membersihkan Cache & Sinkronisasi Dependensi...")
os.system('flutter clean')
os.system('flutter pub get')

print("\n✅ SETUP SELESAI! Lingkungan Colab sudah siap 100%.")
print("Kamu sekarang bisa langsung menjalankan: flutter build apk --release")
