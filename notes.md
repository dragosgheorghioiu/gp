# GP Lab Notes
## Lab 2 Perlin Noise generator
- se defineste un grid 
- fiecarui punct i se atribuie un vector cu o directie random 
- pentru a culca valoarea unui punct random din grid mai intai se incadreaza
aceasta valoare in gridul initial
- se calculeaza vectorii offset din colturile celulei la punctul curent
- se face produsul scalar dintre vectorul gradient si vectorul ce cuprinde
fiecare colt al unei celule
- se face o interpolare liniara intre cele 4 puncte
