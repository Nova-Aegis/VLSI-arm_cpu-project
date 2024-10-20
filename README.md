# TODO

 - (fait) Comprendre le fonctionement de fifo.
 - Finir l'étage EXEC.
 - Faire un test bench pour l'étage EXEC.
 - Rajouter un peu de commentaire ici et là.
 - Poser des questions à Jean-Lou.
 - Faire les schéma des étage IFC, DECODE, MEMORY.

# QUESTIONNEMENT

## EXE

### Coment géré un cycle de gel?

idées
 - Ne pas activer `exe_wb` tant que `dex2exe_empty` = '1'. Problème la reception d'une nouvelle instruction ne veux pas dire que `dex2exe_empty` sera = '1'.
 - Activer `exe_wb` et croiser les doigts.
 - mettre dest à 0 (registre fixe?) tant que cycle de gel.

### Comment savoir si on a push dans la fifo de mem?

idée
 - reception de pop vennat de MEM???
 