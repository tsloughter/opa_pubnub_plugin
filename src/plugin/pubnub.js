// This is an Javascript file, containing opa preprocessing directives
##extern-type llarray('a)
//' Declare llarray as an external type

##register publish : string, string -> void
##args(c, m)
{
    PUBNUB.publish({
		       channel : c, message : m
		   });

    return js_void;
}

##register subscribe : string, (string -> void) -> void
##args(c, callback)
{
    PUBNUB.subscribe({
			 channel  : c,
			 callback : callback
		     });

    return js_void;
}

##register unsubscribe : string -> void
##args(channel)
{
    PUBNUB.unsubscribe({ channel : channel });

    return js_void;
}

// Callback history doesn't take a string as argument but a low level javascript array
##register history : string, int, (llarray(string) -> void) -> void
##args(channel, limit, callback)
{
    PUBNUB.history({
		       channel : channel,
		       limit   : limit
		   }, callback);

    return js_void;
}

##register uuid : (string -> void) -> void
##args(callback)
{
    PUBNUB.uuid(callback);

    return js_void;
}

##register time : (int -> void) -> void
##args(callback)
{
    PUBNUB.time(callback);

    return js_void;
}
