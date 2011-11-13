package pubnub

pubnub_publish = %%pubnub.publish%%
pubnub_subscribe = %%pubnub.subscribe%%
pubnub_unsubscribe = %%pubnub.unsubscribe%%
pubnub_history = %%pubnub.history%%
pubnub_uuid = %%pubnub.uuid%%
pubnub_time = %%pubnub.time%%

@client publish_client = pubnub_publish
@client subscribe_client = pubnub_subscribe
@client unsubscribe_client = pubnub_unsubscribe
@client history_client = pubnub_history
@client uuid_client = pubnub_uuid
@client time_client = pubnub_time

PubNub = {{
  publish(channel: string, j : RPC.Json.json) =
    publish_client(channel, Json.to_string(j))

  subscribe(channel: string, callback) =
    subscribe_client(channel, callback)

  unsubscribe(channel: string) =
    unsubscribe_client(channel)

  history(channel: string, limit: int, callback) =
    history_client(channel, limit, callback)

  uuid(callback) =
    uuid_client(callback)

  time(callback) =
    time_client(callback)
}}

do Resource.register_external_js("http://cdn.pubnub.com/pubnub-3.1.min.js")
