package nl.rickrongen.adventofcode2023

import nl.rickrongen.adventofcode2023.data.Hand
import java.io.File
import kotlin.streams.asStream
import kotlin.time.measureTime

fun main() {
    var cards: List<Hand>
    val timeParsing = measureTime {
//        val file = File("sampleinput.txt")
        val file = File("input.txt")
        cards = file.useLines {
            it.asStream()
                .map {
                    val parts = it.split(' ')
                    Hand(parts[0], parts[1].toLong())
                }
                .toList()
        }
    }

    val timePart1 = measureTime {
        val sorted = cards.sorted()

        val totalWinnings = sorted
            .mapIndexed { index, hand -> (index + 1) * hand.bed }
            .sum()
        println("Total Winnings: $totalWinnings")
    }

    val timePart2 = measureTime {
        val strongestSorted = cards.map(Hand::strongest)
            .sorted();
        val strongestTotalWinnings = strongestSorted
            .mapIndexed { index, hand -> (index + 1) * hand.bed }
            .sum()
        println("Strongest Total Winnings: $strongestTotalWinnings")
    }

    println("Took $timeParsing for parsing, $timePart1 for part 1 and $timePart2 for part 2")
}

/*
original:
Total Winnings: 251216224
Strongest Total Winnings: 250825971
Took 37.782827ms for parsing, 204.640135ms for part 1 and 1.307753846s for part 2
Improved 1:
Total Winnings: 251216224
Strongest Total Winnings: 250825971
Took 42.938601ms for parsing, 232.794841ms for part 1 and 121.541340ms for part 2
 */
