
## Concurrencia en Haskell

Veamos un poco antes de empezar con algo un poco más complejo sobre lo que es paralelismo y concurrencia en haskell:

- Paralelismo significa ejecutar un programa Haskell en varios procesadores, con el objetivo de mejorar el rendimiento. Idealmente, esto debe hacerse de forma invisible, y sin cambios semánticos.

- Concurrencia significa implementar un programa mediante el uso de múltiples hilos de I / O-escénicas. Mientras que un programa Haskell concurrente puede ejecutarse en una máquina paralela, el objetivo principal de utilizar la concurrencia no es para obtener un rendimiento, sino más bien porque esa es la manera más sencilla y directa para escribir el programa. Dado que los hilos realizan E / S, la semántica del programa es necesariamente no determinista.

GHC es compatible tanto con la concurrencia y paralelismo.


### par & seq

Los programas comunes de un único subproceso Haskell no se beneficiarán de paralelismo SMP permite por sí solo: se debe exponer el paralelismo con el compilador. Una forma de hacerlo es mediante forkeo de hilos utilizando Haskell concurrente, aunque el mecanismo más simple para extraer el paralelismo de código puro es utilizar el par combinador, que está estrechamente relacionada con, y utiliza a menudo con, SEQ.

Si vemos el prototipo de par y seq

~~~haskell
infixr 0 `par`
infixr 1` pseq`

par :: a -> b -> b
seq :: a -> b -> b
PSEQ :: a -> b -> b
~~~

par es una funcion que permite que pueda empezarse una computación en paralalo, y se lo conoce como spark (chispa(?)), seq por el otro lado fuerza a que una computación sea ejecutada (evitando la lazy evaluation, cambio de lazy a eager)

por ej

~~~haskell
(x `par` y)
~~~

esta chispa evalua x, y regresa 'y'. Estas chispas se ponen en el stack para su ejecución en orden FIFO, pero no inmediantamente. i el tiempo de ejecución detecta que hay una inactividad de la CPU, entonces puede convertir una chispa en un hilo real, y ejecutar el nuevo hilo en la inactividad de la CPU. De esta manera el paralelismo disponible se extiende entre las CPUs reales.

Bien, veamos el ejemplo de fibonacci por ej

~~~haskell
import Control.Parallel

nfib :: Int -> Int
nfib n | n <= 1 = 1
       | otherwise = par n1 (pseq n2 (n1 + n2 + 1))
                     where n1 = nfib (n-1)
                           n2 = nfib (n-2)
~~~


Para valores de n mayores que 1, se utiliza el par de provocar un hilo para evaluar NFIB (n-1) , y luego usamos PSEQ para forzar el hilo de los padres para evaluar NFIB (n-2) antes de pasar a sumar estos dos subexpresiones. En este enfoque de divide y vencerás, sólo provocar un nuevo hilo para una rama de la computación (dejando a los padres para evaluar la otra rama). Además, hay que utilizar PSEQ para asegurar que el padre evaluará n2 antes n1 en la expresión (n1 + n2 + 1) . No es suficiente para cambiar el orden de la expresión como (n2 + n1 + 1) , porque el compilador puede no generar código para evaluar los sumandos de izquierda a derecha.

Ahora bien, veamos que usamos pseq y no seq, si bien son casi equivalentes, difieran en su comportamiento en tiempo de ejecución, seq puede evaluar sus argumentos en cualquier orden, pero PSEQ se requiere para evaluar su primer argumento antes de su segundo, lo que hace que sea más adecuado para controlar el orden de evaluación en conjunción con el par.
