object HelloWorld {
  def main (args: Array[String] ) = {
    foo;
    var m = new Marc("marc")
    println(m);
    m() ="Joe";
    println(m)
  }
  def foo = {
      val l = for {i <- 1 to 10
          j <- 1 to 10 if ((i*j)%2) != 0 }
        yield i*j
    println("l="+ l);
    val myList = "foo" :: "all your base" :: "four":: Nil
    myList.partition(_.length > 3)._1.foreach(s => print(s +" "));
    println
  }
}

case class Marc (var n: String) {

   def update (s:String) = n = s
}
