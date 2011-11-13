
import pubnub

import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap


action() =
  s = Dom.get_value(#input)
  username : RPC.Json.json = {String = "tristan"}
  message : RPC.Json.json = {String = s}
  record_json : RPC.Json.json = {Record = [("username", username), ("message", message)]}
  PubNub.publish("chat", record_json)

button(id, message) =
  <a id={id:string}
     class="button"
     ref="#"
     onclick={_ -> action() }>{message:string}
  </a>

add(x) =
  match Json.deserialize(x) with
  | {some={Record = [("username", username), ("message", message)]}} -> Dom.transform([ #box +<- Json.to_string(message) ])
  | {some=_} -> Dom.transform([ #box <- "fail" ])
  | {none} -> Dom.transform([ #box <- "none" ])

page() =
  <>
  <div id=pubnub pub-key=demo sub-key=demo onready={_ -> PubNub.subscribe("chat", (x -> add(x))) }></div>
  <div><input id=input placeholder=you-chat-here /></div>
  <div id=box></div>
  {button("publish_client", "Send Message")}
  </>

WB = WBootstrap

common_unit =
  <div class="hero-unit">
    <h1>Hello, world!</h1>
    <p>Vestibulum id ligula porta felis euismod semper. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.</p>
    <p><a class="btn primary large">Learn more »</a></p>
  </div>

common_row = WB.Grid.row([
  {span=6 offset=none content=
   <h2>Heading</h2>
   <p>Etiam porta sem malesuada magna mollis euismod. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.</p>
   <p><a class="btn" href="#">View details »</a></p>},
  {span=5 offset=none content=
   <h2>Heading</h2>
    <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
   <p><a class="btn" href="#">View details »</a></p>},
  {span=5 offset=none content=
   <h2>Heading</h2>
   <p>Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
   <p><a class="btn" href="#">View details »</a></p>}
])

common_footer =
  <footer>
    <p>© Company 2011</p>
  </footer>

conatainer_app_content =
  WB.Div.content(
    WB.Div.page_header(1, "Page name", some("Supporting text or tagline")) <+>
    WB.Grid.row([
      {span=10 offset=none content=<div><h2>Chat</h2><ul id="box"></ul><div id=pubnub pub-key=demo sub-key=demo onready={_ -> PubNub.subscribe("chat", (x -> add(x))) }></div><div><input id=input placeholder=you-chat-here /></div>{button("publish_client", "Send Message")}</div>},
      {span=4 offset=none content=<h3>Users</h3>}
    ])
  ) <+>
  common_footer

container_app() =
  WB.Navigation.topbar(
    WB.Layout.fixed(
      WB.Navigation.brand(<>Project name</>, some("/container-app"), ignore) <+>
      WB.Navigation.nav([
        {active=<>Home</> href=some("#") onclick=ignore},
        {inactive=<>About</> href=some("#about") onclick=ignore},
        {inactive=<>Contact</> href=some("#contact") onclick=ignore}
      ]) <+>
      (<form action="">
        <input class="input-small" type="text" placeholder="Username"/>
        <input class="input-small" type="password" placeholder="Password"/>
        <button class="btn" type="submit">Sign in</button>
      </form> |> WB.pull_right(_))
    )
  ) <+>
  WB.Layout.fixed(conatainer_app_content)

server = one_page_server("Hello Bindings", container_app)
