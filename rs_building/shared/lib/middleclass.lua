local a={}local function b(c,d)if d==nil then return c.__instanceDict else return function(self,e)local f=c.__instanceDict[e]if f~=nil then return f elseif type(d)=="function"then return d(self,e)else return d[e]end end end end;local function g(c,e,d)d=e=="__index"and b(c,d)or d;c.__instanceDict[e]=d;for h in pairs(c.subclasses)do if rawget(h.__declaredMethods,e)==nil then g(h,e,d)end end end;local function i(c,e,d)c.__declaredMethods[e]=d;if d==nil and c.super then d=c.super.__instanceDict[e]end;g(c,e,d)end;local function j(self)return"class "..self.name end;local function k(self,...)return self:new(...)end;local function l(e,m)local n={}n.__index=n;local c={name=e,super=m,static={},__instanceDict=n,__declaredMethods={},subclasses=setmetatable({},{__mode='k'})}if m then setmetatable(c.static,{__index=function(o,p)return rawget(n,p)or m.static[p]end})else setmetatable(c.static,{__index=function(o,p)return rawget(n,p)end})end;setmetatable(c,{__index=c.static,__tostring=j,__call=k,__newindex=i})return c end;local function q(c,r)assert(type(r)=='table',"mixin must be a table")for e,s in pairs(r)do if e~="included"and e~="static"then c[e]=s end end;for e,s in pairs(r.static or{})do c.static[e]=s end;if type(r.included)=="function"then r:included(c)end;return c end;local t={__tostring=function(self)return"instance of "..tostring(self.class)end,initialize=function(self,...)end,isInstanceOf=function(self,c)return type(c)=='table'and(c==self.class or self.class:isSubclassOf(c))end,static={allocate=function(self)assert(type(self)=='table',"Make sure that you are using 'Class:allocate' instead of 'Class.allocate'")return setmetatable({class=self},self.__instanceDict)end,new=function(self,...)assert(type(self)=='table',"Make sure that you are using 'Class:new' instead of 'Class.new'")local u=self:allocate()u:initialize(...)return u end,subclass=function(self,e)assert(type(self)=='table',"Make sure that you are using 'Class:subclass' instead of 'Class.subclass'")assert(type(e)=="string","You must provide a name(string) for your class")local h=l(e,self)for v,d in pairs(self.__instanceDict)do g(h,v,d)end;h.initialize=function(u,...)return self.initialize(u,...)end;self.subclasses[h]=true;self:subclassed(h)return h end,subclassed=function(self,w)end,isSubclassOf=function(self,w)return type(w)=='table'and type(self.super)=='table'and(self.super==w or self.super:isSubclassOf(w))end,include=function(self,...)assert(type(self)=='table',"Make sure you that you are using 'Class:include' instead of 'Class.include'")for o,r in ipairs({...})do q(self,r)end;return self end}}function a.class(e,m)assert(type(e)=='string',"A name (string) is needed for the new class")return m and m:subclass(e)or q(l(e),t)end;setmetatable(a,{__call=function(o,...)return a.class(...)end})_G["class"]=a
