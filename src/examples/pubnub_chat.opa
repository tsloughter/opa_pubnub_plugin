import pubnub

user_update(x) =
  match Json.deserialize(x) with
         | {some={Record = [("username", username), ("message", message)]}} ->
                    line = <div class="line">
                             <div class="user">{Json.to_string(username)}:</>
                             <div class="message">{Json.to_string(message)}</>
                            </>
                    do Dom.transform([#conversation +<- line ])
                    Dom.scroll_to_bottom(#conversation)
         | _ -> void

user_update_2(x) =
  match x with
         | {Record = [("username", username), ("message", message)]} ->
                    void
         | {String = s}->
                    void
         | _ -> void

broadcast(author, msg) =
   username : RPC.Json.json = {String = author}
   message : RPC.Json.json = {String = msg}
   record_json : RPC.Json.json = {Record = [("username", username), ("message", message)]}
   do PubNub.publish("chat", record_json)
   Dom.clear_value(#entry)

add_history(x: string) =
  match Json.deserialize(x) with
         | {some={List=history}} ->
                  do List.iter(user_update_2, history)
                  void
         | _ -> void

launch(author) =
   init_client() =
     //do PubNub.history("chat", 20, (h -> add_history(h)))
     PubNub.subscribe("chat", (x -> user_update(x)))
   send_message() =
     broadcast(author, Dom.get_value(#entry))
   logout() =
     do broadcast("system", "{author} has left the room")
     Dom.transform([#main <- <a class="button" href="/">Reconnect</a>])
   <div id=#header><div id=#logo></div>
     <div class="button" onclick={_ -> logout()}>Logout</div>
   </div>
   <div id=#conversation onready={_ -> init_client()}></div>
   <input id=#entry  onnewline={_ -> send_message()}/>
   <div class="button" onclick={_ -> send_message()}>Send</div>

start() =
   go(_) =
     author = Dom.get_value(#author)
     do Dom.transform([#main <- launch(author)])
     broadcast("system", "{author} is connected to the room")
   <div id=#main>
     <div id=#header><div id=#logo></div>Choose your name:<input id=#author onnewline={go}/></div>
     <div class="button" onclick={go}>Launch</div>
   </div>

server = Server.one_page_bundle("Chat",
       [@static_resource_directory("src/examples/resources")],
       ["src/examples/resources/css.css"], start)
