# Neovim + vimtex notes workflow

Paquetes requeridos: `neovim`, `vimtex`, `zathura`, `rofi`, `sxhkd`.

## Crear carpeta para el curso

Crear una carpeta en la que se almacenarán las notas de cada curso, también en carpetas. En este caso `$HOME/notes`. Dentro de esta carpeta también se hallará un enlace simbólico llamado `current-notes`, el cuál apuntará a la carpeta con las notas del curso en el que se quiera trabajar en un momento determinado. Sin embargo, no existirá tal carpeta, es decir, no se debe crear una carpeta real sino solo el enlace simbólico, el cuál cambiará dinámicamente. El archivo `.tex` de todos los cursos deben llamarse `main.tex` y se llena usando el snippet `math-notes`.

Se deben crear las carpetas para cada curso antes de usar los siguientes atajos de teclado. Éstas deberán contener el archivo `main.tex`, que se puede crear seleccionando el curso con `alt-s` y abriendo el archivo principal de las notas con `alt+n`. En la carpeta padre, es decir en la carpeta `notes`, deberán estar `pream.tex` y `eof.tex`, que se pueden copiar usando el binario `pream`. El archivo `lec_01.tex` también será incluido en `main.tex`, así que siempre habrá al menos una entrada en el menú.

## Estructura de las notas individuales

Todos los archivos de las clases tendrán el formato `lec_[num].tex` y deberán contener uno *y solo un* encabezado de la forma `*lecture{title}{date}` para extraer el tema visto en clase y mostarlo en el menú, además de la línea ```%%% title``` por si se quiere que el título de la sección y la entrada del menú sean diferentes, por ejemplo si el título en las notas contiene símbolos matemáticos o caracteres especiales que no puedan ser correctamente procesados por rofi. Los snippets `lec` y `les` insertarán dicha línea automáticamente.

Se puede cambiar `*lecture{title}{date}` a `*lecture{\texorpdfstring{title}{bookmark}}{date}` sin alterar el resultado en el menú, pues sólo se lee el segundo grupo de `{}`.

## Bibliografía

Para agregar una entrada a la bibliografía simmplemente abre el archivo `bibliography.bib` con la opción `Bibliografía` usando `alt-o`. Si no hay suficiente información para llenar los campos más importantes de forma precisa, se puede usar el snippet `foo` para anotar la referencia en el pie de página.

## Atajos

- Seleccionar curso: `alt+s`.
- Abrir `main.tex` en neovim `alt+n`.
- Compilar y abrir notas de una clase o varias en zathura `alt+p`.
- Abrir notas de una clase en neovim `alt+o`.
