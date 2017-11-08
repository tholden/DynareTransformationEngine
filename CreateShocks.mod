@#define NumShockProcesses = length( ShockProcesses ) / 6
@#for ShockIndex in 1 : NumShockProcesses
    @#define IndexIntoShockProcesses = ShockIndex * 6 - 5
    @#define VariableName = ShockProcesses[IndexIntoShockProcesses]
    @#define Minimum = ShockProcesses[IndexIntoShockProcesses+1]
    @#define Maximum = ShockProcesses[IndexIntoShockProcesses+2]
    @#define SteadyState = ShockProcesses[IndexIntoShockProcesses+3]
    @#define Rho = ShockProcesses[IndexIntoShockProcesses+4]
    @#define Sigma = ShockProcesses[IndexIntoShockProcesses+5]
    @#if UsingGrowthSyntax
        @#define EndoVariables = EndoVariables + [ VariableName, Minimum, Maximum, "1" ]
    @#else
        @#define EndoVariables = EndoVariables + [ VariableName, Minimum, Maximum ]
    @#endif
    @#include "InternalClassifyDeclare.mod"
    @#define ShockName = "epsilon_" + VariableName
    @#define TransformedSteadyState = "(" + TransformationPrefix + SteadyState + TrnasformationSuffix + ")"
    @#define ExtraModelEquations = ExtraModelEquations + [ FullVariableName + " = (1-(" + Rho + ")) * " + TransformedSteadyState + " + (" + Rho + ") * " + FullVariableName + "(-1)" + " + (" + Sigma + ") * " + ShockName + ";" ]
    @#define ExtraSteadyStateEquations = ExtraSteadyStateEquations + [ VariableName + "_ = " + SteadyState + ";" ]
    varexo @{ShockName};
    @#define ExtraShockBlockLines = ExtraShockBlockLines + [ "var " + ShockName + " = 1;" ]
@#endfor
@#define IndicesStringArray = EmptyStringArray
@#define IndicesArray = EmptyNumericArray
@#if SpatialDimensions > 0
    @#define Indices = EmptyNumericArray
    @#define Depth = 0
    @#include "CreateIndicesArray.mod"
@#endif
@#define SpatialNumPoints = length( IndicesStringArray )
@#define NumSpatialShockProcesses = length( SpatialShockProcesses ) / 9
@#for ShockIndex in 1 : NumSpatialShockProcesses
    @#define IndexIntoShockProcesses = ShockIndex * 9 - 8
    @#define VariableName = SpatialShockProcesses[IndexIntoShockProcesses]
    @#define Minimum = SpatialShockProcesses[IndexIntoShockProcesses+1]
    @#define Maximum = SpatialShockProcesses[IndexIntoShockProcesses+2]
    @#define SteadyState = SpatialShockProcesses[IndexIntoShockProcesses+3]
    @#define Rho = SpatialShockProcesses[IndexIntoShockProcesses+4]
    @#define Sigma = SpatialShockProcesses[IndexIntoShockProcesses+5]
    @#define DiffusionAmount = SpatialShockProcesses[IndexIntoShockProcesses+6]
    @#define DiffusionFunction = SpatialShockProcesses[IndexIntoShockProcesses+7]
    @#define ShockFunction = SpatialShockProcesses[IndexIntoShockProcesses+8]
    @#if UsingGrowthSyntax
        @#for Point in 1 : SpatialNumPoints
            @#define EndoVariables = EndoVariables + [ VariableName + IndicesStringArray[Point], Minimum, Maximum, "1" ]
        @#endfor
    @#else
        @#for Point in 1 : SpatialNumPoints
            @#define EndoVariables = EndoVariables + [ VariableName + IndicesStringArray[Point], Minimum, Maximum ]
        @#endfor
    @#endif
    @#include "InternalClassifyDeclare.mod"
    @#define ShockName = "epsilon_" + VariableName
    @#define TransformedSteadyState = "(" + TransformationPrefix + SteadyState + TrnasformationSuffix + ")"
    @#for Point1 in 1 : SpatialNumPoints
        @#define Integral = "( 0"
        @#define NewModelEquation = "#kappa_" + FullVariableName + "_" + IndicesStringArray[Point1] + " = ( 0"
        @#for Point2 in 1 : SpatialNumPoints
            @#include "GetDistance.mod"
            @#define InputString = DiffusionFunction
            @#define ReplacementString = Distance
            @#include "PerformReplacement.mod"
            @#define Integral = Integral + " + ( " + OutputString + " ) * " + FullVariableName + IndicesStringArray[Point2] + "(-1)"
            @#define NewModelEquation = NewModelEquation + " + ( " + OutputString + " )"
            @#if Point1 < Point2
                @#define InputString = ShockFunction
                @#include "PerformReplacement.mod"
                @#define ExtraShockBlockLines = ExtraShockBlockLines + [ "corr " + ShockName + IndicesStringArray[Point1] + ", " + ShockName + IndicesStringArray[Point2] + " = " + OutputString + ";" ]
            @#endif
        @#endfor
        @#define Integral = Integral + " ) / ( " + Numbers[SpatialPointsPerDimension] + " ^ " + Numbers[SpatialDimensions] + " )"
        @#define NewModelEquation = NewModelEquation + " ) / ( " + Numbers[SpatialPointsPerDimension] + " ^ " + Numbers[SpatialDimensions] + " );"
        @#define ExtraModelEquations = ExtraModelEquations + [ NewModelEquation ]
        @#define ExtraModelEquations = ExtraModelEquations + [ FullVariableName + IndicesStringArray[Point1] + " = (1-(" + Rho + ")) * " + TransformedSteadyState + " + (" + Rho + ") * ( (1-(" + DiffusionAmount + ")) * " + FullVariableName + IndicesStringArray[Point1] + "(-1) + (" + DiffusionAmount + ") * ( " + Integral + " ) / kappa_" + FullVariableName + "_" + IndicesStringArray[Point1] + " ) " + " + (" + Sigma + ") * " + ShockName + IndicesStringArray[Point1] + ";" ]
        @#define ExtraSteadyStateEquations = ExtraSteadyStateEquations + [ VariableName + IndicesStringArray[Point1] + "_ = " + SteadyState + ";" ]
        varexo @{ShockName + IndicesStringArray[Point1]};
        @#define ExtraShockBlockLines = ExtraShockBlockLines + [ "var " + ShockName + IndicesStringArray[Point1] + " = 1;" ]
    @#endfor
@#endfor
