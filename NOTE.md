# Notes

## REG

- plusieur instructions à la suite peuvent écrire dans le même registre à condition que l'écriture se fait dans exec et que la fifo dec2exe à une taille max de 1. 

## Problèms

 - On ne peux avoir 2 instruction à la suite qui écrive dans le même registre sous peine de ne pas pouvoir satisfaire la dépendance avec la prochaine instrucion.
 
## Opération standard

 - implémenté
 - Il est possible de moidifer le PC (registre 15) avec des opération standard (mov, add, sub, and, or, etc...). Ces instruction ce comporteron comme des branchement sans linkage.
 - Il peut-être interessant de le désactivé tout simplement à la compilation ou dans le processeur (ajout d'une condition si regop & wb & wb_adr = 0xF).

## Branchement

 - implémenté

### Delayed slot

 - on a 2 delayed slot ce qui peut avoir un impact à la compilation si ce n'est pas le comportement habituelle.
 - Cela peut-être modifié au coût d'un branchement plus long ( opération préalable de $\text{pc} - 8$, donc +2 cycles +3 si modification pc précédament )
 - Le calcul de l'offset lors d'un branch est donc $\text{pc instruction voulue} - \text{pc instruction saut} - \text{0x0C}$. 

## Accès mémoire

 - implémentation incomplète (WIP)
 - Modification du regsitre pc obligatoirement activé (return)
 
## Accès mémoire multiple

 - implémentation non faite

## Multiplication

 - implémentation non faite
 - compléxité élevée. Pas encore étudier la question.
 
