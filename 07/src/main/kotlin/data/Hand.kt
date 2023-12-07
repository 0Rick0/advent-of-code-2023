package nl.rickrongen.adventofcode2023.data

import kotlin.streams.toList

const val STRENGTH = "23456789TJQKA"
const val J_STRENGTH = "J23456789TQKA"

data class Hand(val cards: String, val bed: Long, val original: Hand? = null) : Comparable<Hand> {

    private fun strengthOf(n: Int): Int {
        if (original != null) {
            return J_STRENGTH.indexOf(original.cards[n])
        }
        return STRENGTH.indexOf(cards[n])
    }

    private fun compareCards(other: Hand): Int {
        for (i in cards.indices) {
            val result = other.strengthOf(i).compareTo(strengthOf(i))
            if (result != 0) {
                return result
            }
        }
        return 0
    }

    private fun getPairCount(): Long {
        return cards.chars().distinct()
            .filter {
                cards.chars()
                    .filter(it::equals)
                    .count() > 1
            }
            .count()
    }

    private fun isNOfAKind(value: Long): Boolean {
        return cards.chars().distinct().anyMatch {
            cards.chars()
                .filter(it::equals)
                .count() >= value
        }
    }

    private fun compareNOfAKind(other: Hand, n: Long): Int? {
        if (this.isNOfAKind(n) && other.isNOfAKind(n)) {
            return compareCards(other)
        }
        if (this.isNOfAKind(n)) {
            return -1
        }
        if (other.isNOfAKind(n)) {
            return 1
        }
        return null
    }

    private fun isFullHouse(): Boolean {
        return cards.chars().distinct().count() == 2L &&
                cards.chars().distinct()
                    .allMatch {
                        cards.chars()
                            .filter(it::equals)
                            .count() > 1
                    }
    }

    private fun compareFullHouse(other: Hand): Int? {
        if (this.isFullHouse() && other.isFullHouse()) {
            return compareCards(other)
        }
        if (this.isFullHouse()) {
            return -1
        }
        if (other.isFullHouse()) {
            return 1
        }
        return null;
    }

    override fun compareTo(other: Hand): Int {
        return _compareTo(other) * -1;
    }

    fun _compareTo(other: Hand): Int {
        val compareFiveOfAKind = compareNOfAKind(other, 5)
        if (compareFiveOfAKind != null) {
            return compareFiveOfAKind
        }
        val compareFourOfAKind = compareNOfAKind(other, 4)
        if (compareFourOfAKind != null) {
            return compareFourOfAKind
        }
        val compareFullHouse = compareFullHouse(other)
        if (compareFullHouse != null) {
            return compareFullHouse;
        }
        val compareThreeOfAKind = compareNOfAKind(other, 3)
        if (compareThreeOfAKind != null) {
            return compareThreeOfAKind
        }

        val selfPairs = getPairCount()
        val otherPairs = other.getPairCount()
        if (selfPairs == otherPairs) {
            return compareCards(other)
        } else {
            return otherPairs.compareTo(selfPairs)
        }
    }

    /**
     * Builds the strongest version of itself
     */
    fun strongest(): Hand {
        // stupid algorithm
        val toList = this.cards.chars()
            .mapToObj {
                if (it == 'J'.code) {
                    return@mapToObj STRENGTH.chars().toList()
                } else {
                    return@mapToObj listOf(it)
                }
            }
            .toList()

        val out = mutableListOf<Hand>()

        for (i in toList[0]) {
            for (i1 in toList[1]) {
                for (i2 in toList[2]) {
                    for (i3 in toList[3]) {
                        for (i4 in toList[4]) {
                            out.add(Hand(listOf(i, i1, i2, i3, i4).map(Int::toChar).joinToString(""), this.bed, this))
                        }
                    }
                }
            }
        }
        return out.maxOf { it };
    }
}
