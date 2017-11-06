// Define the empty array for convenience.
// Dynare's preprocessor does not support [ ] for an empty array
@#define EmptyStringArray = [ "" ] - [ "" ]
@#define EmptyNumericArray = [ 0 ] - [ 0 ]

// Define an array of numbers
// Useful as Dynare's preprocessor does not support converting integers to strings
@#include "DefineNumbers.mod"

@#ifndef EndoVariables
    @#define EndoVariables = EmptyStringArray
@#endif
@#ifndef ExtraModelEquations
    @#define ExtraModelEquations = EmptyStringArray
@#endif
@#ifndef ExtraSteadyStateEquations
    @#define ExtraSteadyStateEquations = EmptyStringArray
@#endif
@#ifndef ShockProcesses
    @#define ShockProcesses = EmptyStringArray
@#endif
@#ifndef ExtraShockBlockLines
    @#define ExtraShockBlockLines = EmptyStringArray
@#endif

@#ifndef SpatialDimensions
    @#define SpatialDimensions = 0
@#endif
@#ifndef SpatialPointsPerDimension
    @#define SpatialPointsPerDimension = 128
@#endif
@#ifndef SpatialShape
    @#define SpatialShape = "Torus"
    // The other supported option is "Plane"
@#endif
@#ifndef SpatialNorm
    @#define SpatialNorm = "2"
@#endif
@#ifndef SpatialShockProcesses
    @#define SpatialShockProcesses = EmptyStringArray
@#endif

@#ifndef PureTrendEndoVariables
    @#define PureTrendEndoVariables = EmptyStringArray
@#endif
@#ifndef UsingGrowthSyntax
    @#define UsingGrowthSyntax = 0
@#endif
