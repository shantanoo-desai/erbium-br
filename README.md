#Erbium Border-Router
This is a border router based on [Contiki OS] (https://github.com/contiki-os)
This border-router uses a **REST Engine** on it using **Erbium** unlike the one in Contiki
 <pre>examples/ipv6/rpl-border-router</pre>
## Difference:
This Border Router is removes the __HTTP-simple__ application running on top of the original file and replaces it with JSON formated __RPL information__.
Hence, instead of accessing: 
<pre>http://[IPv6 Address of Border-Router]</pre> 
in order to get information of neighbouring sensors, we can use any type of CoAP implementation like __[SMCP]__
 (https://github.com/darconeous/smcp)

## Steps
1. Here the testing is done on [Zolertia Z1] (http://sourceforge.zolertia.net)motes
2. This folder should be places in the *examples/* folder of your Contiki Repository (change the Makefile if other place chosen)
3. inside the folder
'''
	make TARGET =z1 erbr.upload

'''
4. after the program is burnt on the Z1 mote connect to border Router with the following code
'''
	make connect-router
'''
for connecting via Cooja Simulator
'''
	make connect-router-cooja
'''
5. Wait till the Prefix is set (usually it will be __aaaa::__) and observe the IPv6 address of the Border Router in the Terminal window
6. to check connection use:
'''
	ping6 aaaa::IPv6:of:the:BorderRouter
'''
7. use the following commands on SMCP:
<pre>
	~$ smcpctl coap://[IPv6 of Border-Router]:5683/
</pre>
8. Inside the multiline environment use the following to access RPL information:
<pre>
	get rplinfo/parents
</pre>
if returned value is __0__ this means it has no parent and it is itself the Border Router.
9. to access the Routing Information use the following:
<pre>
	get rplinfo/routes
</pre>
if returned valued is **greater than 0** then use the following 
<pre>
	get rplinfo/routes?index=(value)
</pre>
sure enough you will be getting the Routing information in JSON format.

### Example:
if the routes value returned is 1 then use
<pre>
	get rplinfo/routes?index=0
</pre>	
if you use __index=1__ then the returned output will be the following: (hence always use __(0 to values-1))
<pre>{}</pre>

# Important configurations:
When you try to upload (burn) the code on the __Z1 mode__ the buffer size will be overflowed by a mere *2 bytes* and error returned will be the following:
'''
	#error "UIP_CONF_BUFFER_SIZE too small for REST_MAX_CHUNK_SIZE"
	make: *** [obj_z1/er-coap-07-engine.o] Error 1
'''

hence in order to fit the code do the following steps

1. go to 
<pre>
	platform/z1/ directory
</pre>
2. open __contiki-conf.h__ file and find ALL __UIP_CONF_BUFFER_SIZE__ and change the value to __240__
3. do the same steps as above mentioned to fit the code and run the code.
