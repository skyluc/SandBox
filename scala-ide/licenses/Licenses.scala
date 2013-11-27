package test

import scala.xml.XML
import scala.xml.Elem
import scala.xml.NodeSeq

object Licenses {

  val files = List(("scala-ide", List(
    "./org.scala-ide.sdt.aspects/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.source.feature/target/generated-resources/licenses.xml",
    "./org.scala-ide.sbt.compiler.interface/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.core/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.debug.tests/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.debug/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.dev.feature/target/generated-resources/licenses.xml",
    "./org.scala-ide.sbt.compiler.interface.source/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.update-site/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.core.tests/target/generated-resources/licenses.xml",
    "./org.scala-ide.sbt.full.library/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.feature/target/generated-resources/licenses.xml",
    "./org.scala-ide.sbt.full.library.source/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.weaving.feature/target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.build/target/generated-resources/licenses.xml",
    "./target/generated-resources/licenses.xml",
    "./org.scala-ide.sdt.spy/target/generated-resources/licenses.xml",
    "./org.scala-ide.build-toolchain/target/generated-resources/licenses.xml")),
    ("scala-worksheet", List(
      "./org.scalaide.worksheet.feature/target/generated-resources/licenses.xml",
      "./org.scalaide.worksheet/target/generated-resources/licenses.xml",
      "./org.scalaide.worksheet.update-site/target/generated-resources/licenses.xml",
      "./org.scalaide.worksheet.tests/target/generated-resources/licenses.xml",
      "./target/generated-resources/licenses.xml",
      "./org.scalaide.worksheet.source.feature/target/generated-resources/licenses.xml",
      "./org.scalaide.worksheet.runtime.library/target/generated-resources/licenses.xml")),
    ("scala-ide-play2", List(
      "./org.scala-ide.sdt.editor/target/generated-resources/licenses.xml",
      "./org.scala-ide.play2/target/generated-resources/licenses.xml",
      "./org.scala-ide.play2.update-site/target/generated-resources/licenses.xml",
      "./org.scala-ide.sdt.editor.tests/target/generated-resources/licenses.xml",
      "./org.scala-ide.play2.tests/target/generated-resources/licenses.xml",
      "./org.scala-ide.play2.feature/target/generated-resources/licenses.xml",
      "./target/generated-resources/licenses.xml",
      "./org.scala-ide.play2.source.feature/target/generated-resources/licenses.xml")),
    ("scala-search", List(
      "./org.scala.tools.eclipse.search.source.feature/target/generated-resources/licenses.xml",
      "./org.scala.tools.eclipse.search/target/generated-resources/licenses.xml",
      "./org.scala.tools.eclipse.search.update-site/target/generated-resources/licenses.xml",
      "./target/generated-resources/licenses.xml",
      "./org.scala.tools.eclipse.search.feature/target/generated-resources/licenses.xml",
      "./org.scala.tools.eclipse.search.tests/target/generated-resources/licenses.xml")))

  def main(args: Array[String]) {

    val deps = files.map { p =>
      val ls = p._2.flatMap(f => licenses(p._1, f)).distinct.sortBy(d => s"${d.groupId}:${d.artifactId}")
      (p._1, ls)
    }

    println(deps.map(d => s"""${d._1}\n\n${d._2.map(Dep.prettyPrinter).mkString("\n")}""").mkString("\n\n"))

  }

  def licenses(project: String, file: String): Seq[Dep] = {
    val xml = XML.loadFile(s"/home/luc/dev/scala-ide/$project/$file") \\ "dependency"

    xml.map { d =>
      Dep((d \ "groupId").text, (d \ "artifactId").text, (d \ "version").text, license(d \ "licenses"))
    }
  }

  def license(ls: NodeSeq): Option[License] = {
    val l = (ls \ "license").headOption

    l map { a =>
      License((a \ "name").text, (a \ "url").text)
    }
  }
}

case class Dep(groupId: String, artifactId: String, version: String, license: Option[License])

object Dep {
  def prettyPrinter(d: Dep) = s"${d.groupId}:${d.artifactId}:${d.version} - " + ((d.license map { l => s"${l.name} (${l.url})" }).getOrElse("no license"))
}

case class License(name: String, url: String)