cd "/Users/kathrynvasilaky/SkyDrive/Kentaro"
import excel "/Users/kathrynvasilaky/SkyDrive/Kentaro/SHG_224.xlsx", sheet(All) firstrow clear
duplicates drop DistrictName BlockName VillageName, force
keep DistrictName BlockName VillageName
gen SHGDistrict=upper(DistrictName)
gen SHGBlock =upper(BlockName)
gen SHGVillage=upper(VillageName)
gen district= SHGDistrict
gen block= SHGBlock
gen village= SHGVillage
*keep SHGDistrict SHGBlock SHGVillage
gen n=_n

replace block="BIHARSHARIF" if block=="BIHARSARIF"
replace block="NAGARNAUSA"  if block=="NAGAR NOUSA"
replace block="NOORSARAI"  if block=="NOORSARAI"
replace block="BANMAKHI"  if block=="BANMANKHI"
replace block="B' KOTHI"  if block=="BARHARA KOTHI"
replace block="DAMDAHA"  if block=="DHAMDAHA"


tempfile SHG224
save "`SHG224'"


import excel "/Users/kathrynvasilaky/SkyDrive/Kentaro/5.2.2014Finalrandomized.xlsx", sheet("Sheet2") firstrow clear
duplicates drop DistrictName BlockName VillageName, force
keep DistrictName BlockName VillageName
gen FinalDistrict=upper(DistrictName)
gen FinalBlock=upper(BlockName)
gen FinalVillage=upper(VillageName)
gen district= FinalDistrict
gen block= FinalBlock
gen village= FinalVillage

*keep FinalDistrict FinalBlock FinalVillage
gen n=_n

merge 1:1 district block village  using "`SHG224'"
*merge 1:1   using "`SHG224'"
*export excel using "NameMatch", firstrow(variables) replace
