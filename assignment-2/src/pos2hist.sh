awk '{
    for (i=1; i<=NF; i++) {
        binwidth=2; 
        bin=binwidth*int($i/binwidth); 
        count[bin]++
    }
} 
END {
    for (b in count) {
        print b, count[b]
    }
}' positions.dat | sort -n > histogram.dat
