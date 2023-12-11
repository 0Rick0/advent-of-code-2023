class Point {
    public int x { get; set; }
    public int y { get; set; }

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

public class Day10 : GLib.Object{

    private string filename;
    private int lineLength = 0;
    private string emptyLine = null;
    private Gee.ArrayList<string> lines;
    private char[,] outLines;
    private char[,] outLinesX2;
    private Point startPosition = null;
    private Point position = null;
    private Point previosPosition = null;

    public Day10(string filename) {
        this.filename = filename;
        this.lines = new Gee.ArrayList<string>();
    }

    private void readFile() {
        var file = File.new_for_path(this.filename);
        if(!file.query_exists()) {
            error("File %s doesn't exist!\n", file.get_path());
        }

        try {
            var dis = new DataInputStream(file.read());
            string line;
            while ((line = dis.read_line(null)) != null) {
                if (this.lineLength == 0) {
                    this.lineLength = line.length;
                }
                lines.add(line);
            }
        } catch (Error e) {
            error("%s", e.message);
        }
        this.outLines = new char[this.lines.size, this.lineLength];
        this.outLinesX2 = new char[this.lines.size*2, this.lineLength*2];
    }

    void findStart() {
        for (int i = 0; i < this.lines.size; i++) {
            var line = this.lines[i];
            var index = line.index_of("S");
            if (index < 0) {
                continue;
            }
            
            startPosition = new Point(index, i);
            position = startPosition;
            return;
        }
        error("Start not found");
    }

    char atPosition(Point position) {
        return this.at(position.x, position.y);
    }
    char at(int x, int y) {
        return this.lines[y][x];
    }

    Point? canGoLeft() {
        if (this.position.x == 0) return null;
        char c = this.at(this.position.x - 1, this.position.y);
        switch (c) {
            case 'F':
            case 'L':
            case '-':
            case 'S':
                return new Point(this.position.x - 1, this.position.y);
            default:
                return null;
        }
    }

    Point? canGoUp() {
        if (this.position.y == 0) return null;
        char c = this.at(this.position.x, this.position.y - 1);
        switch (c) {
            case 'F':
            case '7':
            case '|':
            case 'S':
                return new Point(this.position.x, this.position.y - 1);
            default:
                return null;
        }
    }

    Point? canGoRight() {
        if (this.position.x == this.lineLength - 1) return null;
        char c = this.at(this.position.x + 1, this.position.y);
        switch (c) {
            case '7':
            case '-':
            case 'J':
            case 'S':
                return new Point(this.position.x + 1, this.position.y);
            default:
                return null;
        }
    }

    Point? canGoDown() {
        if (this.position.y == this.lines.size - 1) return null;
        char c = this.at(this.position.x, this.position.y + 1);
        switch (c) {
            case 'J':
            case 'L':
            case '|':
            case 'S':
                return new Point(this.position.x, this.position.y + 1);
            default:
                return null;
        }
    }

    Point? getNextStep() {
        char current = this.atPosition(this.position);
        var valid = new Gee.ArrayList<Point>();
        switch (current) {
            case 'S':
                valid.add(this.canGoLeft());
                valid.add(this.canGoRight());
                valid.add(this.canGoUp());
                valid.add(this.canGoDown());
                break;
            case 'L':
                valid.add(this.canGoRight());
                valid.add(this.canGoUp());
                break;
            case '7':
                valid.add(this.canGoLeft());
                valid.add(this.canGoDown());
                break;
            case 'J':
                valid.add(this.canGoLeft());
                valid.add(this.canGoUp());
                break;
            case 'F':
                valid.add(this.canGoRight());
                valid.add(this.canGoDown());
                break;
            case '|':
                valid.add(this.canGoUp());
                valid.add(this.canGoDown());
                break;
            case '-':
                valid.add(this.canGoLeft());
                valid.add(this.canGoRight());
                break;
            default:
                break;
        }
        while(valid.remove(null));
        if (valid.size > 2) {
            error("too many valid locations");
        }
        var first = valid.first();
        if (first.x == this.previosPosition.x && first.y == this.previosPosition.y) {
            return valid.last();
        }
        return first;
    }

    void findRouteLength() {
        int steps = 0;
        do {
            this.outLines[this.position.y, this.position.x] = this.lines[this.position.y][this.position.x];
            var next = this.getNextStep();
            this.previosPosition = this.position;
            this.position = next;
            steps++;
            //  stdout.printf("Step %d to %d:%d\n", steps, this.position.x, this.position.y);
        } while (!(this.position.x == this.startPosition.x && this.position.y == this.startPosition.y));
        stdout.printf("Took %d steps, half is %d\n", steps, steps/2);
    }

    private void doubleSize() {
        for (int y = 0; y < this.lines.size; y++) {
            for (int x = 0; x < this.lineLength; x++) {
                switch (this.outLines[y, x]) {
                    case 'L':
                        this.outLinesX2[y*2, x*2] = '|';
                        this.outLinesX2[y*2+1, x*2] = 'L';
                        this.outLinesX2[y*2+1, x*2+1] = '-';
                        break;
                    case '7':
                        this.outLinesX2[y*2+1, x*2] = '7';
                        break;
                    case 'J':
                        this.outLinesX2[y*2, x*2] = '|';
                        this.outLinesX2[y*2+1, x*2] = 'J';
                        break;
                    case '|':
                        this.outLinesX2[y*2, x*2] = '|';
                        this.outLinesX2[y*2+1, x*2] = '|';
                        break;
                    case '-':
                        this.outLinesX2[y*2+1, x*2] = '-';
                        this.outLinesX2[y*2+1, x*2+1] = '-';
                        break;
                    case 'F':
                        this.outLinesX2[y*2+1, x*2+1] = '-';
                        this.outLinesX2[y*2+1, x*2] = 'F';
                        break;
                    case 'S':
                        this.outLinesX2[y*2, x*2] = '|';
                        this.outLinesX2[y*2+1, x*2+1] = '-';
                        this.outLinesX2[y*2+1, x*2] = 'S';
                        break;
                }
            }
        }
    }

    private void floodFill(int x, int y) {
        if (this.outLinesX2[y, x] != 0) {
            return;
        }
        this.outLinesX2[y, x] = 'O';
        if (x > 0) {
            floodFill(x-1, y);
        }
        if (y > 0) {
            floodFill(x, y-1);
        }
        if (x < this.lineLength*2) {
            floodFill(x+1, y);
        }
        if (y < this.lines.size * 2) {
            floodFill(x, y+1);
        }
    }

    private void countInside() {
        int total = 0;
        // only take Y should be odd, x should be even, this is because of the X2 part
        for (int y = 1; y < this.lines.size*2; y += 2) {
            for (int x = 0; x < this.lineLength*2; x += 2) {
                if (this.outLinesX2[y, x] == 0) {
                    total += 1;
                    this.outLinesX2[y, x] = 'I';
                }
            }
        }
        stdout.printf("Total inside: %d\n", total);
    }

    public void run() {
        this.readFile();
        this.findStart();
        this.findRouteLength();
        this.doubleSize();
        this.floodFill(0, 0);
        this.floodFill(1, this.lines.size * 2 - 1);
        this.countInside();

        for (int y = 0; y < this.lines.size*2; y++) {
            for (int x = 0; x < this.lineLength*2; x++) {
                stdout.printf("%c", this.outLinesX2[y, x] == 0 ? '.' : this.outLinesX2[y, x]);
            }
            stdout.printf("\n");
        }
    }

    public static int main(string[] args) {
        //  new Day10("sampleinput.txt").run();
        new Day10("input.txt").run();
        return 0;
    }
}