

// vim: set ts=4 sw=4 et:


type FibFunc = (Int)=>Int


abstract class pres {
    def pre = {}
    def post = {}
}

trait baseFib extends pres {
    def actual_fib(n:Int):Int
    def fib(n:Int):Int = { 
        pre;
        val r = actual_fib(n)
        post
        return r
    }
}
class iFib extends baseFib {
    def ffib2(a:Int, b:Int, c:Int, n:Int):Int = if (c >= n) b else { ffib2(b, a+b, c+1, n) }
    def ffib(n:Int):Int = ffib2(1, 1, 1, n)

    def actual_fib(n:Int):Int = { 
        ffib(n)
    }
}

class rFib extends baseFib {
    def actual_fib(n:Int):Int = if (n <= 1) 1 else { fib(n-1) + fib(n-2) }
}

trait iTerFn extends pres {
    var     cnt = 0;

    override def pre ={ cnt = cnt + 1}
    def getCnt = cnt;
    def clr = { cnt = 0 }
}

class crFib extends rFib with iTerFn {}
class ciFib extends iFib with iTerFn {}



def time(f: => Unit):Long = {
    val t1 = System.currentTimeMillis()
    f
    val t2 = System.currentTimeMillis()
    t2-t1
}
