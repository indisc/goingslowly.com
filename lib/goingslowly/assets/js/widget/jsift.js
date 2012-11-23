/*
 * jsift 0.9.0 - client side filtering
 *
 * Copyright (c) 2008 Tyler Kellen (jsift.com)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 */
(function(){var jsift=window.jsift=function(n,f,o){return new sifter(n,f,o);};function sifter(node,filter,options)
{var sift=this;sift.data={run:false,last:'',deeper:false,broader:false,node:document.getElementById(node),textcache:[]};for(var i in options)sift.options[i]=options[i];if(sift.options.precache)this.build_cache();if(filter)document.getElementById(filter).onkeyup=function(){sift.schedule_sift(this.value);}
return this;};sifter.prototype={options:{minchars:0,delay:200,precache:false,debug:true,debugconsole:'debug'},before:function(){return false;},after:function(){return false;},each:function(n,match){return false;},hide:function(n){n.style.display='none'},show:function(n){n.style.display=''},clean:function(n){return(n.textContent||n.innerText||n.innerHTML.replace(/<\/?[^>]+>/gi,'')).toLowerCase();},build_cache:function()
{var nodes=this.data.node.childNodes;var node=new Object();var n=0;if(node=nodes[n])
{do
{if(node.nodeType==3)continue;this.data.textcache[n]=this.clean(node);}while(node=nodes[++n]);}},parse:function(n,h,c)
{if(this.data.deeper&&h.sifted)
{this.each(h,false);return;}
if(this.data.broader&&!h.sifted)
{this.each(h,true);return;}
if(n==""&&n.sifted)
{h.sifted=false;this.show(h);this.each(h,true);return;}
for(var i=0;i<n.length;i++)if(this.data.textcache[c].indexOf(n[i])==-1)
{h.sifted=true;this.hide(h);this.each(h,false);return;}
h.sifted=false;this.show(h);this.each(h,true);},sift:function(filter)
{var nodes=this.data.node.childNodes;var node=new Object();var n=0;if(!this.data.textcache.length)this.build_cache();this.before();filter=filter.split(' ');if(node=nodes[n])
{do
{if(node.nodeType==3)continue;this.parse(filter,node,n);}while(node=nodes[++n]);}
this.after();},schedule_sift:function(filter)
{var sift=this;filter=filter.toLowerCase();if(this.data.last==filter)return;this.data.deeper=(this.data.last==filter.substring(0,this.data.last.length));this.data.broader=(this.data.last.substring(0,filter.length)==filter);if(this.data.run)clearTimeout(this.data.run);this.data.run=setTimeout(function()
{sift.data.last=(filter.length<sift.options.minchars?'':filter);sift.sift(sift.data.last);},sift.options.delay);}};})();
