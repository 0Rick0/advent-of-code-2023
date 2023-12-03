package nl.rickrongen.adventofcode.year2023.dao;

import java.util.List;

public record PartLocation(char symbol, LocationInText locationInText, List<PartNumber> partNumbers) {

}
