;---------------------------------------------------------------------->
;+
; PROJECT:  	SolarMonitor
;
; PROCEDURE:    MINDEX2MAP
;
; PURPOSE:    	A wrapper for INDEX2MAP which maintains all of the original header 
;				information contained in the input index. INDEX2MAP leaves some out.
;
; USEAGE:     	mindex2map, index, data, map
;
; INPUT:        
;				INDEX		- A header structure output from routines such as MREADFITS.
;
;				DATA		- The image contained in the FITS file.
;
; KEYWORDS:   	
;				QUIET		- Do not print the EXECUTE() errors to the terminal.
;
; OUTPUT:    
;   	    	MAP			- The output (Zarro) image map structure with a complete 
;							FITS header.  
;   	    	
; EXAMPLE:    	
;				IDL> mreadfits,'soho_image.fits',index,data
;				IDL> mindex2map, index, data, map, /quiet
;         
; AUTHOR:     	10-Nov-2009 P.A.Higgins - Written
;				02-Aug-2012 PAH - switched from execute to using native CREATE_STRUCT routine
;
; CONTACT:		info@solarmonitor.org
;
; VERSION   	0.0
;-
;---------------------------------------------------------------------->

pro mindex2map, inindex, indata, outmap, quiet=quiet

if keyword_set(quiet) then begin & doquiet1=1 & doquiet2=1 & endif else begin 
	doquiet1=0 & doquiet2=0 & endelse

data=indata
index=inindex

index2map,index,data,map

;Find if there are any overlapping tag names (keep the map one if overlap is found)
mtags=tag_names(map)
itags=tag_names(index)
match,mtags,itags,wm,wi

;Run through and add tags one at a time to map (skipping if overlap is found)
for i=0,n_elements(itags)-1 do $
	if (where(wi eq i))[0] eq -1 then map=create_struct(map,itags[i],index.(i))

;for i=0,ntags-1 do begin
;	exstring='add_prop,map,'+tags[i]+'=index.(i)'
;	err = execute(exstring, doquiet1, doquiet2)
;endfor

outmap=map


end