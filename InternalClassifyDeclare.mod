@#if Minimum == Maximum
    @#error "A variable cannot have identical bounds"
@#endif
@#if Minimum == "-Inf"
    @#if Maximum == "Inf" || Maximum == "+Inf"
        @#define VariableNamePrefix = "level"
        @#define InverseTransformationPrefix = ""
        @#define InverseTransformationSuffix = ""
        @#define TransformationPrefix = ""
        @#define TrnasformationSuffix = ""
    @#else
        @#if Maximum == "0"
            @#define VariableNamePrefix = "MlogM"
            @#define InverseTransformationPrefix = "(-exp(-("
            @#define InverseTransformationSuffix = ")))"
            @#define TransformationPrefix = "(-log(-("
            @#define TrnasformationSuffix = ")))"
        @#else
            @#define VariableNamePrefix = "MlogT"
            @#define InverseTransformationPrefix = "((" + Maximum + ")-exp(-("
            @#define InverseTransformationSuffix = ")))"
            @#define TransformationPrefix = "(-log((" + Maximum + ")-("
            @#define TrnasformationSuffix = ")))"
        @#endif
    @#endif
@#else
    @#if Maximum == "Inf" || Maximum == "+Inf"
        @#if Minimum == "0"
            @#define VariableNamePrefix = "log"
            @#define InverseTransformationPrefix = "(exp("
            @#define InverseTransformationSuffix = "))"
            @#define TransformationPrefix = "(log("
            @#define TrnasformationSuffix = "))"
        @#else
            @#define VariableNamePrefix = "logT"
            @#define InverseTransformationPrefix = "((" + Minimum + ")+exp("
            @#define InverseTransformationSuffix = "))"
            @#define TransformationPrefix = "(log(("
            @#define TrnasformationSuffix = ")-(" + Minimum + ")))"
        @#endif
    @#else
        @#if Minimum == "0"
            @#if Maximum == "1"
                @#define VariableNamePrefix = "logit"
                @#define InverseTransformationPrefix = "(1/(1+exp(-("
                @#define InverseTransformationSuffix = "))))"
                @#define TransformationPrefix = "(-log(1/("
                @#define TrnasformationSuffix = ")-1))"
            @#else
                @#define VariableNamePrefix = "logitT"
                @#define InverseTransformationPrefix = "((" + Maximum + ")/(1+exp(-("
                @#define InverseTransformationSuffix = "))))"
                @#define TransformationPrefix = "(-log((" + Maximum + ")/("
                @#define TrnasformationSuffix = ")-1))"
            @#endif
        @#else
            @#if Maximum == "0"
                @#if Minimum == -1
                    @#define VariableNamePrefix = "MlogitM"
                    @#define InverseTransformationPrefix = "(-1/(1+exp("
                    @#define InverseTransformationSuffix = ")))"
                    @#define TransformationPrefix = "(log(1/("
                    @#define TrnasformationSuffix = ")-1))"
                @#else
                    @#define VariableNamePrefix = "MlogitT"
                    @#define InverseTransformationPrefix = "((" + Minimum + ")/(1+exp("
                    @#define InverseTransformationSuffix = ")))"
                    @#define TransformationPrefix = "(log((" + Minimum + ")/("
                    @#define TrnasformationSuffix = ")-1))"
                @#endif
            @#else
                @#define VariableNamePrefix = "logitT"
                @#define InverseTransformationPrefix = "((" + Minimum + ")+(((" + Maximum + ")-(" + Minimum + "))/(1+exp(-("
                @#define InverseTransformationSuffix = ")))))"
                @#define TransformationPrefix = "(-log(((" + Maximum + ")-(" + Minimum + "))/(("
                @#define TrnasformationSuffix = ")-(" + Minimum + "))-1))"
            @#endif
        @#endif
    @#endif
@#endif
@#define FullVariableName = VariableNamePrefix + "_" + VariableName
