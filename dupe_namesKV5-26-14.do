

*This do file captures duplicate names by SHG name, Member name, and Father/Husban name by village
cd "/Users/kathrynvasilaky/SkyDrive/Kentaro"

*This is to output duplicate names by district
foreach name in MFP Purnia Nalanda{
	display "`name'"
	import excel "/Users/kathrynvasilaky/SkyDrive/Kentaro/SHG_224.xlsx", sheet("`name'") firstrow clear
	
	gen upper_name1=upper(MemberName)
	gen upper_name2=upper(FatherHusband)

	gen tag=.
	levelsof VillageName, local(levels) 
	foreach l of local levels {
		display "`l'"
		*to get duplicates within village, remove SHGName from this command
		duplicates tag upper_name1 upper_name2 SHGName if VillageName=="`l'", gen(tag1)
		replace tag=tag1 if VillageName=="`l'"
		drop tag1
	}
	keep if tag~=0
	sort DistrictName BlockName VillageName SHGName upper_name1
	export excel using "dupe_names_SHG", sheet("`name'", modify) firstrow(variables)
}
