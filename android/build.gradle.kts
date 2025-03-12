buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {

        classpath("com.android.tools.build:gradle:7.4.2")  // Correct syntax in Kotlin DSL
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // Set the custom build directory for subprojects
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Ensure ':app' is evaluated before subprojects
    project.evaluationDependsOn(":app")
}

// Clean task to delete build directories
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
