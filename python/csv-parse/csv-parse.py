import csv

a: int = []
with open("DeaktiveringAvCPP-18.04.csv", newline = '') as f:
    reader = csv.reader(f, delimiter = ';')
    count = 0
    for row in reader:
        a.append(int(row[0].replace("ï»¿", '')))

a.sort()
o = open("output.txt", "a")
for b in a:
    o.write(str(b) + "\n")
o.close()