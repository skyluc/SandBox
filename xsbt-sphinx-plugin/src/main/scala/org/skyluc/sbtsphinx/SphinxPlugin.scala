package org.skyluc.sbtsphinx

import sbt._
import Keys._
import java.io.File

object SphinxPlugin extends Plugin {

  val sphinxHtml = TaskKey[Unit]("sphinx-html")
  
  val sphinxWatchSources= watchSources in sphinxHtml

  val sphinxSettings = Seq(
    sourceDirectory in sphinxHtml <<= baseDirectory,
    excludeFilter in sphinxHtml := "_build",
    watchSources in sphinxHtml <<= (sourceDirectory in sphinxHtml, excludeFilter in sphinxHtml) map { (dir, exc) => dir.descendentsExcept("*", exc).get},
    sphinxHtml := {
      println("hello")
      val returnValue = Process.apply(Seq("make", "clean", "html")).!
      println("done %s".format(returnValue))
    })
    
    lazy val sphinxCommand = 
    Command.command("sphinx") { (state: State) =>
      println("Hi!")
      state
    }
  
    override lazy val settings= Seq(commands += sphinxCommand,
        watchSources<<= sphinxWatchSources)

}