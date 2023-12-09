identification division.
program-id. day08.
environment division.
input-output section.
file-control.
       select movement
       assign to 'input2.txt'
       organisation is sequential.
       select direction
       assign to 'input3.txt'
       organisation is sequential.
data division.
file section.
fd movement
       record contains 17 characters.
01 movement-record.
       05 movement-location PIC X(3).
       05 FILLER PIC X(4). *> ' = ()'
       05 movement-direction-left PIC X(3).
       05 FILLER PIC X(2). *> ', '
       05 movement-direction-right PIC X(3).
       05 FILLER PIC X(2). *> ')\n'
fd direction.
01 direciton-record.
       05 direction-character PIC X(1).
working-storage section.
01 total-movements PIC S9(9) value 714.
01 total-directions PIC S9(9) value 281.
*>01 total-movements PIC S9(9) value 3.
*>01 total-directions PIC S9(9) value 3.

01 movement-idx PIC S9(9) value 1.
01 movement-table.
       05 movement-table-location PIC X(3) occurs 714 times.
       05 movement-table-direction-left PIC X(3) occurs 714 times.
       05 movement-table-direction-right PIC X(3) occurs 714 times.
01 direction-idx PIC S9(9) value 1.
01 direction-values PIC X(1) occurs 281 times.
01 ws-eof-movements PIC X(1) VALUE 'N'.
01 ws-direction-eof PIC X(1) value 'N'.

01 ws-step-count PIC S9(9) USAGE IS binary value is 0.

01 ws-current-direction PIC X(1) value 'L'.
01 ws-current-location PIC X(3) value 'AAA'.

procedure division.
main-procedure.
       perform read-all-movements.
       perform read-all-directions.
       move 1 to movement-idx
       move 1 to direction-idx
       perform check_movement until ws-current-location = 'ZZZ'
       stop run.

read-all-directions.
       open input direction
       perform read-single-direction until ws-direction-eof = 'Y' or ws-current-location = 'ZZZ'
       close direction.
 
 read-single-direction.
       read direction
       at end move 'Y' to ws-direction-eof
       not at end
           move direction-character to direction-values(direction-idx)
           compute direction-idx = direction-idx + 1
       end-read.

read-all-movements.
       open input movement
       perform read-single-movement until ws-eof-movements = 'Y'
       close movement.
read-single-movement.
       read movement
       at end move 'Y' to ws-eof-movements
       not at end
           move movement-location to movement-table-location(movement-idx)
           move movement-direction-left to movement-table-direction-left(movement-idx)
           move movement-direction-right to movement-table-direction-right(movement-idx)
           compute movement-idx = movement-idx + 1
       end-read.
check_movement.
       if movement-table-location(movement-idx) is equal to ws-current-location
           if direction-values(direction-idx) is equal to 'L'
               move movement-table-direction-left(movement-idx) to ws-current-location
           else
               move movement-table-direction-right(movement-idx) to ws-current-location
           end-if
           compute ws-step-count = ws-step-count + 1
           move 0 to movement-idx
           compute direction-idx = direction-idx + 1
           if direction-idx is greater than total-directions
               move 1 to direction-idx
           end-if
           display "Took step "ws-step-count" to "ws-current-location
       else
           compute movement-idx = movement-idx + 1
       end-if
       if movement-idx is greater than total-movements
       display "aaa"
       exit program returning 1
       stop run
       end-if
       .
       
