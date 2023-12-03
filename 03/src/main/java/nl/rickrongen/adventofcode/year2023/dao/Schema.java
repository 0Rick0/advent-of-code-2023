package nl.rickrongen.adventofcode.year2023.dao;

import java.util.List;

public record Schema(String text, List<PartNumber> partNumbers, List<PartLocation> partLocations) {
}
