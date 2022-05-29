# fpga-multiplicador-4bits
Multiplicador por sumas sucesivas, con entrada de dos numeros de 4 bits y como resultado un numero de 8 bits.
El multiplicador realiza la operación por medio de sumas sucesivas: Los números A y B pasan a registros de desplazamiento donde se toma el bit menos significativo de la entrada A y si esa bit en un 0 se indica que se debe hacer un corrimiento tanto de la entrada B como de la entrada A, y si el bit es un 1 pasa el valor de B a un sumador completo para que lo sume con el valor almacenado en un registro acumulador, y al terminar la suma se pasa el resultado al registro acumulador, luego se hace un corrimiento de los números. La operación de multiplicación termina cuando la entrada A tenga todos sus bits en 0.

El multiplicador tiene los siguientes puertos:
- Entradas: A y B, que representan los números, de tipo bit vector de 4 bits; STB que arranca el
multiplicador, de tipo bit; y una señal de clock de tipo bit.
- Salida: Done, que indica que la operación termino, de tipo bit; y Result, que guarda el resultado
de la multiplicación, de tipo bit vector de 8 bits.

Se usan los siguientes componentes para armar el multiplicador:
- Un sumador completo de 8 bits (Adder8).
- Dos latch de 8 bits, uno para hacer de registro acumulador (ACC) y otro para almacenar el
resultado final de la operación (RES).
- Una máquina de estado de tipo Moore para administrar la operación.
- Dos registros de desplazamiento para para hacer un desplazamiento de los números (SRA para
la entrada A y SRB para la entrada B).
