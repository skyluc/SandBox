package demo

/**
 * Command line arguments for starting the VM
 *   - as a server: -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=y
 *   - as a client: -agentlib:jdwp=transport=dt_socket,address=localhost:8000,server=n,suspend=y
*  */

object Main {
  
  val Noop= () => ()
  
  def main(args: Array[String]): Unit = {
    println("I'm started")
    Noop()
    println("I'm done")
  }

}

class Main