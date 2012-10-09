/**
 * Esta clase contiene un método estático para calcular
 * el factor de ramificación efectivo, como se describe en 
 * el libro de Russell y Norvig (página 106).
 */
public class BranchingFactor {

    /** Precision con la que se calcula la respuesta. */
    private static final double PRECISION = 0.00001;

    /*
     * Este método estático calcula el factor de ramificación de una búsqueda
     * en la que se han expandido num_expanded nodos, y se ha alcanzado una 
     * solución a profundidad depth.  Note que depth debe ser no negativo, y 		
     * num_expanded debe ser al menos depth+1 (en otro caso se obtiene 
     * IllegalArgumentException).
     */
    public static double compute(int num_expanded,
				 int depth) {
	if (num_expanded < depth + 1)
	    throw new IllegalArgumentException("num_expanded debe ser al menos depth + 1");

	if (depth < 0)
	    throw new IllegalArgumentException("depth debe ser no negativo");

	double n = num_expanded;

	double b_lo = 1.;
	double f_lo = 1. + depth;
	double b_hi = b_lo;
	double f_hi = f_lo;

	while (f_hi < n) {
	    b_hi *= 2.;
	    f_hi = geo_sum(b_hi, depth);
	}

	while (b_hi - b_lo > PRECISION) {
	    double b_mid = (b_hi + b_lo) * 0.5;
	    double f_mid = geo_sum(b_mid, depth);

	    if (f_mid > n) {
		b_hi = b_mid;
		f_hi = f_mid;
	    } else {
		b_lo = b_mid;
		f_lo = f_mid;
	    }
	}

	return b_lo;
    }

    private static double geo_sum(double b, int d) {
	double s = 1.;

	for (int i = 0; i < d; i++) {
	    s = s * b + 1.;
	}

	return s;
    }
}

