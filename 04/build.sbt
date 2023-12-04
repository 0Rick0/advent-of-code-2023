ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "3.3.1"

lazy val root = (project in file("."))
  .settings(
    name := "day04",
    idePackagePrefix := Some("nl.rickrongen.adventofcode.year2023")
  )
