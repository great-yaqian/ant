;; for dejoa:

connectivity = list(
list("M5" "RDV" "RDL"    )
list("M4" "V4"  "M5"       )
list("M3" "V3"  "M4"       )
list("M2" "V2"  "M3"       )
list("M1" "V1"  "M2"       )
list("TCP" "CT" "M1"      )
list("M0U" "CT" "M1"      )
list("MT2" "PCU" "M0U"   )
list("M0C" "PCU" "M0U"   )
;list("AT4" "PC1" "M0C"   )
list("AT4" "PC1" "MT2"   )
;list("PG" "PC2" "M0C"    )
list("PG" "PC2" "MT2"    )
)

PD = list(
    list(list("AT4" "NCH") list("NSD" "drawing"))
    list(list("AT4" "PCH") list("PSD" "drawing"))
    )

GATE = list(
    list(list("AT4" "NCH") list("PG" "NCH"))
    list(list("AT4" "PCH") list("PG" "PCH"))
    )

Vias = list( "RDV" "V4" "V3" "V2" "V1" "CT" "PCU" "PC1" "PC2" )

grid = 0.00025

    libName         =   "ANT_QA_Pcell"
    cellName        =   "MaxAreaRatio"
    cellview        =   "maskLayout"

;procedure(createMaxAreaRatio
    ;( @key
    ;(libName            "ANT_QA_Pcell")
    ;(cellName           "MaxAreaRatio")
    ;(cellview           "maskLayout")
    ;(Obj1isVia          nil           )
    ;(Obj1Layer          "PG_drawing")
    ;(Obj1isCumulative          nil           )
    ;(GateConnectedPD    nil )
    ;)

    pcDefinePCell( list(ddGetObj(libName) cellName "layout" cellview)
        (;parameters:
            ;(libName           string   "ANT_QA_Pcell")
            ;(cellName          string   "MaxAreaRatio")
            ;(cellview          string   "maskLayout")
            ;(Obj1isVia         boolean   nil           )
            (Obj1Layer         string    "PG_drawing")
            (Obj1isCumulative  boolean       nil           )
            (GateConnectedPD   boolean       nil )
            (Ratio             int          200 )
            (PDarea            int          1 )
            )
        
        layer1 = parseString(Obj1Layer, "_")
        layer_all = geFindLayerPath("PG" car(layer1) connectivity)
        ;passedLayers = myButlast(layer_all)

        PGgroup = dbCreateGroup( pcCellView "PGgroup" list("set" "ordered"))
        
        gate_y = 1
        gate_x = 1
        gate_l = 0.5
        gate_w = 2
        
        firstPG1 = dbCreateRect(pcCellView cadr(car(GATE)) list(gate_x:gate_y gate_x+gate_l:gate_y+gate_w))
        firstPG12 = dbCreateRect(pcCellView car(car(GATE)) list(gate_x-gate_l:gate_y+gate_l gate_x+gate_l*2:gate_y+gate_w-gate_l))

        if(!Obj1isCumulative  && !memq(layer1 Vias) ;&& "PG"!=layer1
                    then for(x 0  length(layer_all)-2
                            orientX = gate_x + x
                            dbCreateRect(pcCellView list(nth(x layer_all) "drawing") list(orientX:0.5 orientX+2:1.5))

                            );for
          );if
        
        )

   ;     )
            
; 获取除最后一个元素外的所有元素
procedure(myButlast(lst)
    if(!lst then
        nil ; 空列表返回 nil
    else
        reverse(cdr(reverse(lst))) ; 反转两次
    )
)


let( ( cellId cdfId)
    cellId = ddGetObj(libName cellName)
    if( !cellId
        printf("error\n")
        ;error("Could'nt find cell %s." cellName)
        )
    when(cdfId = cdfGetBaseCellCDF(cellId)
        cdfDeleteCDF(cdfId)
        )
    cdfId = cdfCreateBaseCellCDF(cellId)

    cdfCreateParam(cdfId
        ?name       "Obj1Layer"
        ?prompt     "Obj1Layer"
        ?defValue   "PG_drawing"
        ?type       "string")

    cdfCreateParam(cdfId
        ?name       "Obj1isCumulative"
        ?prompt     "Obj1isCumulative"
        ?defValue   nil
        ?type       "boolean")

    cdfCreateParam(cdfId
        ?name       "GateConnectedPD"
        ?prompt     "GateConnectedPD"
        ?defValue   nil
        ?type       "boolean")
  
    cdfCreateParam(cdfId
        ?name       "Ratio"
        ?prompt     "Ratio"
        ?defValue   200.0
        ?type       "float")
   
    cdfCreateParam(cdfId
        ?name       "PDarea"
        ?prompt     "PDarea"
        ?defValue   1.0
        ?type       "float")

        cdfSaveCDF(cdfId)
    )
            
