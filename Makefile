NAME = pubnub_test.exe

SRC = pubnub.opp src/plugin/pubnub.opa src/examples/pubnub_chat.opa

all : pubnub opa

pubnub:
	opa-plugin-builder src/plugin/pubnub.js -o pubnub

opa:
	opa $(SRC) -o $(NAME)
	@echo "run: ./pubnub_test.exe"

clean:
	rm -rf pubnub_test.exe
	rm -rf _build _tracks
	rm -rf pubnub.opp
