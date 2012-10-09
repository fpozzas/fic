package dsi_p1_2;

import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ZGenerico z1 = new Zona("Cero",false);  
        ZGenerico z2 = new Zona("Uno",false);
        ZGenerico z3 = new Zona("Dos",false);
        ZGenerico al1= new AlMov("AlMov01",false,1);
        ZGenerico al2= new AlTemp("AlTemp02",false,123);
        ZGenerico al3= new AlMov("AlMov03",false,166);
        ZGenerico al4= new AlMov("AlMov03",true,15);
        ZGenerico al5= new AlMov("AlMov03",false,19);
        ZGenerico al6= new AlTemp("AlTemp03",true,18);
         System.out.printf(z1.id()+"\n");
         al1.probar();
         System.out.printf(z1.id()+"\n");
         z1.add(al1);
         z1.add(z2);
         z2.add(al2);
         z2.add(al3);
         System.out.printf(z2.id()+"\n");
         al3.probar(); 
         System.out.printf(z2.id()+"\n");
         System.out.printf(z1.id()+"\n");
         al3.reiniciar();
         System.out.printf(z1.id()+"\n");
         al2.probar();
         System.out.printf(z1.id()+"\n");
         z1.reiniciar();
         System.out.printf(z1.id()+"\n");
         z1.add(z3);
         z2.add(z3);
         z3.add(al4);
         z3.add(al5);
         z3.add(al6);
         System.out.printf(z1.id()+"\n");
         z1.add(al6);
         System.out.printf(z1.id()+"\n");
         al6.reiniciar();
         System.out.printf(z1.id()+"\n");
         al6.probar();
         System.out.printf(z1.id()+"\n");
         z1.probar();
         System.out.printf(z1.id()+"\n");
         z3.reiniciar(); 
         System.out.printf(z1.id()+"\n");
         
         Centralita c1 = new Centralita("C1","hola");
         c1.autenticar("hola");
         c1.agregarAlarma(z1);
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