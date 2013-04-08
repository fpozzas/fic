import main
import modelo
import vista
import controlador
 
modelo1 = modelo.Modelo()
controlador1 = controlador.Controlador(modelo1)
vista1 = vista.Vista("simple.glade", 'window')
vista2 = vista.Vista("simple.glade", 'window')
controlador1.registrar_vista(vista1)
controlador1.registrar_vista(vista2)
main = main.Main()

main.start()


modelo1.nuevo(True)
modelo1.nuevo(False)

main.stop()
