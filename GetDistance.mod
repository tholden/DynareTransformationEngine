@#define Indices1 = IndicesArray[ ((Point1-1)*SpatialDimensions+1):(Point1*SpatialDimensions) ]
@#define Indices2 = IndicesArray[ ((Point2-1)*SpatialDimensions+1):(Point2*SpatialDimensions) ]
@#define Distance = "( ( 0 "
@#if SpatialShape[1] == "P"
    @#for Dimension in 1 : SpatialDimensions
        @#define DistanceTemp = "( " + Numbers[Indices1] + " - 1 ) / " + Numbers[SpatialPointsPerDimension] + " - ( " + Numbers[Indices2] + " - 1 ) / " + Numbers[SpatialPointsPerDimension]
        @#define Distance = Distance + " + abs( " + DistanceTemp + " ) ^ ( " + SpatialNorm + " )"
    @#endfor
    @#define Distance = Distance + " ) ^ ( 1 / ( " + SpatialNorm + " ) ) )"
@#else
    @#for Dimension in 1 : SpatialDimensions
        @#define DistanceTemp = "( " + Numbers[Indices1] + " - 1 ) / " + Numbers[SpatialPointsPerDimension] + " - ( " + Numbers[Indices2] + " - 1 ) / " + Numbers[SpatialPointsPerDimension]
        @#define Distance = Distance + " + min( abs( " + DistanceTemp + " ), min( abs( " + DistanceTemp + " + 1 ), abs( " + DistanceTemp + " - 1 ) ) ) ^ ( " + SpatialNorm + " )"
    @#endfor
    @#define Distance = Distance + " ) ^ ( 1 / ( " + SpatialNorm + " ) ) )"
@#endif
