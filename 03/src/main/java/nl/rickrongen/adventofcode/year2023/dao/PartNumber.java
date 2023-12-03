package nl.rickrongen.adventofcode.year2023.dao;

import java.util.List;

public record PartNumber(String number, LocationInText locationInText, int length, List<PartLocation> partLocations) {

    public int numberAsInt() {
        return Integer.parseInt(this.number, 10);
    }

    public boolean isNearby(final LocationInText other) {
        // next, previous or same line
        if (Math.abs(other.line() - locationInText().line()) > 1) {
            return false;
        }
        return (other.character() >= (locationInText().character() - 1)) // at most one in front
                && (other.character() <= (locationInText().character() + length)); // at most one after
    }
}
