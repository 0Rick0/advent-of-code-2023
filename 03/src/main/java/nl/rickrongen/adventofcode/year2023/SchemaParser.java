package nl.rickrongen.adventofcode.year2023;

import nl.rickrongen.adventofcode.year2023.dao.LocationInText;
import nl.rickrongen.adventofcode.year2023.dao.PartLocation;
import nl.rickrongen.adventofcode.year2023.dao.PartNumber;
import nl.rickrongen.adventofcode.year2023.dao.Schema;

import java.util.ArrayList;
import java.util.Objects;

public class SchemaParser {
    private static PartNumber createPartNumber(String text, LocationInText start, int end) {
        final String partNumber = text.substring(start.offset(), end);
        return new PartNumber(partNumber, start, end - start.offset(), new ArrayList<>());
    }

    private static void fillSchema(final Schema schema) {
        LocationInText partNumberStart = null;
        int line = 0;
        int character = -1;
        int offset = -1;
        for (byte currentCharacter : schema.text().getBytes()) {
            offset++;
            character++;
            switch (currentCharacter) {
                case '.':
                    if (partNumberStart != null) {
                        schema.partNumbers().add(createPartNumber(schema.text(), partNumberStart, offset));
                        partNumberStart = null;
                    }
                    continue;
                case '\n':
                    // NOTE: dirty copy
                    if (partNumberStart != null) {
                        schema.partNumbers().add(createPartNumber(schema.text(), partNumberStart, offset));
                        partNumberStart = null;
                    }
                    line++;
                    character = -1;
                    continue;
                case '0':
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                    if (partNumberStart == null) {
                        partNumberStart = new LocationInText(line, character, offset);
                    }
                    continue;
                default:
                    // NOTE: dirty copy
                    if (partNumberStart != null) {
                        schema.partNumbers().add(createPartNumber(schema.text(), partNumberStart, offset));
                        partNumberStart = null;
                    }
                    // special
                    schema.partLocations().add(new PartLocation(
                            ((char) currentCharacter),
                            new LocationInText(line, character, offset),
                            new ArrayList<>()
                    ));
            }

        }
    }

    private static void linkPartNumbers(final Schema schema) {
        for (final PartNumber partNumber : schema.partNumbers()) {
            for (final PartLocation partLocation : schema.partLocations()) {
                if (partNumber.isNearby(partLocation.locationInText())) {
                    partLocation.partNumbers().add(partNumber);
                    partNumber.partLocations().add(partLocation);
                }
            }
        }
    }

    public static Schema parse(String text) {
        final Schema schema = new Schema(text, new ArrayList<>(), new ArrayList<>());

        fillSchema(schema);
        linkPartNumbers(schema);

        return schema;
    }
}
