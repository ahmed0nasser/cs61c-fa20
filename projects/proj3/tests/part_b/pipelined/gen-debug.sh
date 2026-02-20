#!/usr/bin/env bash
DEBUG="debug.txt"

echo '## PROGRAM' > $DEBUG
cat "./inputs/$1.s" >> $DEBUG

echo >> $DEBUG

echo '## REFERENCE' >> $DEBUG
./binary_to_hex_cpu.py "reference_output/cpu-$1-ref.out" >> $DEBUG

echo >> $DEBUG

echo '## STUDENT' >> $DEBUG
./binary_to_hex_cpu.py "student_output/cpu-$1-student.out" >> $DEBUG
