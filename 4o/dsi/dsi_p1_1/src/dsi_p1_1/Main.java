package dsi_p1_1;

import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        Alarma al1= new AlMov("AlMov01",false,1);
        Alarma al2= new AlTemp("AlTemp02",false,123);
        Alarma al3= new AlMov("AlMov03",false,166);
        Alarma al4= new AlMov("AlMov04",true,15);
        Alarma al5= new AlMov("AlMov05",false,19);
        Alarma al6= new AlTemp("AlTemp06",true,18);
        Centralita cent = new Centralita("C0","hi");
        cent.autenticar("hi");
        cent.agregarAlarma(al1);
        cent.agregarAlarma(al2);
        cent.agregarAlarma(al3);
        cent.agregarAlarma(al4);
        cent.agregarAlarma(al5);
        cent.agregarAlarma(al6);
        EspecEstado ss = new EspecEstado(true);
        System.out.println("Activas (ini)= "+cent.buscar(ss));
        al3.probar();
        System.out.println("Activas (prueba al3)= "+cent.buscar(ss));
        al3.reiniciar();
        System.out.println("Activas (reinicio al3)= "+cent.buscar(ss));
        cent.probar();
        System.out.println("Activas (prueba todas)= "+cent.buscar(ss));
        cent.reiniciar();
        System.out.println("Activas (reinicio todas) = "+cent.buscar(ss));
        al2.probar();
        System.out.println("Activas (prueba al2) = "+cent.buscar(ss));
        al6.reiniciar();
        System.out.println("Activas (reinicio al6)= "+cent.buscar(ss));
        al6.probar();
        System.out.println("Activas (pruebo al6) = "+cent.buscar(ss));
        Centralita c1 = new Centralita("C1","hola");
        c1.autenticar("hola");
        c1.agregarAlarma(al1);
        c1.agregarAlarma(al2);
        Etiqueta e1 = new Etiqueta("Modelo","v123");
        al1.agregarEtiqueta(e1);
        al1.probar();
        Etiqueta e2 = new Etiqueta("Modelo","v122");
        al2.agregarEtiqueta(e2);
        al2.reiniciar();
        ArrayList<Etiqueta> aLe1 = new ArrayList<Etiqueta>();
        aLe1.add(e1);
        ArrayList<Etiqueta> aLe2 = new ArrayList<Etiqueta>();
        aLe2.add(e2);
        EspecEtiquetas spec1 = new EspecEtiquetas(aLe1);
        EspecEtiquetas spec2 = new EspecEtiquetas(aLe2);
        System.out.println("Buscar e1 = "+c1.buscar(spec1));
        System.out.println("Buscar e2 = "+c1.buscar(spec2));
        EspecEstado spectrue = new EspecEstado(true);
        EspecEstado specfalse = new EspecEstado(false);
        System.out.println("Buscar true = "+c1.buscar(spectrue));
        System.out.println("Buscar false = "+c1.buscar(specfalse));
    }

}