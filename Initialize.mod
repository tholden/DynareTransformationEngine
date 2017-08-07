// Define the empty array for convenience.
// Dynare's preprocessor does not support [ ] for an empty array
@#define EmptyArray = [ "" ] - [ "" ]
@#ifndef EndoVariables
    @#define EndoVariables = EmptyArray
@#endif
@#ifndef PureTrendEndoVariables
    @#define PureTrendEndoVariables = EmptyArray
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
@#define UsingGrowthSyntax = 0
