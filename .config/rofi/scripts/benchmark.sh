#!/bin/bash

prog="$1"
n=10
total=0

for ((i=1; i<=n; i++)); do
    t0=$(date +%s%N)
    $prog > /dev/null
    t1=$(date +%s%N)

    elapsed=$((t1 - t0))
        elapsed_sec=$(echo "scale=3; $elapsed/1000000" | bc)

    echo "Ejecución $i: $elapsed_sec ms"

    total=$(echo "$total + $elapsed_sec" | bc)
done

average=$(echo "scale=6; $total / $n" | bc)
echo "Tiempo promedio: $average ms"
