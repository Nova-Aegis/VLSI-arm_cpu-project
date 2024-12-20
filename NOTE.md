# Notes

## REG

- plusieur instructions à la suite peuvent écrire dans le même registre à condition que l'écriture se fait dans exec et que la fifo dec2exe à une taille max de 1. 

# Problèms

 - On ne peux avoir 2 instruction à la suite qui écrive dans le même registre sous peine de ne pas pouvoir satisfaire la dépendance avec la prochaine instrucion.
