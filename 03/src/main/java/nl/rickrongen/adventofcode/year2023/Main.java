package nl.rickrongen.adventofcode.year2023;

import nl.rickrongen.adventofcode.year2023.dao.PartNumber;
import nl.rickrongen.adventofcode.year2023.dao.Schema;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class Main {
    public static void main(String[] args) {
        try {
//            final String content = Files.readString(Path.of("testinput.txt"));
            final String content = Files.readString(Path.of("input.txt"));
            final Schema schema = SchemaParser.parse(content);
            final int sumOfProductNumbers = schema.partNumbers()
                    .stream()
                    .filter(partNumber -> !partNumber.partLocations().isEmpty())
                    .mapToInt(PartNumber::numberAsInt)
                    .sum();
            System.out.printf("Sum of product numbers %d%n", sumOfProductNumbers);

            final int sumGearRatio = schema.partLocations().stream()
                    .filter(partLocation -> partLocation.symbol() == '*')
                    .filter(partLocation -> partLocation.partNumbers().size() == 2)
                    .mapToInt(partLocation -> partLocation.partNumbers()
                            .stream()
                            .mapToInt(PartNumber::numberAsInt)
                            .reduce((a, b) -> a * b)
                            .getAsInt())
                    .sum();
            System.out.printf("Sum of gear ratios %d%n", sumGearRatio);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
