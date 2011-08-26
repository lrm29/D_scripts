// Linear Interpolator
// Laurence R. McGlashan (lrm29@cam.ac.uk) 2011

import std.stdio;
import std.range;
import std.algorithm;
import std.string;
import std.conv;

class LinearInterpolator(X, Y)
{
private:

    //! The data to use for interpolation
    double[double] mData;
    double[] sortedKey;

public:

    //! Initialise with X and Y given as vectors. They will be paired up by the constructor.
    this(in X[] positionValues, in Y[] dataValues)
    {
    	// Check lengths of vectors are equal.
        assert
        (
            positionValues.length == dataValues.length,
            text("LinearInterpolator: positionValues (length ",positionValues.length,
                 ") and data values (length ",dataValues.length,")are not the same length.")
        );

        // Populate mData
        foreach (i; 0 .. positionValues.length) 
            this.mData[positionValues[i]] = dataValues[i];

        this.sortedKey = mData.keys.sort;
    }

    //! Get an interpolated value
    Y interpolate(in X x)
    {
        Y result;
        
        auto a = assumeSorted(sortedKey);
        auto itLower = a.lowerBound(x);

        if(itLower.length == mData.length) {
        // At or beyond the upper end of the data
            return mData[sortedKey[itLower.length-1]];
        }
        else if(itLower.length == 0) {
        // At or before the lower end of the data
            return mData[sortedKey[itLower.length]];
        }
        else {
            // Linear interpolation
            const X xLeft = sortedKey[itLower.length-1];
            const X xRight = sortedKey[itLower.length];
            const X distance = xRight - xLeft;

            // Calculate the interpolation weights
            const X leftWeight = (xRight - x) / distance;
            const X rightWeight = (x - xLeft) / distance;

            // Do the interpolation
            result = leftWeight *  mData[sortedKey[itLower.length-1]] 
                     + rightWeight * mData[sortedKey[itLower.length]];
        }
                  
        return result;
    }

    unittest
    {
        double[] x = [1,2,3,5,6,4];
        double[] y = [10.0,20.0,30.0,50.0,60, 40.0];
        
        auto li = new LinearInterpolator!(double,double)(x,y);
        
        assert(li.interpolate(5.5)==55);
        assert(li.interpolate(1)==10);
        assert(li.interpolate(6)==60);
    }

}

