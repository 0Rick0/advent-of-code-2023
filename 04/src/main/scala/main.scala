package nl.rickrongen.adventofcode.year2023

import scala.collection.View
import scala.io.Source

//val filename = "sampleinput.txt"
val filename = "input.txt"

class Parts(
           var cartId: Int,
           var winningNumbers: Set[Int],
           var myNumbers: Set[Int]
           ):
  def count: Int = myNumbers.intersect(winningNumbers).size
  def points: Int = {
    count match
    case 0 => 0
    case x if x > 0 => scala.math.pow (2, x - 1).toInt
    case x if x < 0 => throw new IllegalArgumentException ("count must be positive")
  }
  override def toString: String = s"Card $cartId: $winningNumbers $myNumbers"

implicit class StringNumbersToIntSet(val self: String) extends AnyVal {
  def toIntSet: Set[Int] = {
    self
      .split(' ')
      .filter(_.nonEmpty)
      .map(_.toInt)
      .toSet
  }
}

implicit class StringToParts(val self: String) extends AnyVal {
  def toParts: Parts = {
    val Re = """^Card\s*(\d+):((?:\s{1,2}\d+)+)\s[|]((?:\s{1,2}\d+)+)$""".r
    self match
      case Re(gameId, winningNumbers, myNumbers) => Parts(gameId.toInt, winningNumbers.toIntSet, myNumbers.toIntSet)
  }
}

def allTheCards(list: View[Parts], fullList: View[Parts]): View[Parts] = {
  list.flatMap(a => {
      // cartId is one offset
      val extraItems = allTheCards(fullList.view.slice(a.cartId, a.cartId + a.count), fullList)
      val value = List(a).concat(extraItems)
      value
    })
}


@main
def main(): Unit = {
  val parts = Source.fromFile(filename).getLines().map(_.toParts).toList

  val sum = parts.map(_.points).sum
  println(s"Total points $sum")

  println(s"Sum of scratch cards ${allTheCards(parts.view, parts.view).size}")
}
