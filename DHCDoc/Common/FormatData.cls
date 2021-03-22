Class DHCDoc.Common.FormatData Extends %RegisteredObject
{

ClassMethod JsonList(colDef As MapIndex, list, append = "")
{
	s len=colDef.count()
	w "{"
	s cou=0
	f i=1:1:len {
		s pro=colDef.get(i)
		s t=$g(colDef.map(pro,"Type"),10)
		s v=$lg(list,i)
		w """"_pro_""":"
		if ( (t=3) ||(t=5)||(t=14)||(t=15)||(t=18) ){
			s:v="" v=0
			Write (v)
		}elseif (t=16){
			i ((v=1)||(v="1")||(v="true")) {
				s v="true" 
			}else {
				s v="false"
			}
			Write (v) 
		}else{
			Write ("""")
			s v=..ReplaceStr(v,"'","\'")
			s v=..ReplaceStr(v,"""","\""")
 			s v=..ReplaceStr(v,$c(13),"\n")
			s v=..ReplaceStr(v,$c(10),"\r")
			s v=..ReplaceStr(v,$c(2),"<$C2>")
			s v=..ReplaceStr(v,$c(5),"<$C5>")
			s v=..ReplaceStr(v,$c(7),"<$C7>")
			Write (v)
			Write ("""")
		}
		w:i<len ","
		s cou=cou+1
	}
	i append'="" {
		w:cou>0 ","
		w append
	}
	w "}"
}

ClassMethod Escape(str)
{
	s str=..ReplaceStr(str,"'","\'")
	s str=..ReplaceStr(str,"""","\""")
 	s str=..ReplaceStr(str,$c(13),"\n")
	s str=..ReplaceStr(str,$c(10),"\r")
	s str=..ReplaceStr(str,$c(2),"<$C2>")
	s str=..ReplaceStr(str,$c(5),"<$C5>")
	s str=..ReplaceStr(str,$c(7),"<$C7>")
	q str
}

ClassMethod ReplaceStr2(str, src = "", dem = "") As %String
{
	q:((src="")||(str="")) str
	s strLen=$l(str),srcLen=$l(src),demLen=$l(dem)
	s flag=0
	f i=1:1:strLen {
		s flag=1
		f j=1:1:srcLen {
			if ($e(str,i+j-1)=$e(src,j)){
			}else{
				s flag=0
				q
			}
		}
		if (flag=1){
			s $e(str,i,i+srcLen-1)=dem
			s i=i+demLen-1
		}
	}
	q str
}

ClassMethod ReplaceStr(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

}
