@#include "Initialize.mod"

// Options determining the spatial topology
@#define SpatialDimensions = 1
@#define SpatialShape = "Torus"
// The other option is "Plane"

@#if SpatialDimensions == 1
    @#define SpatialNorm = "1"
    @#define SpatialPointsPerDimension = 100
@#else
    @#define SpatialNorm = "2"
    @#define SpatialPointsPerDimension = 10
@#endif

// This is an option specific to this file. Setting it to 1 turns on spatial diffusion of technology here.
@#define WithDiffusion = 1

@#if WithDiffusion
    @#if SpatialShape[1] == "P"
        @#define SpatialDiffusionShockProcesses = SpatialDiffusionShockProcesses + [ "A", "0", "Inf", "1", "rho", "sigma", "chi", "exp(-eta*@)#", "exp(-zeta*@)#" ]
        // In order, these are the variable name, its minimum, its maximum, its steady-state, its persistence, its standard deviation, the amount of diffusion, the function governing diffusion (with "@" representing the input distance, and "#" at the end of the string) and the function governing correlation in the shock (with "@" representing the input distance, and "#" at the end of the string)
    @#else
        @#define SpatialDiffusionShockProcesses = SpatialDiffusionShockProcesses + [ "A", "0", "Inf", "1", "rho", "sigma", "chi", "(exp(-eta*@+eta*dBar)+exp(eta*@-eta*dBar))/(exp(eta*dBar)+exp(-eta*dBar))#", "(exp(-zeta*@+zeta*dBar)+exp(zeta*@-zeta*dBar))/(exp(zeta*dBar)+exp(-zeta*dBar))#" ]
        // In order, these are the variable name, its minimum, its maximum, its steady-state, its persistence, its standard deviation, the amount of diffusion, the function governing diffusion (with "@" representing the input distance, and "#" at the end of the string) and the function governing correlation in the shock (with "@" representing the input distance, and "#" at the end of the string)
    @#endif
@#else
    @#if SpatialShape[1] == "P"
        @#define SpatialShockProcesses = SpatialShockProcesses + [ "A", "0", "Inf", "1", "rho", "sigma", "exp(-zeta*@)#" ]
        // In order, these are the variable name, its minimum, its maximum, its steady-state, its persistence, its standard deviation, and the function governing correlation in the shock (with "@" representing the input distance, and "#" at the end of the string)
    @#else
        @#define SpatialShockProcesses = SpatialShockProcesses + [ "A", "0", "Inf", "1", "rho", "sigma", "(exp(-zeta*@+zeta*dBar)+exp(zeta*@-zeta*dBar))/(exp(zeta*dBar)+exp(-zeta*dBar))#" ]
        // In order, these are the variable name, its minimum, its maximum, its steady-state, its persistence, its standard deviation, and the function governing correlation in the shock (with "@" representing the input distance, and "#" at the end of the string)
    @#endif
@#endif

@#include "CreateShocks.mod"

@#define EndoVariables = EndoVariables + [ "R", "0", "Inf" ]

@#for Point in 1 : SpatialNumPoints
    @#define Point = IndicesStringArray[Point]
    @#define EndoVariables = EndoVariables + [ "C" + Point, "0", "Inf" ]
    @#define EndoVariables = EndoVariables + [ "B" + Point, "-Inf", "Inf" ]
@#endfor

@#include "ClassifyDeclare.mod"

parameters alpha beta nu rho chi eta zeta sigma phi dBar;

alpha = 0.3;
beta = 0.99;
nu = 2;
rho = 0.95;
chi = 0.5;
eta = 8;
zeta = 4;
sigma = 0.02;
phi = 1e-6;

@#if SpatialShape[1] == "P"
    dBar = ( @{SpatialDimensions} ) ^ ( 1 / ( @{SpatialNorm} ) );
@#else
    dBar = ( @{SpatialDimensions} * ( 0.5 ^ ( @{SpatialNorm} ) ) ) ^ ( 1 / ( @{SpatialNorm} ) );
@#endif

model;
    @#include "InsertNewModelEquations.mod"

    @#for Point in 1 : SpatialNumPoints
        @#define Point = IndicesStringArray[Point]
        #L@{Point} = ( ( 1 - alpha ) * A@{Point} ^ alpha / C@{Point} ) ^ ( 1 / ( alpha + nu ) );
        #Y@{Point} = A@{Point} ^ alpha * L@{Point} ^ ( 1 - alpha );
        1 + phi * B = beta * R * C@{Point} / C@{Point}_LEAD;
        C@{Point} + B@{Point} + phi / 2 * B@{Point} ^ 2 = Y@{Point} + R_LAG * B@{Point}_LAG;
    @#endfor

    #B = ( 0
    @#for Point in 1 : SpatialNumPoints
        @#define Point = IndicesStringArray[Point]
        + B@{Point}
    @#endfor
        ) / @{SpatialNumPoints};

    B = 0;
end;

shocks;
    @#include "InsertNewShockBlockLines.mod"
end;

steady_state_model;
    R_ = 1 / beta;
    @#for Point in 1 : SpatialNumPoints
        @#define Point = IndicesStringArray[Point]
        C@{Point}_ = ( 1 - alpha ) ^ ( ( 1 - alpha ) / ( 1 + nu ) );
        B@{Point}_ = 0;
    @#endfor
    @#include "InsertNewSteadyStateEquations.mod"
end;

steady;
//check;

stoch_simul( order = 1, irf = 0, periods = 0, nocorr, nofunctions ) log_R;
