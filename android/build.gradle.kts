allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)


// Workaround AGP 8+ yang Aman (Tanpa afterEvaluate)
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            if (namespace == null) {
                // Spesifikasikan namespace untuk blue_thermal_printer
                if (project.name == "blue_thermal_printer") {
                    namespace = "id.kakzaki.blue_thermal_printer"
                } else {
                    namespace = project.group.toString()
                }
            }
        }
    }
}
