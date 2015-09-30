package decodes.tsdb.algo;

import java.util.Date;

import ilex.var.NamedVariableList;
import ilex.var.NamedVariable;
import decodes.tsdb.DbAlgorithmExecutive;
import decodes.tsdb.DbCompException;
import decodes.tsdb.DbIoException;
import decodes.tsdb.VarFlags;

//AW:IMPORTS
//AW:IMPORTS_END

//AW:JAVADOC
/**
Takes up to 5 input values labeled input1 ... input5. Multiplies
them by coefficients supplied in properties coeff1 ... coeff5.
Adds them together and produces a single output labeled 'output'.
Values not assigned by computation are ignored.
All coefficients default to 1.0 if not supplied.
 */
//AW:JAVADOC_END
public class ScalerAdder extends decodes.tsdb.algo.AW_AlgorithmBase
{
//AW:INPUTS
	double input1;	//AW:TYPECODE=i
	double input2;	//AW:TYPECODE=i
	double input3;	//AW:TYPECODE=i
	double input4;	//AW:TYPECODE=i
	double input5;	//AW:TYPECODE=i
	String _inputNames[] = { "input1", "input2", "input3", "input4", "input5" };
//AW:INPUTS_END

//AW:LOCALVARS

//AW:LOCALVARS_END

//AW:OUTPUTS
	NamedVariable output = new NamedVariable("output", 0);
	String _outputNames[] = { "output" };
//AW:OUTPUTS_END

//AW:PROPERTIES
	double coeff1 = 1.0;
	double coeff2 = 1.0;
	double coeff3 = 1.0;
	double coeff4 = 1.0;
	double coeff5 = 1.0;
	String input1_MISSING = "ignore";
	String input2_MISSING = "ignore";
	String input3_MISSING = "ignore";
	String input4_MISSING = "ignore";
	String input5_MISSING = "ignore";
	String _propertyNames[] = { "coeff1", "coeff2", "coeff3", "coeff4", "coeff5", "input1_MISSING", "input2_MISSING", "input3_MISSING", "input4_MISSING", "input5_MISSING" };
//AW:PROPERTIES_END

	// Allow javac to generate a no-args constructor.

	/**
	 * Algorithm-specific initialization provided by the subclass.
	 */
	protected void initAWAlgorithm( )
	{
//AW:INIT
		_awAlgoType = AWAlgoType.TIME_SLICE;
//AW:INIT_END

//AW:USERINIT
//AW:USERINIT_END
	}
	
	/**
	 * This method is called once before iterating all time slices.
	 */
	protected void beforeTimeSlices()
	{
//AW:BEFORE_TIMESLICES
//AW:BEFORE_TIMESLICES_END
	}

	/**
	 * Do the algorithm for a single time slice.
	 * AW will fill in user-supplied code here.
	 * Base class will set inputs prior to calling this method.
	 * User code should call one of the setOutput methods for a time-slice
	 * output variable.
	 *
	 * @throws DbCompException (or subclass thereof) if execution of this
	 *        algorithm is to be aborted.
	 */
	protected void doAWTimeSlice()
		throws DbCompException
	{
//AW:TIMESLICE
		double tally = 0.0;
		if (!isMissing(input1))
			tally += (input1 * coeff1);
		if (!isMissing(input2))
			tally += (input2 * coeff2);
		if (!isMissing(input3))
			tally += (input3 * coeff3);
		if (!isMissing(input4))
			tally += (input4 * coeff4);
		if (!isMissing(input5))
			tally += (input5 * coeff5);
debug3("doAWTimeSlice input1=" + input1 + ", coeff1=" + coeff1
+", input2=" + input2 + ", coeff2=" + coeff2 + ", tally=" + tally);
		setOutput(output, tally);
//AW:TIMESLICE_END
	}

	/**
	 * This method is called once after iterating all time slices.
	 */
	protected void afterTimeSlices()
	{
//AW:AFTER_TIMESLICES
//AW:AFTER_TIMESLICES_END
	}

	/**
	 * Required method returns a list of all input time series names.
	 */
	public String[] getInputNames()
	{
		return _inputNames;
	}

	/**
	 * Required method returns a list of all output time series names.
	 */
	public String[] getOutputNames()
	{
		return _outputNames;
	}

	/**
	 * Required method returns a list of properties that have meaning to
	 * this algorithm.
	 */
	public String[] getPropertyNames()
	{
		return _propertyNames;
	}
}
