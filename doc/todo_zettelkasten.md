- [X] Scripts para crear nueva carta, abrir cartas, eliminar carta y editar carta.
- [X] Agregar sistema de tags para editar y estudiar cartas.
- [X] Hacer una función en los snippets que escriba el nombre del archivo para etiquetar las fichas.
- [X] Desplegar en orden las cartas en los menús de rofi.
- [X] Completar preámbulo.
- [X] Diseñar la tabla de contenidos y hacer que las fichas aparezcan con su título ahí.
- [X] Script para intercambiar cartas.
- [ ] Revisar `create_card.sh` cuando el nodo es un nodo raíz (inserta la carta debajo del último nodo hermano en vez de el último descendiente del último nodo hermano).
- [ ] Create no modifica bien `main.tex`. Por ejemplo, si tienes las cartas `1 1a 1a1` y seleccionas `1` con `create.sh`, se insertará `1b` después de `1a` y no después de `1b` como debería.

Nota: el sistema solo puede ordenar un máximo de 10^8 fichas por nivel jerárquico, sin límite de niveles.

Nota: cuando se elimina una ficha y esta ha sido referenciada en el documento, se indica un vínculo roto en todas las fichas que la hayan citado, y se actualizan las citas de la ficha que ha tomado su lugar (la última de su familia).

Nota: el script para intercambiar puede intercambiar cualesquiera par de cartas y actualiza los respectivos enlaces en las demás. Para deshacer un cambio se intercambian de nuevo las cartas. Al intercambiar dos cartas raíz se intercambian todos sus descendientes.

Nota: si hay archivos en `cards` que no sigan el estándar para su numeración, los scripts pueden entrar en bucles infinitos.
