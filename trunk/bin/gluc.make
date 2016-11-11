GLUC = ./bin/glucsrc/gluc
DATA = ./Data/
MAPS = ./gluc/DriverOutput/Maps/

start:
	r.mapcalc change=0
	r.out.gdal input=change output=${MAPS}change.bil format=EHdr type=Byte
	r.mapcalc summary=0
	r.out.gdal input=summary output=${MAPS}summary.bil format=EHdr type=Byte
	r.mapcalc ppcell=0.0
	r.mapcalc hhcell=0.0
	r.mapcalc empcell=0.0
	r.mapcalc year=0

growth:
	${GLUC} -r -d -ppath . -p gluc -ci ${PROJID}.conf
	r.in.gdal --overwrite input=${MAPS}change.bil output=${PROJID}_change
	r.in.gdal --overwrite input=${MAPS}summary.bil output=${PROJID}_summary
	r.mapcalc "${PROJID}_ppcell=if(${PROJID}_change==21,pop_density,0)"
	r.mapcalc "${PROJID}_hhcell=${PROJID}_ppcell/2.6"
	r.mapcalc "${PROJID}_empcell=if(${PROJID}_change==23,emp_density,0)"
	r.mapcalc "${PROJID}_year=if(${PROJID}_summary>0,${PROJID}_summary+${START},0)"
	
	r.out.gdal input=${PROJID}_change output=${DATA}${PROJID}_change.tif type=UInt16
	r.out.gdal input=${PROJID}_summary output=${DATA}${PROJID}_summary.tif type=UInt16
	r.out.gdal input=${PROJID}_ppcell output=${DATA}${PROJID}_ppcell.tif type=UInt16
	r.out.gdal input=${PROJID}_empcell output=${DATA}${PROJID}_empcell.tif type=UInt16
	r.out.gdal input=${PROJID}_year output=${DATA}${PROJID}_year.tif type=UInt16

	r.out.ascii -i input=${PROJID}_change output=${DATA}${PROJID}_change.txt null=-1
	r.out.ascii -i input=${PROJID}_summary output=${DATA}${PROJID}_summary.txt null=-1
	r.out.ascii -i input=${PROJID}_ppcell output=${DATA}${PROJID}_ppcell.txt null=-1
	r.out.ascii -i input=${PROJID}_empcell output=${DATA}${PROJID}_empcell.txt null=-1
	r.out.ascii -i input=${PROJID}_year output=${DATA}${PROJID}_year.txt null=-1



