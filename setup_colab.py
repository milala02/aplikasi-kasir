import os, subprocess

print("🚀 MEMULAI SETUP LINGKUNGAN FLUTTER & ANDROID LENGKAP DI COLAB...")

# 1. Update System & Install Java 17 + Ninja
print("\n📦 1. Menginstal Java 17, Ninja, Wget, Unzip...")
os.system('apt-get update -qq && apt-get install -y -qq openjdk-17-jdk-headless ninja-build wget unzip git > /dev/null 2>&1')
java17_path = "/usr/lib/jvm/java-17-openjdk-amd64"
os.environ["JAVA_HOME"] = java17_path
os.environ["PATH"] = f"{java17_path}/bin:" + os.environ["PATH"]

# 2. Clone Flutter SDK
print("\n🪶 2. Menginstal Flutter SDK...")
if not os.path.exists('/content/flutter'):
    os.system('git clone -b stable https://github.com/flutter/flutter.git /content/flutter > /dev/null 2>&1')
os.environ['PATH'] += ':/content/flutter/bin'

# 3. Setup Android SDK Command Line Tools
print("\n🤖 3. Menginstal Android SDK & Tools...")
android_home = '/opt/android-sdk'
os.makedirs(f"{android_home}/cmdline-tools", exist_ok=True)

if not os.path.exists(f"{android_home}/cmdline-tools/latest"):
    os.system('wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/sdk.zip')
    os.system('unzip -q /tmp/sdk.zip -d /tmp/sdk')
    os.system(f'mv /tmp/sdk/cmdline-tools {android_home}/cmdline-tools/latest')
    os.system('rm -f /tmp/sdk.zip')

os.environ['ANDROID_HOME'] = android_home
os.environ['PATH'] += f':{android_home}/cmdline-tools/latest/bin:{android_home}/platform-tools'

# 4. Konfigurasi SDK, Lisensi, CMake, & NDK
print("\n⚙️ 4. Mengonfigurasi SDK, CMake, NDK, & Lisensi...")
os.system(f'flutter config --android-sdk {android_home} > /dev/null 2>&1')
os.system(f'yes | {android_home}/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1')
os.system(f'yes | {android_home}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "cmake;3.22.1" "ndk-bundle" > /dev/null 2>&1')

# 5. Penyesuaian Proyek Flutter
project_path = '/content/aplikasi-kasir'
if os.path.exists(project_path):
    os.chdir(project_path)
    
    with open('android/local.properties', 'a') as f:
        f.write(f"\ncmake.dir={android_home}/cmake/3.22.1\n")
        
    gradle_path = 'android/app/build.gradle'
    if os.path.exists(gradle_path):
        with open(gradle_path, 'r') as f: content = f.read()
        content = content.replace('minSdkVersion flutter.minSdkVersion', 'minSdkVersion 21')
        content = content.replace('minSdkVersion 16', 'minSdkVersion 21')
        content = content.replace('minifyEnabled true', 'minifyEnabled false')
        content = content.replace('shrinkResources true', 'shrinkResources false')
        with open(gradle_path, 'w') as f: f.write(content)

    print("\n🧹 6. Membersihkan Cache & Sinkronisasi Dependensi Proyek...")
    os.system('flutter clean')
    os.system('flutter pub get')

print("\n✅ SETUP MASTER SELESAI 100%!")
