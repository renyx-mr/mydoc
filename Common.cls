/// w ##class(web.Test2).password("reg")
ClassMethod password(userCode As %String)
{
    s ok="",aa="",okk=""
    s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),"")) //""的下一个索引
    s pin=$p($G(^SSU("SSUSR",userId)),"^",3) //密码
    s leng=$l(pin)

    f pp=1:1:leng q:okk="1"  d  //a:b:c b到c 从a开始循环
    .s ppp=..Passco(aa,pp,pin) //aa密码 pp某一位密码 pin 密文
    .s aa=$p(ppp,"#",1)
    .s pp=$p(ppp,"#",2)
    .s okk=$p(ppp,"#",3)
    q "用户密码是:"_""_aa
}
