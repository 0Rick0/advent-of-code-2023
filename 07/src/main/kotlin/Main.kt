package nl.rickrongen.adventofcode2023

import nl.rickrongen.adventofcode2023.data.Hand
import java.io.File
import kotlin.streams.asStream

fun main() {
//    val file = File("sampleinput.txt")
    val file = File("input.txt")
    val cards = file.useLines {
        it.asStream()
            .map {
                val parts = it.split(' ')
                Hand(parts[0], parts[1].toLong())
            }
            .toList()
    }
    val sorted = cards.sorted()

    val totalWinnings = sorted
        .mapIndexed { index, hand -> (index + 1) * hand.bed }
        .sum()
    println("Total Winnings: $totalWinnings")

    val strongestSorted = cards.map(Hand::strongest)
        .sorted();
    val strongestTotalWinnings = strongestSorted
        .mapIndexed { index, hand -> (index + 1) * hand.bed }
        .sum()
    println("Strongest Total Winnings: $strongestTotalWinnings")
}
