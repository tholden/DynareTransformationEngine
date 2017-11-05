// Define the empty array for convenience.
// Dynare's preprocessor does not support [ ] for an empty array
@#define EmptyArray = [ "" ] - [ "" ]
@#define EmptyNumericArray = [ 0 ] - [ 0 ]

// Define an array of numbers
// Useful as Dynare's preprocessor does not support converting integers to strings
@#include "DefineNumbers.mod"

@#ifndef EndoVariables
    @#define EndoVariables = EmptyArray
@#endif
@#ifndef ExtraModelEquations
    @#define ExtraModelEquations = EmptyArray
@#endif
@#ifndef ExtraSteadyStateEquations
    @#define ExtraSteadyStateEquations = EmptyArray
@#endif
@#ifndef ShockProcesses
    @#define ShockProcesses = EmptyArray
@#endif
@#ifndef ExtraShockBlockLines
    @#define ExtraShockBlockLines = EmptyArray
@#endif

@#ifndef SpatialDimensions
    @#define SpatialDimensions = 0
@#endif
@#ifndef SpatialPointsPerDimension
    @#define SpatialPointsPerDimension = 1
@#endif
@#ifndef SpatialShockProcesses
    @#define SpatialShockProcesses = EmptyArray
@#endif

@#ifndef PureTrendEndoVariables
    @#define PureTrendEndoVariables = EmptyArray
@#endif
@#define UsingGrowthSyntax = 0
