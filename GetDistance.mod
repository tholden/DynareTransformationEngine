@#define Indices1 = IndicesArray[ ((Point1-1)*SpatialDimensions+1):(Point1*SpatialDimensions) ]
@#define Indices2 = IndicesArray[ ((Point2-1)*SpatialDimensions+1):(Point2*SpatialDimensions) ]
@#define Distance = "( 0 "
@#for Dimension in 1 : SpatialDimensions
    @#define DistanceTemp = "abs( " + Numbers[Indices1] + "/" + Numbers[SpatialPointsPerDimension+1] + " - " + Numbers[Indices2] + "/" + Numbers[SpatialPointsPerDimension+1] + " )"
    @#if SpatialShape[1] == "P"
        @#define Distance = Distance + " + " + DistanceTemp + " ^ ( " + SpatialNorm + " )"
    @#else
        @#define Distance = Distance + " + min( " + DistanceTemp + " , 1 - " + DistanceTemp + " ) ^ ( " + SpatialNorm + " )"
    @#endif
@#endfor
@#define Distance = Distance + " ) ^ ( 1 / ( " + SpatialNorm + " ) )"
