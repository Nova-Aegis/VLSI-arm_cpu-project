# VHDL

## Banc de registre

Le banc de registres stocke les valeurs des 16 registres du processeur avec le registre 15 qui est le programme counter. Celui-ci peu-être incrémenter de 4 sous demande tant qu'il est valide. Chaque registre possède aussi un bit de validité qui définie si le registre va être modifié sous peu. Le banc habite aussi les 4 bit de flag : negative, zero, carry et overflow. Eux n'ont que 2 bit de flag, un pour l'overflow et l'autre pour les trois restant. La raison pour le bit de validité que pour overflow est qu'il ne sera pas modifié si l'instruction qui met à jour les flag n'est pas une instruction arithmétique.

Nous avons remarqué une potentiel source d'erreur dans notre conception. Si on veux écrire dans un registre avec deux instruction indépendante d'affilé, on peut ce retrouvé avec la première instruction qui écrit mais pas la deuxième car le registre est redevenue valide. Ce cas à été réglé si ces deux écriture se font depuis EXE et qu'elle dure qu'un cycle dans EXE. Cependant dans le cas de load qui ce suive où d'un load puis une instruction EXE, on perd en cohérence.
 - La première instruction va invalidé le registre
 - La deuxième va invalidé le registre et la première n'est pas encore exécuté
 - (cas 2 load) La première à fini et valide le registre
 - (cas 2 load) La deuxième à fini mais ne peux écrire car le registre est valide
 - (cas load puis EXE) La deuxième instruction fini avant la première et valide le registre
 - (cas load puis EXE) La première instruction fini mais ne peut écrire car le registre est valide
 
## Condition

Les condition sont juste un test sur les flags. Chaque instruction test à une condition et donc peux être jeté.

## Opération standard

 - implémenté
 - Il est possible de modifier le PC (registre 15) avec des opération standard (mov, add, sub, and, or, etc...). Ces instruction ce comporterons comme des branchement sans linkage.
 - Il peut-être intéressant de le désactivé tout simplement à la compilation ou dans le processeur (ajout d'une condition si `regop & wb & wb_adr = 0xF`).

### Comment faire

On envoie l'instruction dans EXE. Si le registre de destination est le pc alors on va dans BRANCH (reviens à faire un branchement).

### Information supplémentaire

Pour désactivé l'écriture dans le pc, on peut simplement mettre dans `cond` le fait qu'une opération standard ne peu avoir comme destination (sauf pour TST, TEQ, CMP et CMN) le pc.

## Branchement

 - implémenté. Test bench non fini.

### Delayed slot

 - on a 2 delayed slot ce qui peut avoir un impact à la compilation si ce n'est pas le comportement habituelle.
 - Cela peut-être modifié au coût d'un branchement plus long ( opération préalable de $\text{pc} - 8$, donc +2 cycles +3 si modification pc précédemment )
 - Le calcul de l'offset lors d'un branch est donc actuellement : $\text{pc instruction voulue} - \text{pc instruction saut} - \text{0x0C}$. 
 
### Comment faire

Un branchement qui passe la condition à deux instruction qui sont prête : une dans la fifo de IFETCH vers DECODE et une de DECODE vers IFETCH. Donc deux delayed slots. Quand on fait un branchement on fait une addition du pc avec l'offset. Dans le cas d'un branch et link, on fait un push dans la stack (registre 14) du pc (registre 15) avant de modifié le pc. Dans ce cas le registre 14 est décrémenté en pré-indexation de 4.

## Accès mémoire

 - implémenté. Test bench non fini.
 - On ne peut enchainer les loads au même registre du au conflit de validité présenté dans REG
 - Modification du regsitre pc obligatoirement activé (return)
 
### Comment faire

Nous passons simplement le registre en adresse en le registre à envoyé dans rdata3. Pour un load on passe juste le numéro de registre en write back pour mem.
Comme mentionné précedamenet il existe un problème avec le write back en registre.
 
## Accès mémoire multiple

 - implémentation non faite.
 
### Comment faire

Pour pouvoir exécuter les instructions d'accès multiple, LDM et STM, nous avons quelque idée. La suite d'opération est peux complexe : récuperer l'instruction et passé à l'état MTRANS. En même temps on stop l'arrivé d'instruction et l'envoie de d'adresse d'instruction. Les idées difère ici avec chaqun un registre. Dans le premier cas on a un registre qui accompagne la valeur du registre base Rn car si on ne write back pas alors c'est ce registre qui change à sa place. Il faudra donc attrapé la valeur de `exe_res` dans decode.vhdl pour mettre à jour ce registre. La seconde idée est de forcé le write back du registre de base, cependant nous avons un autre registre temporaire qui garde la valeur initial (initialisé dans RUN avant de passé à MTRANS) et l'écrit une fois l'instruction finie (en sortant de MTRANS).
Pour transferer les registres nous prennont la liste des registres à envoyer, ensuite on boucle jusqu'à avoir la liste vide (on reste dans MTRANS). Chaque tour nous prenons le plus petit registre dans la liste (qui n'est pas le registre base), on l'envoie dans EXE avec le registre base, la valeur de modification du registre base et le registre à envoyer. On fini le tours en enlevant le registre envoyé de la liste des registres. Pour la reception, on envoie juste le registre dans lequel écrire. Une fois tous les registres envoyé, si il reste le registre base à envoyé dans ce cas on l'envoie/reçoie.
Une fois fini, si on a utilisé la seconde méthode, on replace le registre base à son état initiale si et seulement si le bit 21 de l'instruction (write back) est à 0.

## Multiplication

 - implémentation non faite
 
### Comment faire

L'instruction de multiplication est simple en pratique. Dans la datasheet de ARMv2.3 il utilise l'algorithme de booth sur 8 bit. Celci reviens à faire un shift de l'emplacement d'un groupe de bit à 1 (+1) et de soustraire le shift du plus petit emplacement de ce groupe de bit à 1. On refait cette séquence pour tout les groupes de bit à 1.
Cependant l'algorithme de booth peut être complex à implémenter (Nous n'avons pas assé étudié l'algorithme). Nous allons donc proposer une méthode bien plus simple mais qui peux prendre jusqu'a ~32 cycle. Cette méthode reviens à faire pour chaque bit à 1 du multiplicateur un shift de son emplacement sur l'opérande. On somme tous cela et nous avons fait une multiplication. La multiplication avec accumulateur elle aussi peut suivre simplement avec une addition et donc une paire de cycles supplémentaire.
Si on test chaque bit cela sera fastidieux même si ça propose un temps constant. La version optimisé va donc chercher le premier 1 possible puis l'enlève de la liste. Ce qui est la raison pourquoi le temps peux varié entre 2 cycle (si multiplication par 0) et 34 cycles (32 pour chaque bit + 1 de la dernière opération + 1 pour envoyer dans les registres). Le pire cas est donc la multiplication avec des chiffres négatif et notament le -1. L'accumulation du résultat lui se fait dans un registre interne comme pour l'accumulation dans les accès mémoire multiple.

# Synthétisation

 - Pas encore faite. En attente d'un test bench suffisament exhaustif ???
 - Pas encore étudier la question.
