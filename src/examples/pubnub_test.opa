pubnub_publish = %%pubnub.publish%%
pubnub_subscribe = %%pubnub.subscribe%%
pubnub_history = %%pubnub.history%%

@client publish_client = pubnub_publish
@client subscribe_client = pubnub_subscribe
@client history_client = pubnub_history

action() =
         history_client("chat", 10, (x -> Dom.transform([ #box <- x])))

/*  s = Dom.get_value(#input)
  username : RPC.Json.json = {String = "tristan"}
  message : RPC.Json.json = {String = s}
  record_json : RPC.Json.json = {Record = [("username", username), ("message", message)]}
  publish(record_json)
*/

publish(j : RPC.Json.json) =
  publish_client("chat", Json.to_string(j))

button(id, message) =
  <a id={id:string} 
     class="button"
     ref="#"
     onclick={_ -> action() }>{message:string}
  </a>

add(x) =
  match Json.deserialize(x) with
  | {some={Record = [("username", username), ("message", message)]}} -> Dom.transform([ #box <- Json.to_string(message) ])
  | {some=_} -> Dom.transform([ #box <- "fail" ])
  | {none} -> Dom.transform([ #box <- "none" ])

page() =
  <>
  <div id=pubnub pub-key=demo sub-key=demo onready={_ -> subscribe_client("chat", (x -> add(x))) }></div>
  <div><input id=input placeholder=you-chat-here /></div>
  <div id=box></div>    
  {button("publish_client", "Send Message")}   
  </>

do Resource.register_external_js("http://cdn.pubnub.com/pubnub-3.1.min.js")
server = one_page_server("Hello Bindings", page)
